import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quote_provider.dart';

class DailyQuoteCard extends ConsumerWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(dailyQuoteProvider);
    final isFavoriteAsync = ref.watch(isQuoteFavoriteProvider(quote.text));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        boxShadow: [
          
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Barre verte à gauche
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: AppDimensions.marginM),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Citation
                  Text(
                    quote.text,
                    style: AppTextStyles.quote,
                  ),

                  const SizedBox(height: AppDimensions.marginM),

                  // Auteur
                  Text(
                    '— ${quote.author}',
                    style: AppTextStyles.quoteAuthor,
                  ),

                  const SizedBox(height: AppDimensions.marginL),

                  // Bouton favori
                  isFavoriteAsync.when(
                    data: (isFavorite) => GestureDetector(
                      onTap: () {
                        ref
                            .read(favoriteQuoteNotifierProvider.notifier)
                            .toggleFavorite(quote.text, quote.author);
                      },
                      child: Row(
                        children: [
                          Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.accent,
                            size: AppDimensions.iconM,
                          ),
                          const SizedBox(width: AppDimensions.marginS),
                          Text(
                            isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: AppDimensions.marginS),
                        Text(
                          'Chargement...',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    error: (_, __) => Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          color: AppColors.accent,
                          size: AppDimensions.iconM,
                        ),
                        const SizedBox(width: AppDimensions.marginS),
                        Text(
                          'Ajouter aux favoris',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}