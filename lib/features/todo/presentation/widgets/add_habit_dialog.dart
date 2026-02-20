import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../domain/entities/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitDialog extends ConsumerStatefulWidget {
  final Habit? habitToEdit;

  const AddHabitDialog({
    super.key,
    this.habitToEdit,
  });

  @override
  ConsumerState<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends ConsumerState<AddHabitDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.habitToEdit?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habitToEdit != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                isEditing ? 'Modifier l\'habitude' : 'Nouvelle habitude',
                style: AppTextStyles.h3,
              ),

              const SizedBox(height: AppDimensions.marginL),

              // Champ nom
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'habitude',
                  hintText: 'Ex: Méditation, Sport, Lecture...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppDimensions.marginXL),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Annuler
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Annuler',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppDimensions.marginM),

                  // Sauvegarder
                  CustomButton(
                    text: isEditing ? 'Modifier' : 'Ajouter',
                    onPressed: _saveHabit,
                    width: 120,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final notifier = ref.read(habitNotifierProvider.notifier);

    bool success;
    if (widget.habitToEdit != null) {

      final updatedHabit = widget.habitToEdit!.copyWith(name: name);
      success = await notifier.updateHabit(updatedHabit);
    } else {

      success = await notifier.createHabit(name);
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }
}