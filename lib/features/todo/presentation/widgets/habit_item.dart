import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';

class HabitItem extends ConsumerWidget {
  final Habit habit;
  final DateTime weekStart;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitItem({
    super.key,
    required this.habit,
    required this.weekStart,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completionsAsync = ref.watch(habitCompletionsProvider(habit.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.marginM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            width: 80, 
            child: GestureDetector(
              onTap: () => _showOptions(context),
              child: Text(
                habit.name,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          const SizedBox(width: 8),  

          Expanded(
            child: completionsAsync.when(
              data: (completions) => LayoutBuilder(  
                builder: (context, constraints) {

                  final availableWidth = constraints.maxWidth;
                  final spacing = 4.0;
                  final totalSpacing = spacing * 6;
                  final circleSize = ((availableWidth - totalSpacing) / 7).clamp(28.0, 36.0);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                    children: List.generate(7, (index) {
                      final date = weekStart.add(Duration(days: index));
                      final dateOnly = DateTime(date.year, date.month, date.day);
                      final isCompleted = _isDateCompleted(completions, dateOnly);

                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(habitNotifierProvider.notifier)
                              .toggleCompletion(habit.id, dateOnly);
                        },
                        child: Container(
                          width: circleSize,  
                          height: circleSize, 
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.white
                                : AppColors.habitIncompleteLight,
                            shape: BoxShape.circle,
                          ),
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.accent,
                                  size: circleSize * 0.5,  
                                )
                              : null,
                        ),
                      );
                    }),
                  );
                },
              ),
              loading: () => const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isDateCompleted(completions, DateTime dateOnly) {
    return completions.any((c) {
      final completionDate = DateTime(c.date.year, c.date.month, c.date.day);
      return completionDate.year == dateOnly.year &&
          completionDate.month == dateOnly.month &&
          completionDate.day == dateOnly.day &&
          c.isCompleted;
    });
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimensions.marginS),
            // Indicateur
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.marginM),
            
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                if (onEdit != null) onEdit!();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Supprimer'),
              onTap: () {
                Navigator.pop(context);
                if (onDelete != null) onDelete!();
              },
            ),
            const SizedBox(height: AppDimensions.marginM),
          ],
        ),
      ),
    );
  }
}