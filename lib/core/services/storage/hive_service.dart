import 'package:hive_flutter/hive_flutter.dart';
import 'storage_keys.dart';

/// Service de gestion du stockage local avec Hive
class HiveService {
  static HiveService? _instance;
  static HiveService get instance => _instance ??= HiveService._();

  HiveService._();

  /// Initialise Hive
  Future<void> init() async {
    await Hive.initFlutter();
    // Les adapters seront enregistrés ici après génération
  }

  /// Ouvre une box
  Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Ferme une box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Ferme toutes les boxes
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  /// Supprime une box
  Future<void> deleteBox(String boxName) async {
    await closeBox(boxName);
    await Hive.deleteBoxFromDisk(boxName);
  }

  /// Vérifie si une box existe
  bool isBoxOpen(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  // Méthodes helpers pour les boxes spécifiques

  /// Box pour les mood entries
  Future<Box> get moodBox => openBox(StorageKeys.moodBox);

  /// Box pour les habits
  Future<Box> get habitBox => openBox(StorageKeys.habitBox);

  /// Box pour les habit completions
  Future<Box> get habitCompletionBox => openBox(StorageKeys.habitCompletionBox);

  /// Box pour les todos
  Future<Box> get todoBox => openBox(StorageKeys.todoBox);

  /// Box pour les journal entries
  Future<Box> get journalBox => openBox(StorageKeys.journalBox);

  /// Box pour les quotes
  Future<Box> get quoteBox => openBox(StorageKeys.quoteBox);

  /// Box pour les settings
  Future<Box> get settingsBox => openBox(StorageKeys.settingsBox);
  
  /// Box pour les favorite quotes
  Future<Box> get favoriteQuotesBox => openBox(StorageKeys.favoriteQuotesBox);

  /// Box pour les notes de métriques
  Future<Box> get metricNotesBox => openBox(StorageKeys.metricNotesBox);  // ← AJOUTER


}
