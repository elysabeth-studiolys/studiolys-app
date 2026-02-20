import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/mood_provider.dart';

class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekDays = ref.watch(weekDaysProvider);
    final selectedDay = ref.watch(selectedDayInWeekProvider);
    final today = DateTime.now();

    return SizedBox(
      height: 60,  
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: weekDays.map((day) {
          final isSelected = _isSameDay(day, selectedDay);
          final isToday = _isSameDay(day, today);
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  ref.read(selectedDayInWeekProvider.notifier).state = day;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isToday 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: isSelected && !isToday
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Jour de la semaine (L, M, M, J, V, S, D)
                      Text(
                        _getDayLetter(day),
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isToday ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Numéro du jour
                      Text(
                        '${day.day}',
                        style: AppTextStyles.h3.copyWith(
                          color: isToday ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getDayLetter(DateTime date) {

    switch (date.weekday) {
      case 1: return 'L'; 
      case 2: return 'M'; 
      case 3: return 'M'; 
      case 4: return 'J'; 
      case 5: return 'V'; 
      case 6: return 'S'; 
      case 7: return 'D'; 
      default: return '';
    }
  }
}