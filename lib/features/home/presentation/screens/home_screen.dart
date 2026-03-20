import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/date_selector.dart';
import '../widgets/week_selector.dart';
import '../widgets/circular_header.dart';
import '../widgets/mood_input_section.dart';
import '../widgets/habit_tracker_preview.dart';
import '../../../quotes/presentation/widgets/daily_quote_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),  // ← Couleur de fond verte
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),  // ← Bloque le bounce en haut
        child: Column(
          children: [
            // Header avec illustration
            CircularHeader(
              showIllustration: true,
              illustrationPath: 'assets/images/illustr_home.png',
              child: Column(
                children: [
                  const SizedBox(height: AppDimensions.marginXS),
                  
                  const WeekSelector(),
                  
                  const SizedBox(height: AppDimensions.marginM),
                  
                  const DateSelector(),
                  
                  const SizedBox(height: AppDimensions.marginM),
                ],
              ),
            ),

            // Contenu principal
            Transform.translate(
              offset: const Offset(0, -100), 
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MoodInputSection(),

                    const SizedBox(height: AppDimensions.marginXL),

                    const DailyQuoteCard(),

                    const SizedBox(height: AppDimensions.marginXL),

                    const HabitTrackerPreview(),
                    
                    const SizedBox(height: AppDimensions.marginXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}