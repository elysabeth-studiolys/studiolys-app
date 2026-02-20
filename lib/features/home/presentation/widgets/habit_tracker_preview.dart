import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_card_light.dart';
import '../../../todo/presentation/providers/habit_provider.dart';
import '../../../todo/presentation/widgets/habit_item.dart';
import '../../../todo/presentation/widgets/add_habit_dialog.dart';

class HabitTrackerPreview extends ConsumerWidget {
  const HabitTrackerPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);
    final now = DateTime.now();
    final weekday = now.weekday;
    final weekStart = now.subtract(Duration(days: weekday - 1));
    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return CustomCardLight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.habitTracker,
                style: AppTextStyles.h4.copyWith(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddHabitDialog(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: AppDimensions.iconL,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.marginM),


          Row(
            children: [
              const SizedBox(width: 80), 
              const SizedBox(width: 5),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map((day) {
                    return SizedBox(
                      width: AppDimensions.habitItemSize,
                      child: Center(
                        child: Text(
                          day,
                          style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.marginS),

          // Liste des habitudes
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingL,
                  ),
                  child: Center(
                    child: Text(
                      'Aucune habitude.\nAppuyez sur + pour en ajouter.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                );
              }

              return Column(
                children: habits.map((habit) {
                  return HabitItem(
                    habit: habit,
                    weekStart: weekStart,
                    onEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddHabitDialog(
                          habitToEdit: habit,
                        ),
                      );
                    },
                    onDelete: () async {
                      final confirmed = await _showDeleteConfirmation(context);
                      if (confirmed == true) {
                        ref
                            .read(habitNotifierProvider.notifier)
                            .deleteHabit(habit.id);
                      }
                    },
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Text(
                  'Erreur: $error',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'habitude'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer cette habitude ? '
          'Toutes les données associées seront supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}