import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/mood_provider.dart';

class WeekSelector extends ConsumerWidget {
  const WeekSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekStart = ref.watch(selectedWeekStartProvider);
    final weekEnd = weekStart.add(const Duration(days: 6));
    

    final startDay = weekStart.day;
    final endDay = weekEnd.day;
    final monthName = _getMonthName(weekEnd.month);
    final weekText = '$startDay - $endDay $monthName';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        IconButton(
          onPressed: () {
            final previousWeek = weekStart.subtract(const Duration(days: 7));
            ref.read(selectedWeekStartProvider.notifier).state = previousWeek;
            

            ref.read(selectedDayInWeekProvider.notifier).state = previousWeek;
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 32,
          ),
        ),

        const SizedBox(width: AppDimensions.marginL),


        Text(
          weekText,
          style: AppTextStyles.headerLight.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: AppDimensions.marginL),


        IconButton(
          onPressed: () {
            final nextWeek = weekStart.add(const Duration(days: 7));
            ref.read(selectedWeekStartProvider.notifier).state = nextWeek;
            

            ref.read(selectedDayInWeekProvider.notifier).state = nextWeek;
          },
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return months[month];
  }
}