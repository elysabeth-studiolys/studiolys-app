class JournalEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? updateAt;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updateAt,
    this.tags = const[]
  });

  JournalEntry copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updateAt,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updateAt: updateAt ?? this.updateAt,
      tags: tags ?? this.tags,
    );
  }

}