import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/project_task.dart';

class ProjectTaskItemWidget extends StatelessWidget {
  final ProjectTask task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const ProjectTaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Checkbox personnalisée
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isDone ? AppColors.success : AppColors.textSecondary,
                  width: 2,
                ),
                color: task.isDone ? AppColors.success : Colors.transparent,
              ),
              child: task.isDone
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(width: AppDimensions.marginM),
          
          // Titre de la tâche
          Expanded(
            child: Text(
              task.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: task.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          
          // Bouton supprimer
          if (onDelete != null)
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 20,
                color: AppColors.textSecondary,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}