import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tdlib_method_channel_gateway.dart';
import 'telegram_gateway.dart';

final telegramGatewayProvider = Provider<TelegramGateway>((ref) {
  final gateway = TdlibMethodChannelGateway();
  ref.onDispose(() {
    gateway.close();
  });
  return gateway;
});

final telegramAuthorizationProvider =
    StreamProvider<TelegramAuthSnapshot>((ref) {
  return ref.watch(telegramGatewayProvider).authorization;
});
