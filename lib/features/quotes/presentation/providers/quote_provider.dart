import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/quote_datasource.dart';
import '../../data/datasources/favorite_quote_datasource.dart';
import '../../domain/entities/quote.dart';
import '../../../../core/services/storage/hive_service.dart';

// Provider du datasource
final quoteDataSourceProvider = Provider<QuoteDataSource>((ref) {
  return QuoteDataSource();
});

// Provider du datasource des favoris
final favoriteQuoteDataSourceProvider = Provider<FavoriteQuoteDataSource>((ref) {
  return FavoriteQuoteDataSourceImpl(HiveService.instance);
});

// Provider de la citation du jour
final dailyQuoteProvider = Provider<Quote>((ref) {
  final dataSource = ref.watch(quoteDataSourceProvider);
  final today = DateTime.now();
  return dataSource.getQuoteOfTheDay(today);
});

// Provider pour vérifier si une citation est en favori
final isQuoteFavoriteProvider = FutureProvider.family<bool, String>((ref, quoteText) async {
  final dataSource = ref.watch(favoriteQuoteDataSourceProvider);
  return await dataSource.isFavorite(quoteText);
});

// Notifier pour gérer les favoris
class FavoriteQuoteNotifier extends StateNotifier<AsyncValue<void>> {
  final FavoriteQuoteDataSource dataSource;
  final Ref ref;

  FavoriteQuoteNotifier(this.dataSource, this.ref) : super(const AsyncValue.data(null));

  Future<void> toggleFavorite(String quoteText, String author) async {
    state = const AsyncValue.loading();
    
    try {
      final isFavorite = await dataSource.isFavorite(quoteText);
      
      if (isFavorite) {
        await dataSource.removeFromFavorites(quoteText);
      } else {
        await dataSource.addToFavorites(quoteText, author);
      }
      
      // Invalider le provider pour rafraîchir l'état
      ref.invalidate(isQuoteFavoriteProvider(quoteText));
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final favoriteQuoteNotifierProvider = StateNotifierProvider<FavoriteQuoteNotifier, AsyncValue<void>>((ref) {
  final dataSource = ref.watch(favoriteQuoteDataSourceProvider);
  return FavoriteQuoteNotifier(dataSource, ref);
});