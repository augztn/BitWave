class TelegramSearchPolicy {
  const TelegramSearchPolicy({
    this.maxQueryLength = 256,
    this.maxSelectedChats = 100,
    this.maxResults = 200,
    this.maxConcurrentSearches = 3,
  });

  final int maxQueryLength;
  final int maxSelectedChats;
  final int maxResults;
  final int maxConcurrentSearches;

  SearchRequest validate(String query, Set<int> selectedChatIds, {int? limit}) {
    final normalized = query.trim();
    if (normalized.length > maxQueryLength) {
      throw ArgumentError.value(query, 'query', 'Search text is too long.');
    }
    final chats = selectedChatIds.where((id) => id != 0).toSet().toList()..sort();
    if (chats.length > maxSelectedChats) {
      throw ArgumentError.value(
        selectedChatIds,
        'selectedChatIds',
        'Select at most $maxSelectedChats music chats.',
      );
    }
    final safeLimit = (limit ?? maxResults).clamp(1, maxResults);
    return SearchRequest(
      query: normalized,
      chatIds: List.unmodifiable(chats),
      limit: safeLimit,
    );
  }
}

class SearchRequest {
  const SearchRequest({
    required this.query,
    required this.chatIds,
    required this.limit,
  });

  final String query;
  final List<int> chatIds;
  final int limit;
}
