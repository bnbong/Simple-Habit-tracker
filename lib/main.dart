import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:logging/logging.dart';
import 'presentation/screens/home_screen.dart';
import 'data/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 로깅 설정
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('Main');

  // SQLite 초기화
  if (Platform.isIOS || Platform.isAndroid) {
    // 모바일 플랫폼에서는 기본 sqflite 사용
    final database = await DatabaseHelper.instance.database;
    logger.info('Mobile database initialized: ${database.path}');
  } else {
    // 데스크톱/웹 플랫폼에서는 적절한 데이터베이스 엔진 사용
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final database = await DatabaseHelper.instance.database;
    logger.info('Desktop database initialized: ${database.path}');
  }

  runApp(
    const ProviderScope(
      child: HabitTrackerApp(),
    ),
  );
}

class HabitTrackerApp extends ConsumerWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: '일일 루틴',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
