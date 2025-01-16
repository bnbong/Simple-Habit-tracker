import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'presentation/screens/home_screen.dart';
import 'data/database/database_helper.dart';
import 'presentation/providers/database_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // SQLite 초기화
  if (Platform.isIOS || Platform.isAndroid) {
    // 모바일 플랫폼에서는 기본 sqflite 사용
    final database = await DatabaseHelper.instance.database;
    print('Mobile database initialized: ${database.path}');
  } else {
    // 데스크톱 플랫폼에서는 FFI 사용
    // TODO: 수정 필요, 적절한 web db engine 링크
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final database = await DatabaseHelper.instance.database;
    print('Desktop database initialized: ${database.path}');
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
