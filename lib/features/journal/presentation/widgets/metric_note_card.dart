import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../statistics/domain/entities/metric_note.dart';

class MetricNoteCard extends StatelessWidget {
  final MetricNote note;
  final VoidCallback? onTap;

  const MetricNoteCard({
    super.key,
    required this.note,
    this.onTap,
  });

  String _getMetricLabel(String metricType) {
    switch (metricType) {
      case 'humeur':
        return 'Humeur';
      case 'motivation':
        return 'Motivation';
      case 'sommeil':
        return 'Sommeil';
      default:
        return metricType;
    }
  }

  Color _getMetricColor(String metricType) {
    switch (metricType) {
      case 'humeur':
        return const Color(0xFF62E1BB);
      case 'motivation':
        return const Color(0xFF6BCEF2);
      case 'sommeil':
        return const Color(0xFFFF6B9D);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: _getMetricColor(note.metricType).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec label et date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMetricColor(note.metricType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getMetricLabel(note.metricType),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getMetricColor(note.metricType),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('d MMM', 'fr_FR').format(note.weekStart),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.marginS),

              // Contenu
              Text(
                note.content,
                style: AppTextStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}