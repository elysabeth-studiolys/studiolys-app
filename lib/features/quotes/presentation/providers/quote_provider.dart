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

// Provider pour récupérer TOUTES les citations favorites
final favoriteQuotesProvider = FutureProvider<List<Quote>>((ref) async {
  final dataSource = ref.watch(favoriteQuoteDataSourceProvider);
  final favoriteModels = await dataSource.getAllFavorites();

  favoriteModels.sort((a, b) => b.addedAt.compareTo(a.addedAt));
  
  // Convertir FavoriteQuoteModel en Quote
  return favoriteModels.map((model) => Quote(
    text: model.quoteText,
    author: model.author,
  )).toList();
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
      
      // Invalider les providers pour rafraîchir l'état
      ref.invalidate(isQuoteFavoriteProvider(quoteText));
      ref.invalidate(favoriteQuotesProvider);  // Rafraîchir la liste complète
      
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