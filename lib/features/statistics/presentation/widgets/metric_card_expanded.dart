import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../home/presentation/providers/mood_provider.dart';
import '../../domain/entities/metric_type.dart';
import '../providers/metric_note_provider.dart';
import 'metric_chart.dart';
import 'note_card.dart';
import 'add_note_dialog.dart';

class MetricCardExpanded extends ConsumerWidget {
  final MetricType metricType;
  final DateTime weekStart;
  final bool useGradient;

  const MetricCardExpanded({
    super.key,
    required this.metricType,
    required this.weekStart,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyMoodsAsync = ref.watch(weeklyMoodsProvider(weekStart));
    final previousWeek = weekStart.subtract(const Duration(days: 7));
    final previousWeekMoodsAsync = ref.watch(weeklyMoodsProvider(previousWeek));
    
    final notesAsync = ref.watch(metricNotesProvider((
      metricType: metricType.name,
      weekStart: weekStart,
    )));
    
    final textColor = useGradient ? Colors.white : AppColors.textPrimary;
    final secondaryTextColor = useGradient 
        ? Colors.white.withOpacity(0.9) 
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: useGradient 
            ? LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            metricType.displayName,
            style: AppTextStyles.h4.copyWith(color: textColor),
          ),

          const SizedBox(height: AppDimensions.marginL),

          // Moyenne et progression
          weeklyMoodsAsync.when(
            data: (currentMoods) {
              final currentAverage = metricType.calculateAverage(currentMoods);
              
              return previousWeekMoodsAsync.when(
                data: (previousMoods) {
                  final previousAverage = metricType.calculateAverage(previousMoods);
                  final difference = currentAverage - previousAverage;
                  final percentage = previousAverage != 0 
                      ? (difference / previousAverage * 100).abs() 
                      : 0.0;
                  final isIncrease = difference > 0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Moyenne actuelle
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            currentAverage.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.marginS),
                          Text(
                            '/ 10',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppDimensions.marginS),

                      // Badge de progression
                      if (percentage > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: useGradient 
                                ? Colors.white.withOpacity(0.2)
                                : (isIncrease ? AppColors.success : AppColors.error).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 16,
                                color: useGradient 
                                    ? Colors.white 
                                    : (isIncrease ? AppColors.success : AppColors.error),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${percentage.toStringAsFixed(0)}% vs semaine précédente',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: useGradient 
                                      ? Colors.white 
                                      : (isIncrease ? AppColors.success : AppColors.error),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
                loading: () => Text(
                  currentAverage.toStringAsFixed(1),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: textColor),
                ),
                error: (_, __) => Text(
                  currentAverage.toStringAsFixed(1),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: textColor),
                ),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          const SizedBox(height: AppDimensions.marginXL),

          // Graphique
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: useGradient ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: weeklyMoodsAsync.when(
              data: (moods) {
                final chartData = metricType.extractDataPoints(moods);
                return MetricChart(
                  data: chartData,
                  color: useGradient ? Colors.white : metricType.color,
                  weekStart: weekStart,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ),

          const SizedBox(height: AppDimensions.marginL),

          notesAsync.when(
            data: (notes) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Afficher les notes
                  ...notes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.marginM),
                      child: NoteCard(
                        note: note,
                        onDelete: () => _deleteNote(context, ref, note.id),
                      ),
                    );
                  }).toList(),

                  // Bouton ajouter une note
                  Center(
                    child: GradientButton(
                      text: 'Ajouter une note',
                      icon: Icons.add,
                      onPressed: () => _showAddNoteDialog(context, ref),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => Center(
              child: GradientButton(
                text: 'Ajouter une note',
                icon: Icons.add,
                onPressed: () => _showAddNoteDialog(context, ref),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context, WidgetRef ref) async {
    final content = await showDialog<String>(
      context: context,
      builder: (context) => const AddNoteDialog(),
    );

    if (content != null && context.mounted) {
      final success = await ref
          .read(metricNoteNotifierProvider.notifier)
          .addNote(metricType.name, weekStart, content);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note ajoutée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _deleteNote(BuildContext context, WidgetRef ref, String noteId) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Supprimer la note'),
      content: const Text('Êtes-vous sûr de vouloir supprimer cette note ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    await ref.read(metricNoteNotifierProvider.notifier).deleteNote(noteId);
    
    ref.invalidate(metricNotesProvider((
      metricType: metricType.name,
      weekStart: weekStart,
    )));
  }
}

}