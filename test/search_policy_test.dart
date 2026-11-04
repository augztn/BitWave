import 'package:bitwave/src/core/telegram/search_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = TelegramSearchPolicy();

  test('normalizes query and returns deterministic selected chats', () {
    final request = policy.validate('  synthwave ', {4, -100123, 2});
    expect(request.query, 'synthwave');
    expect(request.chatIds, [-100123, 2, 4]);
    expect(request.limit, 200);
  });

  test('rejects oversized query', () {
    expect(() => policy.validate('x' * 257, {1}), throwsArgumentError);
  });

  test('rejects excessive selected chats', () {
    expect(
      () => policy.validate('', {for (var id = 1; id <= 101; id++) id}),
      throwsArgumentError,
    );
  });

  test('rejects zero chat ids', () {
    expect(() => policy.validate('', {0}), throwsArgumentError);
  });

  test('caps result count and rejects non-positive result limits', () {
    expect(policy.validate('x', {1}, limit: 1000).limit, 200);
    expect(() => policy.validate('x', {1}, limit: 0), throwsArgumentError);
  });
}
