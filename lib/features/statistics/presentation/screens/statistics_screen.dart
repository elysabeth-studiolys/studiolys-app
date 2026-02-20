import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/extensions/datetime_extensions.dart';
import '../../../../core/widgets/simple_circular_header.dart';
import '../providers/statistic_provider.dart';
import '../../domain/entities/metric_type.dart';
import '../widgets/statistic_summary_card.dart';
import '../widgets/week_selector.dart';

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


            Transform.translate(
              offset: const Offset(0, -50),  
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  children: [

                    StatisticSummaryCard(
                      metricType: MetricType.humeur,
                      useGradient: true,
                    ),

                    const SizedBox(height: AppDimensions.marginL),

                    // Carte Motivation (fond blanc)
                    StatisticSummaryCard(
                      metricType: MetricType.motivation,
                      useGradient: false,
                    ),

                    const SizedBox(height: AppDimensions.marginL),

                    // Carte Sommeil (fond blanc)
                    StatisticSummaryCard(
                      metricType: MetricType.sommeil,
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
}