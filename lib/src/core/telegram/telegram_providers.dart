import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'telegram_gateway.dart';

final telegramGatewayProvider = Provider<TelegramGateway>(
  (ref) => const TelegramGatewayUnavailable(),
);
