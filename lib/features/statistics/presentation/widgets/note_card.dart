import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/metric_note.dart';

class NoteCard extends StatelessWidget {
  final MetricNote note;
  final VoidCallback? onDelete;
  final Color? backgroundColor;  
  final Color? textColor; 

  const NoteCard({
    super.key,
    required this.note,
    this.onDelete,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXS),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,  
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
     
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('d MMMM yyyy', 'fr_FR').format(note.createdAt),
                style: AppTextStyles.labelSmall.copyWith(
                  color: (textColor ?? AppColors.textPrimary).withOpacity(0.7),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: (textColor ?? AppColors.error).withOpacity(0.7),
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}