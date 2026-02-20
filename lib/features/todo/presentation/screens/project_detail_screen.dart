import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/project.dart';
import '../../domain/entities/project_task.dart';
import '../providers/project_provider.dart';
import '../widgets/project_task_item_widget.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDetailScreen({
    super.key,
    required this.project,
  });

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  late Project _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(date);
  }

  Color _getPriorityColor() {
    switch (_project.priority) {
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

  void _toggleDone() async {
    await ref.read(projectNotifierProvider.notifier).toggleProjectDone(_project.id);
    setState(() {
      _project = _project.toggleDone();
    });
  }

  void _deleteProject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce projet ?'),
        content: const Text('Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(projectNotifierProvider.notifier).deleteProject(_project.id);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _editProject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction d\'édition à venir')),
    );
  }

  void _addTask() {
    final taskController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        title: Text('Nouvelle tâche', style: AppTextStyles.h4),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(
            labelText: 'Titre de la tâche',
            hintText: 'Ex: Faire les maquettes',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (taskController.text.isNotEmpty) {
                final newTask = ProjectTask(
                  id: const Uuid().v4(),
                  title: taskController.text,
                );
                
                final updatedProject = _project.copyWith(
                  tasks: [..._project.tasks, newTask],
                );
                
                final repository = await ref.read(projectRepositoryProvider.future);
                await repository.saveProject(updatedProject);
                
                setState(() {
                  _project = updatedProject;
                });
                
                ref.invalidate(allProjectsProvider);
                if (mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _toggleTask(ProjectTask task) async {
    final updatedTasks = _project.tasks.map((t) {
      if (t.id == task.id) {
        return t.toggleDone();
      }
      return t;
    }).toList();

    final updatedProject = _project.copyWith(tasks: updatedTasks);
    
    final repository = await ref.read(projectRepositoryProvider.future);
    await repository.saveProject(updatedProject);
    
    setState(() {
      _project = updatedProject;
    });
    
    ref.invalidate(allProjectsProvider);
  }

  void _deleteTask(ProjectTask task) async {
    final updatedTasks = _project.tasks.where((t) => t.id != task.id).toList();
    final updatedProject = _project.copyWith(tasks: updatedTasks);
    
    final repository = await ref.read(projectRepositoryProvider.future);
    await repository.saveProject(updatedProject);
    
    setState(() {
      _project = updatedProject;
    });
    
    ref.invalidate(allProjectsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: Text(
          'Détail du projet',
          style: AppTextStyles.h4,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: _editProject,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: _deleteProject,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte principale
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    Text(
                      _project.title,
                      style: AppTextStyles.h3,
                    ),

                    const SizedBox(height: AppDimensions.marginL),

                    // Catégorie
                    Row(
                      children: [
                        const Icon(
                          Icons.folder,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _project.category,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.marginM),

                    // Priorité
                    Row(
                      children: [
                        Icon(
                          Icons.flag,
                          size: 20,
                          color: _getPriorityColor(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Priorité: ${_project.priority.label}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _getPriorityColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Date limite
                    if (_project.dueDate != null) ...[
                      const SizedBox(height: AppDimensions.marginM),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: _project.isOverdue
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _project.isOverdue
                                  ? 'En retard depuis le ${_formatDate(_project.dueDate!)}'
                                  : 'À terminer le ${_formatDate(_project.dueDate!)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: _project.isOverdue
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                                fontWeight: _project.isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: AppDimensions.marginXL),

                    // Statut
                    ElevatedButton(
                      onPressed: _toggleDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _project.isDone 
                            ? AppColors.success 
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_project.isDone ? Icons.check_circle : Icons.circle_outlined),
                          const SizedBox(width: 8),
                          Text(_project.isDone ? 'Terminé' : 'Marquer comme terminé'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.marginL),

              // Description
              if (_project.description != null && _project.description!.isNotEmpty) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: AppDimensions.marginM),
                      Text(
                        _project.description!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.marginL),
              ],

              // Tâches
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tâches',
                          style: AppTextStyles.h4,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppColors.primary,
                          ),
                          onPressed: _addTask,
                        ),
                      ],
                    ),
                    
                    // Barre de progression
                    if (_project.totalTasks > 0) ...[
                      const SizedBox(height: AppDimensions.marginM),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_project.completedTasks}/${_project.totalTasks} terminées',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_project.completionPercentage.toStringAsFixed(0)}%',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _project.completionPercentage / 100,
                              backgroundColor: AppColors.border,
                              color: _project.hasAllTasksCompleted
                                  ? AppColors.success
                                  : AppColors.primary,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: AppDimensions.marginL),
                    
                    // Liste des tâches
                    if (_project.tasks.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Aucune tâche pour ce projet',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: _project.tasks.map((task) {
                          return ProjectTaskItemWidget(
                            task: task,
                            onToggle: () => _toggleTask(task),
                            onDelete: () => _deleteTask(task),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.marginL),

              // Statistiques
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: AppDimensions.marginL),
                    _buildInfoRow(
                      'Créé le',
                      _formatDate(_project.createdAt),
                      Icons.add_circle_outline,
                    ),
                    if (_project.dueDate != null && !_project.isDone) ...[
                      const SizedBox(height: AppDimensions.marginM),
                      _buildInfoRow(
                        'Jours restants',
                        '${_project.daysUntilDue} jours',
                        Icons.timer_outlined,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: AppDimensions.marginXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}