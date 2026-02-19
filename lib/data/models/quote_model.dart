class QuoteModel {
  final String content;
  final String author;

  QuoteModel({required this.content, required this.author});

  // Factory constructor that can handle both List and Map responses
  factory QuoteModel.fromJson(dynamic json) {
    // If it's a List (like ZenQuotes)
    if (json is List) {
      if (json.isNotEmpty) {
        final item = json.first;
        return QuoteModel(
          content: item['q'] ?? item['content'] ?? '',
          author: item['a'] ?? item['author'] ?? 'Unknown',
        );
      }
    }

    // If it's a Map (like Quotable API)
    if (json is Map<String, dynamic>) {
      return QuoteModel(
        content: json['q'] ?? json['content'] ?? '',
        author: json['a'] ?? json['author'] ?? 'Unknown',
      );
    }

    return QuoteModel(content: '', author: 'Unknown');
  }
}