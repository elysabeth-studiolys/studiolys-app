import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../home/presentation/providers/mood_provider.dart';
import '../../domain/entities/metric_type.dart';
import '../providers/metric_note_provider.dart';
import '../widgets/metric_chart.dart';
import '../widgets/note_card.dart';
import '../widgets/add_note_dialog.dart';

class MetricDetailScreen extends ConsumerWidget {
  final MetricType metricType;
  final DateTime weekStart;

  const MetricDetailScreen({
    super.key,
    required this.metricType,
    required this.weekStart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weeklyMoodsAsync = ref.watch(weeklyMoodsProvider(weekStart));
    
    final notesAsync = ref.watch(metricNotesProvider((
      metricType: metricType.name,
      weekStart: weekStart,
    )));

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radiusXL),
              topRight: Radius.circular(AppDimensions.radiusXL),
            ),
          ),
          child: Column(
            children: [

              _buildHeader(context, weekStart, weekEnd),


              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _buildMainCard(
                        context,
                        ref,
                        weekStart,
                        weeklyMoodsAsync,
                      ),

                      const SizedBox(height: AppDimensions.marginXL),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notes',
                            style: AppTextStyles.h4,
                          ),
                          GradientButton(
                            text: 'Ajouter une note',
                            icon: Icons.add,
                            onPressed: () => _showAddNoteDialog(context, ref),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),

                        ],
                      ),

                      const SizedBox(height: AppDimensions.marginM),


                      notesAsync.when(
                        data: (notes) {
                          if (notes.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(AppDimensions.paddingL),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                              ),
                              child: Center(
                                child: Text(
                                  'Aucune note pour cette semaine.\nAjoutez-en une pour suivre vos progrès !',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: notes.map((note) {
                              return NoteCard(
                                note: note,
                                onDelete: () => _deleteNote(context, ref, note.id),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox(),
                      ),
                      
                      const SizedBox(height: AppDimensions.marginXL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DateTime weekStart,
    DateTime weekEnd,
  ) {
    final startDay = weekStart.day;
    final endDay = weekEnd.day;
    final monthName = DateFormat('MMMM', 'fr_FR').format(weekEnd);
    final weekText = '$startDay-$endDay $monthName';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        children: [

          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          

          Row(
            children: [
              
              Expanded(
                child: Text(
                  'Détail de votre ${metricType.displayName.toLowerCase()} cette semaine',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48), 
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    WidgetRef ref,
    DateTime weekStart,
    AsyncValue<List<dynamic>> weeklyMoodsAsync,
  ) {
    final color = metricType.color;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          

          // Moyenne
          weeklyMoodsAsync.when(
            data: (moods) {
              final value = metricType.calculateAverage(moods);
              
              return Row(
                children: [
                  Text(
                    'Moyenne cette semaine :',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(width: AppDimensions.marginS),
                  Text(
                    value.toStringAsFixed(1),
                    style: AppTextStyles.h2.copyWith(color: color),
                  ),
                ],
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          const SizedBox(height: AppDimensions.marginS),


          Text(
            _getDescriptionText(metricType),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppDimensions.marginL),

          // Graphique
          SizedBox(
            height: 200,
            child: weeklyMoodsAsync.when(
              data: (moods) {
                final chartData = metricType.extractDataPoints(moods);
                return MetricChart(
                  data: chartData,
                  color: color,
                  weekStart: weekStart,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ),

          const SizedBox(height: AppDimensions.marginL),


          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Text(
              _getEncouragementText(metricType),
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getDescriptionText(MetricType type) {
    switch (type) {
      case MetricType.humeur:
        return 'Légère hausse depuis la semaine dernière !';
      case MetricType.motivation:
        return 'Bonne progression cette semaine !';
      case MetricType.sommeil:
        return 'Votre sommeil s\'améliore !';
    }
  }

  String _getEncouragementText(MetricType type) {
    switch (type) {
      case MetricType.humeur:
        return 'Cette stabilité relative peut offrir un espace pour avancer à ton rythme.';
      case MetricType.motivation:
        return 'Continuez sur cette lancée, vous êtes sur la bonne voie !';
      case MetricType.sommeil:
        return 'Un bon sommeil est la base d\'une bonne santé mentale.';
    }
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

    if (confirmed == true && context.mounted) {
      await ref.read(metricNoteNotifierProvider.notifier).deleteNote(noteId);
    }
  }
}