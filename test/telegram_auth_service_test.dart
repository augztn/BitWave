import 'package:bitwave/src/core/models/telegram_chat.dart';
import 'package:bitwave/src/core/models/track.dart';
import 'package:bitwave/src/core/telegram/telegram_auth_service.dart';
import 'package:bitwave/src/core/telegram/telegram_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeGateway gateway;
  late _FakeCredentialsRepository credentials;
  late TelegramAuthService service;

  setUp(() {
    gateway = _FakeGateway();
    credentials = _FakeCredentialsRepository();
    service = TelegramAuthService(
      gateway: gateway,
      credentialsStore: credentials,
    );
  });

  test('stores normalized credentials and initializes the gateway', () async {
    await service.connect(
      const TelegramCredentials(apiId: 12345, apiHash: '  api-hash  '),
    );

    expect(credentials.saved?.apiId, 12345);
    expect(credentials.saved?.apiHash, 'api-hash');
    expect(gateway.initializedApiId, 12345);
    expect(gateway.initializedApiHash, 'api-hash');
  });

  test('rejects invalid API credentials before saving', () async {
    await expectLater(
      service.connect(const TelegramCredentials(apiId: 0, apiHash: 'hash')),
      throwsArgumentError,
    );
    expect(credentials.saved, isNull);
    expect(gateway.initializedApiId, isNull);
  });

  test('trims and submits a valid international phone number', () async {
    await service.submitPhoneNumber('  +919876543210  ');
    expect(gateway.phoneNumber, '+919876543210');
  });

  test('rejects invalid international phone numbers', () {
    expect(service.submitPhoneNumber('9876543210'), throwsArgumentError);
    expect(service.submitPhoneNumber('+0123456789'), throwsArgumentError);
    expect(service.submitPhoneNumber('+123'), throwsArgumentError);
  });

  test('removes whitespace from a valid verification code', () async {
    await service.submitCode(' 12 34 56 ');
    expect(gateway.code, '123456');
  });

  test('rejects malformed verification codes', () {
    expect(service.submitCode('12ab'), throwsArgumentError);
    expect(service.submitCode('123'), throwsArgumentError);
    expect(service.submitCode('123456789'), throwsArgumentError);
  });

  test('rejects empty and oversized two-step passwords', () {
    expect(service.submitPassword(''), throwsArgumentError);
    expect(service.submitPassword('x' * 257), throwsArgumentError);
  });

  test('clears saved credentials even if Telegram logout fails', () async {
    gateway.failLogout = true;
    await expectLater(service.logout(), throwsStateError);
    expect(credentials.cleared, isTrue);
  });
}

class _FakeCredentialsRepository implements TelegramCredentialsRepository {
  bool cleared = false;
  TelegramCredentials? saved;

  @override
  Future<void> clear() async {
    cleared = true;
  }

  @override
  Future<TelegramCredentials?> read() async => null;

  @override
  Future<void> save(TelegramCredentials credentials) async {
    saved = credentials;
  }
}

class _FakeGateway implements TelegramGateway {
  String? phoneNumber;
  String? code;
  bool failLogout = false;
  int? initializedApiId;
  String? initializedApiHash;

  @override
  Stream<TelegramAuthSnapshot> get authorization =>
      const Stream<TelegramAuthSnapshot>.empty();

  @override
  Future<void> submitPhoneNumber(String value) async {
    phoneNumber = value;
  }

  @override
  Future<void> submitCode(String value) async {
    code = value;
  }

  @override
  Future<void> logout() async {
    if (failLogout) throw StateError('logout failed');
  }

  @override
  Future<void> close() async {}

  @override
  Future<TelegramChat> createPrivateMusicChannel(String title) =>
      throw UnimplementedError();

  @override
  Future<void> initialize({
    required int apiId,
    required String apiHash,
  }) async {
    initializedApiId = apiId;
    initializedApiHash = apiHash;
  }

  @override
  Future<String> ensureDownloaded(Track track) => throw UnimplementedError();

  @override
  Future<List<TelegramChat>> listChats({String? query}) =>
      throw UnimplementedError();

  @override
  Future<List<Track>> searchMusic(String query, {int limit = 100}) =>
      throw UnimplementedError();

  @override
  Future<void> setSelectedChats(Set<int> chatIds) async {}

  @override
  Future<void> submitPassword(String password) async {}
}
