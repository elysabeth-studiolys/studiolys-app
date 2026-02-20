import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';

class MoodSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const MoodSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.sliderLabel),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('0', style: AppTextStyles.sliderValue),
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: onChanged,
              ),
            ),
            Text('10', style: AppTextStyles.sliderValue),
          ],
        ),
      ],
    );
  }
}
