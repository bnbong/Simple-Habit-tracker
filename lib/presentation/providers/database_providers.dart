import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/database/database_helper.dart';
import '../../data/datasources/routine_local_datasource.dart';
import '../../data/datasources/routine_check_local_datasource.dart';

final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError('데이터베이스가 초기화되지 않았습니다');
});

final databaseInitializerProvider = FutureProvider<Database>((ref) async {
  final database = await DatabaseHelper.instance.database;
  ref.state = AsyncData(database);
  return database;
});

final routineLocalDataSourceProvider = Provider<RoutineLocalDataSource>((ref) {
  final database = ref.watch(databaseInitializerProvider).value;
  if (database == null) throw Exception('데이터베이스가 초기화되지 않았습니다');
  return RoutineLocalDataSource(database);
});

final routineCheckLocalDataSourceProvider = Provider<RoutineCheckLocalDataSource>((ref) {
  final database = ref.watch(databaseInitializerProvider).value;
  if (database == null) throw Exception('데이터베이스가 초기화되지 않았습니다');
  return RoutineCheckLocalDataSource(database);
}); 