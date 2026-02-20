import 'package:hive/hive.dart';
import '../../../../core/services/storage/storage_keys.dart';
import '../../domain/entities/habit.dart';

part 'habit_model.g.dart';

@HiveType(typeId: StorageKeys.habitTypeId)
class HabitModel extends Habit {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String name;

  @HiveField(2)
  @override
  final DateTime createdAt;

  @HiveField(3)
  @override
  final DateTime? updatedAt;

  const HabitModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  }) : super(
          id: id,
          name: name,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory HabitModel.fromEntity(Habit entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Habit toEntity() {
    return Habit(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  HabitModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}