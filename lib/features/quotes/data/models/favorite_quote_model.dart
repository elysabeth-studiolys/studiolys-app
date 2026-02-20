import 'package:hive/hive.dart';

part 'favorite_quote_model.g.dart';

@HiveType(typeId: 3)
class FavoriteQuoteModel extends HiveObject {
  @HiveField(0)
  final String quoteText;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final DateTime addedAt;

  FavoriteQuoteModel({
    required this.quoteText,
    required this.author,
    required this.addedAt,
  });
}