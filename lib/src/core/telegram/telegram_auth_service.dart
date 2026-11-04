import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'telegram_gateway.dart';

class TelegramCredentials {
  const TelegramCredentials({required this.apiId, required this.apiHash});

  final int apiId;
  final String apiHash;
}

abstract interface class TelegramCredentialsRepository {
  Future<void> save(TelegramCredentials credentials);
  Future<TelegramCredentials?> read();
  Future<void> clear();
}

class TelegramCredentialsStore implements TelegramCredentialsRepository {
  TelegramCredentialsStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _apiIdKey = 'telegram.api_id';
  static const _apiHashKey = 'telegram.api_hash';
  final FlutterSecureStorage _storage;

  @override
  Future<void> save(TelegramCredentials credentials) async {
    if (credentials.apiId <= 0 || credentials.apiHash.trim().isEmpty) {
      throw ArgumentError('A valid Telegram API ID and API hash are required.');
    }
    await _storage.write(key: _apiIdKey, value: credentials.apiId.toString());
    await _storage.write(key: _apiHashKey, value: credentials.apiHash.trim());
  }

  @override
  Future<TelegramCredentials?> read() async {
    final idValue = await _storage.read(key: _apiIdKey);
    final hash = await _storage.read(key: _apiHashKey);
    final id = int.tryParse(idValue ?? '');
    if (id == null || id <= 0 || hash == null || hash.isEmpty) return null;
    return TelegramCredentials(apiId: id, apiHash: hash);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _apiIdKey);
    await _storage.delete(key: _apiHashKey);
  }
}

class TelegramAuthService {
  const TelegramAuthService({
    required TelegramGateway gateway,
    required TelegramCredentialsRepository credentialsStore,
  })  : _gateway = gateway,
        _credentialsStore = credentialsStore;

  final TelegramGateway _gateway;
  final TelegramCredentialsRepository _credentialsStore;

  Future<void> connect(TelegramCredentials credentials) async {
    await _credentialsStore.save(credentials);
    await _gateway.initialize(
      apiId: credentials.apiId,
      apiHash: credentials.apiHash,
    );
  }

  Future<void> submitPhoneNumber(String phone) async {
    final normalized = phone.trim();
    if (!RegExp(r'^\+[1-9][0-9]{6,14}$').hasMatch(normalized)) {
      throw ArgumentError.value(
        phone,
        'phone',
        'Enter a valid international phone number.',
      );
    }
    await _gateway.submitPhoneNumber(normalized);
  }

  Future<void> submitCode(String code) async {
    final normalized = code.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9]{4,8}$').hasMatch(normalized)) {
      throw ArgumentError.value(
        code,
        'code',
        'Enter the Telegram verification code.',
      );
    }
    await _gateway.submitCode(normalized);
  }

  Future<void> submitPassword(String password) async {
    if (password.isEmpty || password.length > 256) {
      throw ArgumentError.value(
        password,
        'password',
        'Invalid two-step verification password.',
      );
    }
    await _gateway.submitPassword(password);
  }

  Future<void> logout() async {
    try {
      await _gateway.logout();
    } finally {
      await _credentialsStore.clear();
    }
  }
}
