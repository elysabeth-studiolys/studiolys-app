import '../../../../core/services/storage/hive_service.dart';
import '../models/favorite_quote_model.dart';

abstract class FavoriteQuoteDataSource {
  Future<bool> isFavorite(String quoteText);
  Future<void> addToFavorites(String quoteText, String author);
  Future<void> removeFromFavorites(String quoteText);
  Future<List<FavoriteQuoteModel>> getAllFavorites();
}

class FavoriteQuoteDataSourceImpl implements FavoriteQuoteDataSource {
  final HiveService hiveService;

  FavoriteQuoteDataSourceImpl(this.hiveService);

  @override
  Future<bool> isFavorite(String quoteText) async {
    final box = await hiveService.favoriteQuotesBox;
    return box.values.any((fav) => 
      (fav as FavoriteQuoteModel).quoteText == quoteText
    );
  }

  @override
  Future<void> addToFavorites(String quoteText, String author) async {
    final box = await hiveService.favoriteQuotesBox;
    final favorite = FavoriteQuoteModel(
      quoteText: quoteText,
      author: author,
      addedAt: DateTime.now(),
    );
    await box.add(favorite);
  }

  @override
  Future<void> removeFromFavorites(String quoteText) async {
    final box = await hiveService.favoriteQuotesBox;
    final key = box.keys.firstWhere(
      (key) => (box.get(key) as FavoriteQuoteModel).quoteText == quoteText,
      orElse: () => null,
    );
    if (key != null) {
      await box.delete(key);
    }
  }

  @override
  Future<List<FavoriteQuoteModel>> getAllFavorites() async {
    final box = await hiveService.favoriteQuotesBox;
    return box.values.cast<FavoriteQuoteModel>().toList();
  }
}