class TelegramSearchPolicy {
  const TelegramSearchPolicy({
    this.maxQueryLength = 256,
    this.maxSelectedChats = 100,
    this.maxResults = 200,
    this.maxConcurrentSearches = 3,
  }) : assert(maxQueryLength > 0),
       assert(maxSelectedChats > 0),
       assert(maxResults > 0),
       assert(maxConcurrentSearches > 0);

  final int maxQueryLength;
  final int maxSelectedChats;
  final int maxResults;
  final int maxConcurrentSearches;

  SearchRequest validate(String query, Set<int> selectedChatIds, {int? limit}) {
    final normalized = query.trim();
    if (normalized.length > maxQueryLength) {
      throw ArgumentError.value(query, 'query', 'Search text is too long.');
    }
    if (selectedChatIds.contains(0)) {
      throw ArgumentError.value(selectedChatIds, 'selectedChatIds', 'Invalid chat identifier.');
    }
    final chats = selectedChatIds.toList()..sort();
    if (chats.length > maxSelectedChats) {
      throw ArgumentError.value(
        selectedChatIds,
        'selectedChatIds',
        'Select at most $maxSelectedChats music chats.',
      );
    }
    final requestedLimit = limit ?? maxResults;
    if (requestedLimit < 1) {
      throw ArgumentError.value(limit, 'limit', 'Result limit must be positive.');
    }
    return SearchRequest(
      query: normalized,
      chatIds: List.unmodifiable(chats),
      limit: requestedLimit.clamp(1, maxResults),
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
