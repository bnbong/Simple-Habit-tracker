import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = "habit_tracker.db";
  static const _databaseVersion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // 플랫폼별 데이터베이스 경로 설정
    String path;
    if (Platform.isWindows || Platform.isLinux) {
      // 데스크톱 환경
      final databasePath = await databaseFactoryFfi.getDatabasesPath();
      path = join(databasePath, _databaseName);
    } else {
      // 모바일 환경
      path = join(await getDatabasesPath(), _databaseName);
    }

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 루틴 테이블 생성
    await db.execute('''
      CREATE TABLE routines(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // 루틴 체크 테이블 생성
    await db.execute('''
      CREATE TABLE routine_checks(
        id TEXT PRIMARY KEY,
        routine_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        FOREIGN KEY (routine_id) REFERENCES routines (id) ON DELETE CASCADE
      )
    ''');

    // 인덱스 생성
    await db.execute(
      'CREATE INDEX idx_routine_checks_date ON routine_checks(date)',
    );
    await db.execute(
      'CREATE INDEX idx_routine_checks_routine_id ON routine_checks(routine_id)',
    );
  }
}
