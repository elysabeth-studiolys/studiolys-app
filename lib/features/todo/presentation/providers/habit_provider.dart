import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../home/presentation/providers/mood_provider.dart'; 
import '../../data/datasources/habit_local_datasource.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_completion.dart';

final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>((ref) {
  return HabitLocalDataSourceImpl(HiveService.instance);
});

final habitRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(habitLocalDataSourceProvider);
  return HabitRepositoryImpl(dataSource);
});

final habitsProvider = FutureProvider<List<Habit>>((ref) async {
  final repository = ref.watch(habitRepositoryProvider);
  final result = await repository.getHabits();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (habits) => habits,
  );
});

final habitCompletionsProvider = FutureProvider.family<List<HabitCompletion>, String>(
  (ref, habitId) async {
    final repository = ref.watch(habitRepositoryProvider);
    final weekStart = ref.watch(selectedWeekStartProvider); 
    final result = await repository.getHabitCompletions(habitId, weekStart);
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (completions) => completions,
    );
  },
);

class HabitNotifier extends StateNotifier<AsyncValue<void>> {
  final HabitRepositoryImpl repository;
  final Ref ref;

  HabitNotifier(this.repository, this.ref) : super(const AsyncValue.data(null));

  Future<bool> createHabit(String name) async {
    state = const AsyncValue.loading();
    
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );
    
    final result = await repository.createHabit(habit);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(habitsProvider);
        return true;
      },
    );
  }

  Future<bool> updateHabit(Habit habit) async {
    state = const AsyncValue.loading();
    
    final updatedHabit = habit.copyWith(updatedAt: DateTime.now());
    final result = await repository.updateHabit(updatedHabit);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(habitsProvider);
        return true;
      },
    );
  }

  Future<bool> deleteHabit(String id) async {
    state = const AsyncValue.loading();
    
    final result = await repository.deleteHabit(id);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        ref.invalidate(habitsProvider);
        return true;
      },
    );
  }

  Future<bool> toggleCompletion(String habitId, DateTime date) async {
    final result = await repository.toggleHabitCompletion(habitId, date);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        ref.invalidate(habitCompletionsProvider(habitId));
        return true;
      },
    );
  }
}

final habitNotifierProvider = StateNotifierProvider<HabitNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitNotifier(repository, ref);
});