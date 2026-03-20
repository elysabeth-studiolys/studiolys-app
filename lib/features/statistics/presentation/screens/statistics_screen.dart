import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../../../core/widgets/simple_circular_header.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../providers/statistic_provider.dart';
import '../../domain/entities/metric_type.dart';
import '../widgets/metric_card_expanded.dart';
import '../widgets/week_selector.dart';
import '../widgets/combined_chart_dialog.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weekEnd = selectedWeek.weekEnd;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header
            SimpleCircularHeader(
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.marginS),
                  
                  WeekSelector(
                    weekStart: selectedWeek,
                    weekEnd: weekEnd,
                    onPrevious: () {
                      ref.read(selectedWeekProvider.notifier).state =
                          selectedWeek.subtract(const Duration(days: 7));
                    },
                    onNext: () {
                      ref.read(selectedWeekProvider.notifier).state =
                          selectedWeek.add(const Duration(days: 7));
                    },
                  ),
                ],
              ),
            ),

            // Contenu
            Transform.translate(
              offset: const Offset(0, 0),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  children: [
                    Center(
                      child: GradientButton(
                        text: 'Voir le graphique combiné',
                        icon: Icons.show_chart,
                        onPressed: () => _showCombinedChart(context, selectedWeek),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.marginXL),

                    MetricCardExpanded(
                      metricType: MetricType.humeur,
                      weekStart: selectedWeek,
                      useGradient: false,
                    ),

                    const SizedBox(height: AppDimensions.marginL),

                    MetricCardExpanded(
                      metricType: MetricType.motivation,
                      weekStart: selectedWeek,
                      useGradient: false,
                    ),

                    const SizedBox(height: AppDimensions.marginL),

                    // Carte Sommeil
                    MetricCardExpanded(
                      metricType: MetricType.sommeil,
                      weekStart: selectedWeek,
                      useGradient: false,
                    ),

                    const SizedBox(height: AppDimensions.marginXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCombinedChart(BuildContext context, DateTime weekStart) {
    showDialog(
      context: context,
      builder: (context) => CombinedChartDialog(weekStart: weekStart),
    );
  }
}