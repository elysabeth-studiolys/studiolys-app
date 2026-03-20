import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../home/presentation/providers/mood_provider.dart';
import '../../domain/entities/metric_type.dart';
import 'combined_metric_chart.dart';

class CombinedChartDialog extends ConsumerWidget {
  final DateTime weekStart;

  const CombinedChartDialog({
    super.key,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weeklyMoodsAsync = ref.watch(weeklyMoodsProvider(weekStart));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppDimensions.paddingS),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            

            // Contenu
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                children: [
                  Text(
                    '${DateFormat('d MMM', 'fr_FR').format(weekStart)} - ${DateFormat('d MMM', 'fr_FR').format(weekEnd)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.marginL),

                  // Graphique combiné
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(AppDimensions.paddingXS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    ),
                    child: weeklyMoodsAsync.when(
                      data: (moods) => CombinedMetricChart(
                        moods: moods,
                        weekStart: weekStart,
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('Erreur')),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.marginL),

                  // Légende
                  _buildLegend(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Humeur', MetricType.humeur.color),
        _buildLegendItem('Motivation', MetricType.motivation.color),
        _buildLegendItem('Sommeil', MetricType.sommeil.color),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.labelSmall,
        ),
      ],
    );
  }
}