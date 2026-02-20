import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../providers/statistic_provider.dart';
import '../../domain/entities/metric_type.dart';
import 'metric_chart.dart';
import '../screens/metric_detail_screen.dart';  
import '../../../home/presentation/providers/mood_provider.dart';

class StatCard extends ConsumerWidget {
  final MetricType metricType;

  const StatCard({
    super.key,
    required this.metricType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(weeklyStatsProvider);
    final selectedMetric = ref.watch(selectedMetricProvider);
    final isSelected = selectedMetric == metricType;
    final progressionAsync = ref.watch(progressionPercentageProvider(metricType));
    final selectedWeek = ref.watch(selectedWeekProvider);

    return GestureDetector(  
      onTap: () {
        final currentWeekStart = ref.read(selectedWeekProvider);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MetricDetailScreen(
            metricType: metricType,
            weekStart: currentWeekStart,
          ),
        );
      },

      child: CustomCard(
        border: isSelected 
            ? Border.all(color: AppColors.accent, width: 2)
            : null,
        child: statsAsync.when(
          data: (stats) {
            final value = _getValueForMetric(stats);
            final color = _getColorForMetric();
            
            final chartData = <DateTime, double>{};
            for (var entry in stats.dailyValues.entries) {
              chartData[entry.key] = _getDailyValueForMetric(entry.key, ref);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  metricType.displayName,
                  style: AppTextStyles.h4,
                ),
                
                const SizedBox(height: AppDimensions.marginS),


                Row(
                  children: [
                    Text(
                      value.toStringAsFixed(1),
                      style: AppTextStyles.statisticValue.copyWith(color: color),
                    ),
                    const SizedBox(width: AppDimensions.marginS),
                    progressionAsync.when(
                      data: (percentage) => _buildPercentageBadge(percentage),
                      loading: () => const SizedBox(width: 60, height: 24),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.marginS),


                Text(
                  '10',
                  style: AppTextStyles.labelSmall.copyWith(color: Colors.grey),
                ),

                const SizedBox(height: AppDimensions.marginXS),

                SizedBox(
                  height: AppDimensions.chartHeight,
                  child: MetricChart(
                    data: chartData,
                    color: color,
                    weekStart: selectedWeek,
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => SizedBox(
            height: 300,
            child: Center(child: Text('Erreur: $error')),
          ),
        ),
      ),
    );
  }

  double _getValueForMetric(stats) {
    switch (metricType) {
      case MetricType.humeur:
        return stats.averageHumeur;
      case MetricType.motivation:
        return stats.averageMotivation;
      case MetricType.sommeil:
        return stats.averageSommeil;
    }
  }

  double _getDailyValueForMetric(DateTime date, WidgetRef ref) {

    final moodsAsync = ref.watch(moodHistoryProvider);
    
    return moodsAsync.when(
      data: (moods) {
        final mood = moods.firstWhere(
          (m) => m.date.year == date.year && 
                 m.date.month == date.month && 
                 m.date.day == date.day,
          orElse: () => moods.first,
        );
        
        switch (metricType) {
          case MetricType.humeur:
            return mood.humeur;
          case MetricType.motivation:
            return mood.motivation;
          case MetricType.sommeil:
            return mood.sommeil;
        }
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  Color _getColorForMetric() {
    switch (metricType) {
      case MetricType.humeur:
        return const Color(0xFF62E1BB); 
      case MetricType.motivation:
        return const Color(0xFF6BCEF2); 
      case MetricType.sommeil:
        return const Color(0xFFFF6B9D); 
    }
  }

  Widget _buildPercentageBadge(double percentage) {
    final isPositive = percentage >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${percentage.abs().toStringAsFixed(0)}%',
            style: AppTextStyles.percentageBadge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}