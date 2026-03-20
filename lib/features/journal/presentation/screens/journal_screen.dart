import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/simple_circular_header.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_entry_card.dart';
import '../widgets/favorite_quote_card.dart';
import '../widgets/metric_note_card.dart';
import '../widgets/add_journal_entry_dialog.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  bool _showAllQuotes = false; // Pour "Voir plus"

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final journalEntriesAsync = ref.watch(monthJournalEntriesProvider);
    final metricNotesAsync = ref.watch(monthMetricNotesProvider);
    final favoriteQuotesAsync = ref.watch(monthFavoriteQuotesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header avec navigation mensuelle
            SimpleCircularHeader(
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.marginS),
                  
                  // Navigation entre les mois
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: AppColors.accent),
                          onPressed: () => _previousMonth(),
                        ),
                        Text(
                          _getMonthYearText(selectedMonth),
                          style: AppTextStyles.headerLight.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right, color: AppColors.accent),
                          onPressed: () => _nextMonth(),
                        ),
                      ],
                    ),
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

                  // 1. Section Mes Notes
                  _buildSection(
                    title: 'Mes notes',
                    icon: Icons.edit_note,
                    onAdd: () => _showAddEntryDialog(context, ref),
                    child: journalEntriesAsync.when(
                      data: (entries) {
                        if (entries.isEmpty) {
                          return _buildEmptyState(
                            'Aucune note ce mois-ci',
                            'Commencez à écrire vos pensées',
                          );
                        }
                        return Column(
                          children: entries.map((entry) {
                            return JournalEntryCard(
                              entry: entry,
                              onDelete: () => _deleteEntry(context, ref, entry.id),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.marginXL),

                  // 2. Section Notes de Suivi
                  _buildSection(
                    title: 'Notes de suivi',
                    icon: Icons.insights,
                    child: metricNotesAsync.when(
                      data: (notes) {
                        if (notes.isEmpty) {
                          return _buildEmptyState(
                            'Aucune note de suivi ce mois-ci',
                            'Ajoutez des notes depuis les statistiques',
                          );
                        }
                        return Column(
                          children: notes.map((note) {
                            return MetricNoteCard(note: note);
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.marginXL),

                  // 3. Section Citations Favorites (avec "Voir plus")
                  _buildSection(
                    title: 'Citations favorites',
                    icon: Icons.format_quote,
                    child: favoriteQuotesAsync.when(
                      data: (quotes) {
                        if (quotes.isEmpty) {
                          return _buildEmptyState(
                            'Aucune citation favorite',
                            'Ajoutez des citations depuis l\'accueil',
                          );
                        }

                        // Limiter à 2 si "Voir plus" n'est pas activé
                        final displayedQuotes = _showAllQuotes 
                            ? quotes 
                            : quotes.take(2).toList();

                        return Column(
                          children: [
                            ...displayedQuotes.map((quote) {
                              return FavoriteQuoteCard(quote: quote);
                            }).toList(),
                            
                            // Bouton "Voir plus" si plus de 2 citations
                            if (quotes.length > 2)
                              Padding(
                                padding: const EdgeInsets.only(top: AppDimensions.marginM),
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _showAllQuotes = !_showAllQuotes;
                                    });
                                  },
                                  icon: Icon(
                                    _showAllQuotes 
                                        ? Icons.expand_less 
                                        : Icons.expand_more,
                                    color: AppColors.primary,
                                  ),
                                  label: Text(
                                    _showAllQuotes 
                                        ? 'Voir moins' 
                                        : 'Voir plus (${quotes.length - 2} autre${quotes.length - 2 > 1 ? 's' : ''})',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const SizedBox(),
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

  String _getMonthYearText(DateTime date) {
    return DateFormat('MMMM yyyy', 'fr_FR').format(date);
  }

  void _previousMonth() {
    final current = ref.read(selectedMonthProvider);
    final previous = DateTime(current.year, current.month - 1, 1);
    ref.read(selectedMonthProvider.notifier).state = previous;
    
    // Réinitialiser "Voir plus"
    setState(() {
      _showAllQuotes = false;
    });
  }

  void _nextMonth() {
    final current = ref.read(selectedMonthProvider);
    final next = DateTime(current.year, current.month + 1, 1);
    ref.read(selectedMonthProvider.notifier).state = next;
    
    // Réinitialiser "Voir plus"
    setState(() {
      _showAllQuotes = false;
    });
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    VoidCallback? onAdd,
    required Widget child,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(title, style: AppTextStyles.h4),
                ],
              ),
              if (onAdd != null)
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_circle, color: AppColors.primary),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.marginL),
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEntryDialog(BuildContext context, WidgetRef ref) async {
    final content = await showDialog<String>(
      context: context,
      builder: (context) => const AddJournalEntryDialog(),
    );

    if (content != null && context.mounted) {
      final success = await ref
          .read(journalNotifierProvider.notifier)
          .addEntry(content);

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

  Future<void> _deleteEntry(BuildContext context, WidgetRef ref, String entryId) async {
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
      await ref.read(journalNotifierProvider.notifier).deleteEntry(entryId);
    }
  }
}