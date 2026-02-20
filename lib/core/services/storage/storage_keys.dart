/// Clés utilisées pour le stockage avec Hive
class StorageKeys {
  StorageKeys._();

  // Box names
  static const String moodBox = 'mood_box';
  static const String habitBox = 'habit_box';
  static const String habitCompletionBox = 'habit_completion_box';
  static const String favoriteQuotesBox = 'favorite_quotes_box';  // ← AJOUTER
  static const String todoBox = 'todo_box';
  static const String journalBox = 'journal_box';
  static const String quoteBox = 'quote_box';
  static const String settingsBox = 'settings_box';

  // Settings keys
  static const String themeMode = 'theme_mode';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String firstLaunch = 'first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String selectedLanguage = 'selected_language';

  // TypeId pour les adapters Hive (utilisés dans les annotations @HiveType)
  static const int moodEntryTypeId = 0;
  static const int habitTypeId = 1;
  static const int habitCompletionTypeId = 2;
  static const int todoTypeId = 3;
  static const int journalEntryTypeId = 4;
  static const int quoteTypeId = 5;
  static const int statisticTypeId = 6;
  static const int favoriteQuoteTypeId = 3;  // ← AJOUTER

  // Clé notes statistiques
  static const String metricNotesBox = 'metric_notes_box';  // ← AJOUTER
  static const int metricNoteTypeId = 4;  // ← AJOUTER

}
