import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/services/storage/hive_service.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../data/datasources/mood_local_datasource.dart';
import '../../data/repositories/mood_repository_impl.dart';
import '../../domain/entities/mood_entry.dart';
import '../../domain/usecases/get_daily_mood.dart';
import '../../domain/usecases/get_mood_history.dart';
import '../../domain/usecases/save_mood.dart';


final selectedWeekStartProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  final weekday = now.weekday; 
  return now.subtract(Duration(days: weekday - 1));
});


final selectedDayInWeekProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});


final weekDaysProvider = Provider<List<DateTime>>((ref) {
  final weekStart = ref.watch(selectedWeekStartProvider);
  return List.generate(7, (index) => weekStart.add(Duration(days: index)));
});


final selectedDayMoodProvider = FutureProvider<MoodEntry?>((ref) async {
  final selectedDay = ref.watch(selectedDayInWeekProvider);
  final repository = ref.watch(moodRepositoryProvider);
  final useCase = GetDailyMood(repository);
  
  final result = await useCase(selectedDay);
  
  return result.fold(
    (failure) => null,
    (mood) => mood,
  );
});


final moodLocalDataSourceProvider = Provider<MoodLocalDataSource>((ref) {
  return MoodLocalDataSourceImpl(HiveService.instance);
});

final moodRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(moodLocalDataSourceProvider);
  return MoodRepositoryImpl(dataSource);
});


final saveMoodUseCaseProvider = Provider((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return SaveMood(repository);
});

final getDailyMoodUseCaseProvider = Provider((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return GetDailyMood(repository);
});

final getMoodHistoryUseCaseProvider = Provider((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return GetMoodHistory(repository);
});


class MoodState {
  final double humeur;
  final double motivation;
  final double sommeil;
  final bool isLoading;
  final String? error;
  final bool isSaved;

  MoodState({
    this.humeur = 5.0,
    this.motivation = 5.0,
    this.sommeil = 5.0,
    this.isLoading = false,
    this.error,
    this.isSaved = false,
  });

  MoodState copyWith({
    double? humeur,
    double? motivation,
    double? sommeil,
    bool? isLoading,
    String? error,
    bool? isSaved,
  }) {
    return MoodState(
      humeur: humeur ?? this.humeur,
      motivation: motivation ?? this.motivation,
      sommeil: sommeil ?? this.sommeil,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}


class MoodNotifier extends StateNotifier<MoodState> {
  final SaveMood saveMoodUseCase;
  final GetDailyMood getDailyMoodUseCase;
  final GetMoodHistory getMoodHistoryUseCase;
  final Ref ref;

  MoodNotifier({
    required this.saveMoodUseCase,
    required this.getDailyMoodUseCase,
    required this.getMoodHistoryUseCase,
    required this.ref,
  }) : super(MoodState());


  Future<void> loadDailyMood(DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getDailyMoodUseCase(date);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (moodEntry) {
        if (moodEntry != null) {
          state = state.copyWith(
            humeur: moodEntry.humeur,
            motivation: moodEntry.motivation,
            sommeil: moodEntry.sommeil,
            isLoading: false,
            isSaved: true,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            isSaved: false,
          );
        }
      },
    );
  }


  void updateHumeur(double value) {
    state = state.copyWith(humeur: value, isSaved: false);
  }


  void updateMotivation(double value) {
    state = state.copyWith(motivation: value, isSaved: false);
  }


  void updateSommeil(double value) {
    state = state.copyWith(sommeil: value, isSaved: false);
  }


  Future<bool> saveMood(DateTime date) async {
    state = state.copyWith(isLoading: true, error: null);


    final existingMoodResult = await getDailyMoodUseCase(date);
    

    final entryId = existingMoodResult.fold(
      (failure) => const Uuid().v4(), 
      (existingMood) => existingMood?.id ?? const Uuid().v4(), 
    );

    final moodEntry = MoodEntry(
      id: entryId,
      date: date.dateOnly,
      humeur: state.humeur,
      motivation: state.motivation,
      sommeil: state.sommeil,
      createdAt: DateTime.now(),
    );

    final result = await saveMoodUseCase(moodEntry);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          isSaved: true,
        );

        ref.invalidate(moodHistoryProvider);
        ref.invalidate(selectedDayMoodProvider);
        ref.invalidate(weeklyMoodsProvider);
        return true;
      },
    );
  }




  void reset() {
    state = MoodState();
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, MoodState>((ref) {
  return MoodNotifier(
    saveMoodUseCase: ref.watch(saveMoodUseCaseProvider),
    getDailyMoodUseCase: ref.watch(getDailyMoodUseCaseProvider),
    getMoodHistoryUseCase: ref.watch(getMoodHistoryUseCaseProvider),
    ref: ref,
  );
});


final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().dateOnly;
});


final moodHistoryProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final useCase = ref.watch(getMoodHistoryUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (entries) => entries,
  );
});


final weeklyMoodsProvider = FutureProvider.family<List<MoodEntry>, DateTime>(
  (ref, weekStart) async {
    final repository = ref.watch(moodRepositoryProvider);
    final result = await repository.getWeeklyMoods(weekStart);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (entries) => entries,
    );
  },
);
