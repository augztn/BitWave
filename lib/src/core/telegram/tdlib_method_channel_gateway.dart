import 'dart:async';

import 'package:flutter/services.dart';

import '../models/telegram_chat.dart';
import '../models/track.dart';
import 'telegram_gateway.dart';

/// Dart-side TDLib boundary. Native implementations must be provided
/// independently for Android (JNI/TDLib) and Linux (libtdjson).
class TdlibMethodChannelGateway implements TelegramGateway {
  TdlibMethodChannelGateway({
    MethodChannel? methodChannel,
    EventChannel? eventChannel,
  })  : _methods = methodChannel ?? const MethodChannel('bitwave/tdlib'),
        _events = eventChannel ?? const EventChannel('bitwave/tdlib/events') {
    _eventSubscription = _events.receiveBroadcastStream().listen(
      _handleEvent,
      onError: _handleEventError,
    );
  }

  final MethodChannel _methods;
  final EventChannel _events;
  final StreamController<TelegramAuthSnapshot> _authController =
      StreamController<TelegramAuthSnapshot>.broadcast();
  StreamSubscription<Object?>? _eventSubscription;
  TelegramAuthSnapshot _lastAuth =
      const TelegramAuthSnapshot(state: TelegramAuthState.closed);
  bool _closed = false;

  @override
  Stream<TelegramAuthSnapshot> get authorization async* {
    yield _lastAuth;
    yield* _authController.stream;
  }

  void _handleEvent(Object? event) {
    if (event is! Map) return;
    final payload = Map<String, Object?>.from(event);
    if (payload['type'] != 'authorization') return;
    final rawState = payload['state'];
    final state = TelegramAuthState.values.where((value) => value.name == rawState);
    if (state.isEmpty) return;
    _lastAuth = TelegramAuthSnapshot(
      state: state.first,
      message: payload['message'] is String ? payload['message'] as String : null,
    );
    if (!_authController.isClosed) _authController.add(_lastAuth);
  }

  void _handleEventError(Object error, StackTrace stackTrace) {
    _lastAuth = TelegramAuthSnapshot(
      state: TelegramAuthState.error,
      message: 'Telegram connection event stream failed.',
    );
    if (!_authController.isClosed) _authController.add(_lastAuth);
  }

  Future<T> _invoke<T>(String method, [Map<String, Object?>? arguments]) async {
    if (_closed) throw StateError('Telegram gateway is closed.');
    try {
      final result = await _methods.invokeMethod<T>(method, arguments);
      if (result == null && T != dynamic && T != void) {
        throw StateError('TDLib method $method returned no result.');
      }
      return result as T;
    } on PlatformException catch (error) {
      throw TelegramGatewayException(
        code: error.code,
        message: error.message ?? 'Telegram operation failed.',
      );
    }
  }

  @override
  Future<void> initialize({required int apiId, required String apiHash}) =>
      _invoke<void>('initialize', {'apiId': apiId, 'apiHash': apiHash});

  @override
  Future<void> submitPhoneNumber(String phoneNumber) =>
      _invoke<void>('submitPhoneNumber', {'phoneNumber': phoneNumber});

  @override
  Future<void> submitCode(String code) =>
      _invoke<void>('submitCode', {'code': code});

  @override
  Future<void> submitPassword(String password) =>
      _invoke<void>('submitPassword', {'password': password});

  @override
  Future<List<TelegramChat>> listChats({String? query}) async {
    final values = await _invoke<List<Object?>>('listChats', {'query': query});
    return values.whereType<Map>().map((value) {
      final item = Map<String, Object?>.from(value);
      return TelegramChat(
        id: item['id'] as int,
        title: item['title'] as String? ?? 'Untitled chat',
        type: item['type'] as String? ?? 'unknown',
        username: item['username'] as String?,
      );
    }).toList(growable: false);
  }

  @override
  Future<void> setSelectedChats(Set<int> chatIds) =>
      _invoke<void>('setSelectedChats', {'chatIds': chatIds.toList()});

  @override
  Future<TelegramChat> createPrivateMusicChannel(String title) async {
    final value = await _invoke<Map<Object?, Object?>>(
      'createPrivateMusicChannel',
      {'title': title},
    );
    final item = Map<String, Object?>.from(value);
    return TelegramChat(
      id: item['id'] as int,
      title: item['title'] as String? ?? title,
      type: item['type'] as String? ?? 'channel',
      username: item['username'] as String?,
    );
  }

  @override
  Future<List<Track>> searchMusic(String query, {int limit = 100}) async {
    final values = await _invoke<List<Object?>>(
      'searchMusic',
      {'query': query, 'limit': limit},
    );
    return values.whereType<Map>().map(_trackFromMap).toList(growable: false);
  }

  Track _trackFromMap(Map value) {
    final item = Map<String, Object?>.from(value);
    return Track(
      id: item['id'] as String,
      title: item['title'] as String? ?? 'Unknown track',
      artist: item['artist'] as String? ?? 'Unknown artist',
      album: item['album'] as String?,
      duration: Duration(seconds: item['durationSeconds'] as int? ?? 0),
      telegramChatId: item['chatId'] as int,
      telegramMessageId: item['messageId'] as int,
      fileName: item['fileName'] as String?,
      mimeType: item['mimeType'] as String?,
      fileSize: item['fileSize'] as int?,
      localPath: item['localPath'] as String?,
      remoteFileId: item['remoteFileId'] as int?,
    );
  }

  @override
  Future<String> ensureDownloaded(Track track) =>
      _invoke<String>('ensureDownloaded', {
        'chatId': track.telegramChatId,
        'messageId': track.telegramMessageId,
        'remoteFileId': track.remoteFileId,
      });

  @override
  Future<void> logout() => _invoke<void>('logout');

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _eventSubscription?.cancel();
    try {
      await _methods.invokeMethod<void>('close');
    } on PlatformException {
      // Native shutdown is best-effort; the Dart stream must still close.
    } finally {
      await _authController.close();
    }
  }
}

class TelegramGatewayException implements Exception {
  const TelegramGatewayException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() => 'TelegramGatewayException($code): $message';
}
