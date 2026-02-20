import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/providers/mood_provider.dart';
import '../../../home/domain/entities/mood_entry.dart';
import '../../domain/entities/metric_type.dart';
import '../../domain/entities/weekly_stat.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';

final selectedWeekProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().weekStart;
});

final selectedMetricProvider = StateProvider<MetricType>((ref) {
  return MetricType.humeur;
});

final weeklyStatsProvider = FutureProvider.autoDispose<WeeklyStat>((ref) async {
  final weekStart = ref.watch(selectedWeekProvider);
  final moodsAsync = ref.watch(weeklyMoodsProvider(weekStart));

  return moodsAsync.when(
    data: (moods) => _calculateWeeklyStats(moods, weekStart),
    loading: () => throw Exception('Chargement...'),
    error: (error, stack) => throw error,
  );
});


final previousWeekStatsProvider = FutureProvider.autoDispose<WeeklyStat>((ref) async {
  final weekStart = ref.watch(selectedWeekProvider);
  final previousWeekStart = weekStart.subtract(const Duration(days: 7));
  final moodsAsync = ref.watch(weeklyMoodsProvider(previousWeekStart));

  return moodsAsync.when(
    data: (moods) => _calculateWeeklyStats(moods, previousWeekStart),
    loading: () => throw Exception('Chargement...'),
    error: (error, stack) => throw error,
  );
});


final progressionPercentageProvider = FutureProvider.autoDispose.family<double, MetricType>(
  (ref, metricType) async {
    final currentStats = await ref.watch(weeklyStatsProvider.future);
    final previousStats = await ref.watch(previousWeekStatsProvider.future);

    final currentValue = _getValueForMetric(currentStats, metricType);
    final previousValue = _getValueForMetric(previousStats, metricType);

    if (previousValue == 0) return 0;

    final progression = ((currentValue - previousValue) / previousValue) * 100;
    return progression;
  },
);

WeeklyStat _calculateWeeklyStats(List<MoodEntry> moods, DateTime weekStart) {
  if (moods.isEmpty) {
    return WeeklyStat(
      weekStart: weekStart,
      averageHumeur: 0,
      averageMotivation: 0,
      averageSommeil: 0,
      dailyValues: {},
    );
  }

  final humeurSum = moods.fold<double>(0, (sum, m) => sum + m.humeur);
  final motivationSum = moods.fold<double>(0, (sum, m) => sum + m.motivation);
  final sommeilSum = moods.fold<double>(0, (sum, m) => sum + m.sommeil);

  final count = moods.length;


  final dailyValues = <DateTime, double>{};
  for (var mood in moods) {
    dailyValues[mood.date.dateOnly] = mood.average;
  }

  return WeeklyStat(
    weekStart: weekStart,
    averageHumeur: humeurSum / count,
    averageMotivation: motivationSum / count,
    averageSommeil: sommeilSum / count,
    dailyValues: dailyValues,
  );
}

double _getValueForMetric(WeeklyStat stats, MetricType metricType) {
  switch (metricType) {
    case MetricType.humeur:
      return stats.averageHumeur;
    case MetricType.motivation:
      return stats.averageMotivation;
    case MetricType.sommeil:
      return stats.averageSommeil;
  }
}