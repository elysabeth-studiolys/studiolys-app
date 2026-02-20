import 'package:hive/hive.dart';
import '../../../../core/services/storage/storage_keys.dart';
import '../../domain/entities/habit_completion.dart';

part 'habit_completion_model.g.dart';

@HiveType(typeId: StorageKeys.habitCompletionTypeId)
class HabitCompletionModel extends HabitCompletion {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String habitId;

  @HiveField(2)
  @override
  final DateTime date;

  @HiveField(3)
  @override
  final bool isCompleted;

  const HabitCompletionModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
  }) : super(
          id: id,
          habitId: habitId,
          date: date,
          isCompleted: isCompleted,
        );

  factory HabitCompletionModel.fromEntity(HabitCompletion entity) {
    return HabitCompletionModel(
      id: entity.id,
      habitId: entity.habitId,
      date: entity.date,
      isCompleted: entity.isCompleted,
    );
  }

  HabitCompletion toEntity() {
    return HabitCompletion(
      id: id,
      habitId: habitId,
      date: date,
      isCompleted: isCompleted,
    );
  }

  @override
  HabitCompletionModel copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
  }) {
    return HabitCompletionModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}