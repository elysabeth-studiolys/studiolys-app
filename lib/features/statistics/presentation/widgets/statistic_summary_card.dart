import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_gradients.dart';
import '../../../home/presentation/providers/mood_provider.dart';
import '../../domain/entities/metric_type.dart';
import '../providers/statistic_provider.dart';
import '../screens/metric_detail_screen.dart';

class StatisticSummaryCard extends ConsumerWidget {
  final MetricType metricType;
  final bool useGradient;

  const StatisticSummaryCard({
    super.key,
    required this.metricType,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(selectedWeekProvider);
    final weeklyMoodsAsync = ref.watch(weeklyMoodsProvider(selectedWeek));

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MetricDetailScreen(
            metricType: metricType,
            weekStart: selectedWeek,
          ),
        );
      },
      child: Container(
        padding: metricType == MetricType.motivation
      ? const EdgeInsets.only(  
          left: AppDimensions.paddingL,
          right: AppDimensions.paddingL,
          top: AppDimensions.paddingL,
          bottom: AppDimensions.paddingL,
        )
      : const EdgeInsets.only(  
          left: AppDimensions.paddingS,
          right: AppDimensions.paddingL,
          top: AppDimensions.paddingL,
          bottom: AppDimensions.paddingL,
        ),

        decoration: BoxDecoration(
          gradient: useGradient ? AppGradients.primaryGradient : null,
          color: useGradient ? null : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: weeklyMoodsAsync.when(
          data: (moods) {
            final average = metricType.calculateAverage(moods);
            return _buildContent(context, average);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double average) {
    final textColor = useGradient ? Colors.white : AppColors.accent;
    final secondaryTextColor = useGradient 
        ? Colors.white.withOpacity(0.9) 
        : AppColors.textSecondary;


    if (metricType == MetricType.motivation && _getIllustrationPath() != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: _buildTextContent(textColor, secondaryTextColor, average),
          ),
          
          const SizedBox(width: AppDimensions.paddingM),
          

          Image.asset(
            _getIllustrationPath()!,
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),
        ],
      );
    }


    if (_getIllustrationPath() != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Image.asset(
            _getIllustrationPath()!,
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
          
          const SizedBox(width: AppDimensions.paddingM),
          

          Expanded(
            child: _buildTextContent(textColor, secondaryTextColor, average),
          ),
        ],
      );
    }


    return _buildTextContent(textColor, secondaryTextColor, average);
  }


  Widget _buildTextContent(Color textColor, Color secondaryTextColor, double average) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          '${metricType.displayName} moyenne',
          style: AppTextStyles.h4.copyWith(
            color: textColor,
          ),
        ),

        const SizedBox(height: AppDimensions.marginS),


        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              average.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: textColor,
                height: 1,
              ),
            ),

            const SizedBox(width: AppDimensions.marginS),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    size: 14,
                    color: textColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '10%',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.marginM),

        Text(
          _getDescriptionText(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: secondaryTextColor,
          ),
        ),

        const SizedBox(height: AppDimensions.marginL),

        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: useGradient 
                  ? Colors.white 
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VOIR LE DÉTAIL',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: useGradient 
                        ? AppColors.primary 
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: useGradient 
                      ? AppColors.primary 
                      : Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _getIllustrationPath() {
    switch (metricType) {
      case MetricType.humeur:
        return 'assets/images/humeur_illustration.png';
      case MetricType.motivation:
        return 'assets/images/motivation_illustration.png';
      case MetricType.sommeil:
        return 'assets/images/sommeil_illustration.png';
    }
  }

  String _getDescriptionText() {
    switch (metricType) {
      case MetricType.humeur:
        return 'Cette semaine est sur la bonne voie !';
      case MetricType.motivation:
        return 'Continuez sur cette lancée !';
      case MetricType.sommeil:
        return 'Votre sommeil s\'améliore !';
    }
  }
}