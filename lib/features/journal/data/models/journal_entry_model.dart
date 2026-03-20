import 'package:hive/hive.dart';
import '../../domain/entities/journal_entry.dart';

part 'journal_entry_model.g.dart';

@HiveType(typeId: 8)
class JournalEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime? updateAt;

  @HiveField(4)
  final List<String> tags;

  JournalEntryModel ({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updateAt,
    required this.tags,
  });

  factory JournalEntryModel.fromEntity(JournalEntry entity) {
    return JournalEntryModel(
      id: entity.id,
      content: entity.content,
      createdAt: entity.createdAt,
      updateAt: entity.createdAt,
      tags: entity.tags,
    );
  }

  JournalEntry toEntity() {
    return JournalEntry(
      id: id,
      content: content,
      createdAt: createdAt,
      updateAt: updateAt,
      tags: tags,
    );
  }


}
