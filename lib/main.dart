import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/services/storage/hive_service.dart';
import 'core/services/storage/register_adapters.dart';
import 'features/todo/data/datasources/todo_local_datasource.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await initializeDateFormatting('fr_FR', null);

  await HiveService.instance.init();
  
  await registerHiveAdapters();

  final todoDataSource = TodoLocalDataSource();
  await todoDataSource.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}