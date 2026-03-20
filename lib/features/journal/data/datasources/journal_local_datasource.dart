import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry_model.dart';

class JournalLocalDataSource {
  static const String boxName = 'journal_entries';
  late Box<JournalEntryModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<JournalEntryModel>(boxName);
  }

  Future<void> saveEntry(JournalEntryModel entry) async {
    await _box.put(entry.id, entry);
  }

  List<JournalEntryModel> getAllEntries(){
    return _box.values.toList();
  }

  JournalEntryModel? getEntry(String id) {
    return _box.get(id);
  }

  Future<void> deleteEntry(String id) async {
    await _box.delete(id);
  }
}

