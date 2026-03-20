import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../providers/mood_provider.dart';
import 'mood_slider.dart';
import 'mood_summary_card.dart';

class MoodInputSection extends ConsumerStatefulWidget {
  const MoodInputSection({super.key});

  @override
  ConsumerState<MoodInputSection> createState() => _MoodInputSectionState();
}

class _MoodInputSectionState extends ConsumerState<MoodInputSection> {
  bool _isEditing = false;
  bool _valuesLoaded = false;  

  @override
  Widget build(BuildContext context) {
    final moodAsync = ref.watch(selectedDayMoodProvider);
    final moodState = ref.watch(moodProvider);
    final selectedDay = ref.watch(selectedDayInWeekProvider);

    return moodAsync.when(
      data: (existingMood) {
        // Si des données existent ET qu'on n'est pas en mode édition, afficher le résumé
        if (existingMood != null && !_isEditing) {
          return MoodSummaryCard(
            moodEntry: existingMood,
            onEdit: () {

              ref.read(moodProvider.notifier).updateHumeur(existingMood.humeur);
              ref.read(moodProvider.notifier).updateMotivation(existingMood.motivation);
              ref.read(moodProvider.notifier).updateSommeil(existingMood.sommeil);
              
              setState(() {
                _isEditing = true;
                _valuesLoaded = true;  
              });
            },
          );
        }


        if (existingMood != null && !_valuesLoaded && _isEditing) { 
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(moodProvider.notifier).updateHumeur(existingMood.humeur);
              ref.read(moodProvider.notifier).updateMotivation(existingMood.motivation);
              ref.read(moodProvider.notifier).updateSommeil(existingMood.sommeil);
              setState(() => _valuesLoaded = true);
            }
          });
        }

        return CustomCard(
          child: Column(
            children: [
              // Humeur
              MoodSlider(
                label: 'Humeur',
                value: moodState.humeur,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateHumeur(value);
                },
              ),

              const SizedBox(height: AppDimensions.marginXL),

              // Motivation
              MoodSlider(
                label: 'Motivation',
                value: moodState.motivation,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateMotivation(value);
                },
              ),

              const SizedBox(height: AppDimensions.marginXL),

              // Sommeil
              MoodSlider(
                label: 'Sommeil',
                value: moodState.sommeil,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateSommeil(value);
                },
              ),

              const SizedBox(height: AppDimensions.marginXL),

              // Boutons
              Row(
                children: [
                  // Bouton Annuler 
                  if (_isEditing)
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _valuesLoaded = false;  
                          });
                        },
                        child: Text(
                          'Annuler',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  
                  if (_isEditing) const SizedBox(width: AppDimensions.marginM),
                  
                  // Bouton Save
                  Expanded(
                    flex: _isEditing ? 2 : 1,
                    child: moodState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: 'Save',
                            onPressed: () => _saveMood(context, ref, selectedDay),
                            width: double.infinity,
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => CustomCard(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, _) {
        final moodState = ref.watch(moodProvider);
        
        return CustomCard(
          child: Column(
            children: [
              MoodSlider(
                label: 'Humeur',
                value: moodState.humeur,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateHumeur(value);
                },
              ),
              const SizedBox(height: AppDimensions.marginXL),
              MoodSlider(
                label: 'Motivation',
                value: moodState.motivation,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateMotivation(value);
                },
              ),
              const SizedBox(height: AppDimensions.marginXL),
              MoodSlider(
                label: 'Sommeil',
                value: moodState.sommeil,
                onChanged: (value) {
                  ref.read(moodProvider.notifier).updateSommeil(value);
                },
              ),
              const SizedBox(height: AppDimensions.marginXL),
              moodState.isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'Save',
                      onPressed: () => _saveMood(context, ref, selectedDay),
                      width: double.infinity,
                    ),
            ],  
          ),
        );
      },
    );
  }

  Future<void> _saveMood(BuildContext context, WidgetRef ref, DateTime selectedDay) async {
    final success = await ref.read(moodProvider.notifier).saveMood(selectedDay);

    if (context.mounted) {
      if (success) {

        setState(() {
          _isEditing = false;
          _valuesLoaded = false; 
        });
        
        ref.invalidate(selectedDayMoodProvider);
        ref.invalidate(moodHistoryProvider);
        ref.invalidate(weeklyMoodsProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Humeur enregistrée avec succès'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final errorMessage = ref.read(moodProvider).error ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $errorMessage'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}