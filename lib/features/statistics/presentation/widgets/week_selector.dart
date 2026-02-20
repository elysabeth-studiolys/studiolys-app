import 'package:flutter/material.dart';
import 'package:mood_tracker_app/core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_helper.dart';

class WeekSelector extends StatelessWidget {
  final DateTime weekStart;
  final DateTime weekEnd;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const WeekSelector({
    super.key,
    required this.weekStart,
    required this.weekEnd,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final weekText = DateHelper.formatWeekRange(weekStart, weekEnd);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.accent),
            onPressed: onPrevious,
          ),
          Text(
            weekText,
            style: AppTextStyles.headerLight.copyWith(color: AppColors.accent),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.accent),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
