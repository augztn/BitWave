import '../models/telegram_chat.dart';
import '../models/track.dart';

enum TelegramAuthState {
  waitingForParameters,
  waitingForPhoneNumber,
  waitingForCode,
  waitingForPassword,
  ready,
  loggingOut,
  closed,
  error,
}

class TelegramAuthSnapshot {
  const TelegramAuthSnapshot({required this.state, this.message});

  final TelegramAuthState state;
  final String? message;
}

abstract interface class TelegramGateway {
  Stream<TelegramAuthSnapshot> get authorization;
  Future<void> initialize({required int apiId, required String apiHash});
  Future<void> submitPhoneNumber(String phoneNumber);
  Future<void> submitCode(String code);
  Future<void> submitPassword(String password);
  Future<List<TelegramChat>> listChats({String? query});
  Future<void> setSelectedChats(Set<int> chatIds);
  Future<TelegramChat> createPrivateMusicChannel(String title);
  Future<List<Track>> searchMusic(String query, {int limit = 100});
  Future<String> ensureDownloaded(Track track);
  Future<void> logout();
  Future<void> close();
}

class TelegramGatewayUnavailable implements TelegramGateway {
  const TelegramGatewayUnavailable();

  @override
  Stream<TelegramAuthSnapshot> get authorization =>
      const Stream<TelegramAuthSnapshot>.empty();

  Never _unavailable() => throw UnsupportedError(
        'Native Telegram TDLib adapter is not installed for this platform.',
      );

  @override
  Future<void> initialize({required int apiId, required String apiHash}) async => _unavailable();
  @override
  Future<void> submitPhoneNumber(String phoneNumber) async => _unavailable();
  @override
  Future<void> submitCode(String code) async => _unavailable();
  @override
  Future<void> submitPassword(String password) async => _unavailable();
  @override
  Future<List<TelegramChat>> listChats({String? query}) async => _unavailable();
  @override
  Future<void> setSelectedChats(Set<int> chatIds) async => _unavailable();
  @override
  Future<List<Track>> searchMusic(String query, {int limit = 100}) async => _unavailable();
  @override
  Future<String> ensureDownloaded(Track track) async => _unavailable();
  @override
  Future<void> logout() async => _unavailable();
  @override
  Future<void> close() async => _unavailable();
}
