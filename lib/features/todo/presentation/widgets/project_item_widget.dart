import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/project.dart';

class ProjectItemWidget extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectItemWidget({
    super.key,
    required this.project,
    required this.onTap,
  });

  Color _getPriorityColor() {
    switch (project.priority) {
      case ProjectPriority.urgent:
        return Colors.red;
      case ProjectPriority.high:
        return Colors.orange;
      case ProjectPriority.medium:
        return AppColors.primary;
      case ProjectPriority.low:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: project.isDone
                  ? AppColors.success.withOpacity(0.3)
                  : (project.isOverdue
                      ? AppColors.error.withOpacity(0.3)
                      : AppColors.border),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Indicateur de priorité
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getPriorityColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: AppDimensions.marginM),

              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      project.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: project.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Catégorie
                    Text(
                      project.category,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    
                    // Barre de progression si le projet a des tâches
                    if (project.totalTasks > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: project.completionPercentage / 100,
                                backgroundColor: AppColors.border,
                                color: project.hasAllTasksCompleted
                                    ? AppColors.success
                                    : _getPriorityColor(),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${project.completedTasks}/${project.totalTasks}',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    // Date limite si elle existe
                    if (project.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: project.isOverdue
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(project.dueDate!),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: project.isOverdue
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                              fontWeight: project.isOverdue
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Statut
              if (project.isDone)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                )
              else
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}