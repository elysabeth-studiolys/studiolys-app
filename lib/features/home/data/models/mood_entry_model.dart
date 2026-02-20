import 'package:hive/hive.dart';
import '../../../../core/services/storage/storage_keys.dart';
import '../../domain/entities/mood_entry.dart';

part 'mood_entry_model.g.dart';

@HiveType(typeId: StorageKeys.moodEntryTypeId)
class MoodEntryModel extends MoodEntry {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final DateTime date;

  @HiveField(2)
  @override
  final double humeur;

  @HiveField(3)
  @override
  final double motivation;

  @HiveField(4)
  @override
  final double sommeil;

  @HiveField(5)
  @override
  final DateTime createdAt;

  @HiveField(6)
  @override
  final DateTime? updatedAt;

  const MoodEntryModel({
    required this.id,
    required this.date,
    required this.humeur,
    required this.motivation,
    required this.sommeil,
    required this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          date: date,
          humeur: humeur,
          motivation: motivation,
          sommeil: sommeil,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Factory depuis une entité
  factory MoodEntryModel.fromEntity(MoodEntry entity) {
    return MoodEntryModel(
      id: entity.id,
      date: entity.date,
      humeur: entity.humeur,
      motivation: entity.motivation,
      sommeil: entity.sommeil,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Factory depuis JSON
  factory MoodEntryModel.fromJson(Map<String, dynamic> json) {
    return MoodEntryModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      humeur: (json['humeur'] as num).toDouble(),
      motivation: (json['motivation'] as num).toDouble(),
      sommeil: (json['sommeil'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Conversion en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'humeur': humeur,
      'motivation': motivation,
      'sommeil': sommeil,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Conversion en entité
  MoodEntry toEntity() {
    return MoodEntry(
      id: id,
      date: date,
      humeur: humeur,
      motivation: motivation,
      sommeil: sommeil,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  MoodEntryModel copyWith({
    String? id,
    DateTime? date,
    double? humeur,
    double? motivation,
    double? sommeil,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MoodEntryModel(
      id: id ?? this.id,
      date: date ?? this.date,
      humeur: humeur ?? this.humeur,
      motivation: motivation ?? this.motivation,
      sommeil: sommeil ?? this.sommeil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
