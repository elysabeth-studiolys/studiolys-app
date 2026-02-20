import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../domain/entities/mood_entry.dart';

class MoodSummaryCard extends StatelessWidget {
  final MoodEntry moodEntry;
  final VoidCallback onEdit;

  const MoodSummaryCard({
    super.key,
    required this.moodEntry,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm', 'fr_FR');
    final savedTime = timeFormat.format(moodEntry.createdAt);
    final isToday = _isToday(moodEntry.date);
    final dateText = isToday ? 'Aujourd\'hui $savedTime' : DateFormat('dd/MM à HH:mm', 'fr_FR').format(moodEntry.createdAt);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: AppDimensions.marginM),
              

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Données enregistrées',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              

              GestureDetector(
                onTap: onEdit,
                child: Container(
                  
                  child: const Icon(
                    Icons.edit,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.marginM),


          Row(
            children: [
              // Humeur
              Expanded(
                child: _buildMetricBadge(
                  label: 'Humeur',
                  value: moodEntry.humeur,
                  color: const Color(0xFFFF6B9D),
                  backgroundColor: const Color(0xFFFFE5ED),
                ),
              ),
              
              const SizedBox(width: AppDimensions.marginS),
              
              // Énergie (Motivation)
              Expanded(
                child: _buildMetricBadge(
                  label: 'Énergie',
                  value: moodEntry.motivation,
                  color: const Color(0xFF4CAF50),
                  backgroundColor: const Color(0xFFE8F5E9),
                ),
              ),
              
              const SizedBox(width: AppDimensions.marginS),
              
              // Anxiété (inversé du sommeil pour l'affichage)
              Expanded(
                child: _buildMetricBadge(
                  label: 'Sommeil',
                  value: moodEntry.sommeil,
                  color: const Color(0xFFFF9800),
                  backgroundColor: const Color(0xFFFFF3E0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadge({
    required String label,
    required double value,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      height: 53,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            value.toStringAsFixed(0),
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}