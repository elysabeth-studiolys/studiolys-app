import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../features/home/data/models/mood_entry_model.dart';
import '../../../features/todo/data/models/habit_model.dart';
import '../../../features/todo/data/models/habit_completion_model.dart';
import '../../../features/quotes/data/models/favorite_quote_model.dart';  // ← AJOUTER
import '../../../features/statistics/data/models/metric_note_model.dart';  // ← AJOUTER
import '../../../features/todo/data/models/todo_item_model.dart';
import '../../../features/todo/data/models/project_model.dart';
import '../../../features/todo/data/models/project_task_model.dart';

/// Enregistre tous les adapteurs Hive de l'application
Future<void> registerHiveAdapters() async {
  // MoodEntry
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MoodEntryModelAdapter());
  }
  
  // Habit
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(HabitModelAdapter());
  }
  
  // HabitCompletion
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(HabitCompletionModelAdapter());
  }

  // FavoriteQuoteModel 
    if (!Hive.isAdapterRegistered(3)) {  // ← AJOUTER
    Hive.registerAdapter(FavoriteQuoteModelAdapter());
  }
  // MetricNoteModel
  if (!Hive.isAdapterRegistered(4)) {  // ← AJOUTER
    Hive.registerAdapter(MetricNoteModelAdapter());
  }

  //TodoItemModel
  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(TodoItemModelAdapter());  
  }

  if(!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(ProjectModelAdapter());
  }
  if(!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(ProjectTaskModelAdapter());
  }
}