import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker_app/features/todo/presentation/screens/project_detail_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/simple_circular_header.dart';
import '../../../statistics/presentation/widgets/week_selector.dart';
import '../providers/todo_provider.dart';
import '../providers/project_provider.dart';  
import '../widgets/todo_item_widget.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/project_item_widget.dart';  
import '../widgets/add_project_dialog.dart';  
import '../../../home/presentation/widgets/habit_tracker_preview.dart';
import '../screens/todo_screen.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(selectedTodoWeekProvider);
    final weekEnd = selectedWeek.add(const Duration(days: 6));
    final todosAsync = ref.watch(weeklyTodosProvider(selectedWeek));
    final projectsAsync = ref.watch(allProjectsProvider);  

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header
            SimpleCircularHeader(
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.marginS),
                  WeekSelector(
                    weekStart: selectedWeek,
                    weekEnd: weekEnd,
                    onPrevious: () {
                      final newWeek = selectedWeek.subtract(const Duration(days: 7));
                      ref.read(selectedTodoWeekProvider.notifier).state = newWeek;
                    },
                    onNext: () {
                      final newWeek = selectedWeek.add(const Duration(days: 7));
                      ref.read(selectedTodoWeekProvider.notifier).state = newWeek;
                    },
                  ),
                ],
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.marginM),
                  
                  // Tracker d'habitudes
                  const HabitTrackerPreview(),

                  const SizedBox(height: AppDimensions.marginXL),

                  // To-Do List
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To-Do list',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: AppDimensions.marginL),

                        // Liste des todos
                        todosAsync.when(
                          data: (todos) {
                            if (todos.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                                  child: Text(
                                    'Aucune tâche pour cette semaine',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: todos.map((todo) {
                                return TodoItemWidget(
                                  key: ValueKey(todo.id),
                                  todo: todo,
                                  onToggle: () => ref
                                      .read(todoNotifierProvider.notifier)
                                      .toggleTodo(todo.id),
                                  onDelete: () => _deleteTodo(context, ref, todo.id),
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
                          error: (_, __) => const SizedBox(),
                        ),

                        const SizedBox(height: AppDimensions.marginM),

                        // Bouton ajouter
                        Center(
                          child: GradientButton(
                            text: 'Ajouter une tâche',
                            icon: Icons.add,
                            onPressed: () => _showAddTodoDialog(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.marginXL),

                  //  SECTION PROJETS 
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Projets',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: AppDimensions.marginL),

                        // Liste des projets
                        projectsAsync.when(
                          data: (projects) {
                            if (projects.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                                  child: Text(
                                    'Aucun projet pour le moment',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: projects.map((project) {
                                return ProjectItemWidget(
                                  key: ValueKey(project.id),
                                  project: project,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectDetailScreen(
                                          project: project,
                                          )
                                      )
                                    );
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
                          error: (_, __) => const SizedBox(),
                        ),

                        const SizedBox(height: AppDimensions.marginM),

                        // Bouton ajouter
                        Center(
                          child: GradientButton(
                            text: 'Nouveau projet',
                            icon: Icons.add,
                            onPressed: () => _showAddProjectDialog(context, ref),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.marginXL),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTodoDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (result != null && context.mounted) {
      final success = await ref
          .read(todoNotifierProvider.notifier)
          .addTodo(result['title'], result['date']);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tâche ajoutée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _showAddProjectDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddProjectDialog(),
    );

    if (result != null && context.mounted) {
      final success = await ref
          .read(projectNotifierProvider.notifier)
          .addProject(
            title: result['title'],
            category: result['category'],
            description: result['description'],
            dueDate: result['dueDate'],
            priority: result['priority'],
          );

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Projet créé avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _deleteTodo(BuildContext context, WidgetRef ref, String todoId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
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
      await ref.read(todoNotifierProvider.notifier).deleteTodo(todoId);
    }
  }
}