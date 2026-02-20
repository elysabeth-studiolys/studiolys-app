import 'package:equatable/equatable.dart';

class HabitCompletion extends Equatable {
  final String id;
  final String habitId;
  final DateTime date;
  final bool isCompleted;

  const HabitCompletion({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
  });

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
  }) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, habitId, date, isCompleted];
}