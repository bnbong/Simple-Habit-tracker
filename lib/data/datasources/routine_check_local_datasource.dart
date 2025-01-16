import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class RoutineCheckLocalDataSource {
  final Database database;
  final _uuid = const Uuid();

  RoutineCheckLocalDataSource(this.database);

  Future<List<Map<String, dynamic>>> getDailyChecks(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return await database.query(
      'routine_checks',
      where: 'date >= ? AND date < ?',
      whereArgs: [startOfDay.millisecondsSinceEpoch, endOfDay.millisecondsSinceEpoch],
    );
  }

  Future<Map<String, dynamic>> toggleCheck(String routineId, DateTime date) async {
    final check = await _getOrCreateCheck(routineId, date);
    final updatedCheck = {
      ...check,
      'is_completed': check['is_completed'] == 0 ? 1 : 0,
      'completed_at': check['is_completed'] == 0 ? DateTime.now().millisecondsSinceEpoch : null,
    };

    await database.update(
      'routine_checks',
      updatedCheck,
      where: 'id = ?',
      whereArgs: [check['id']],
    );

    return updatedCheck;
  }

  Future<Map<String, dynamic>> _getOrCreateCheck(String routineId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final results = await database.query(
      'routine_checks',
      where: 'routine_id = ? AND date = ?',
      whereArgs: [routineId, startOfDay.millisecondsSinceEpoch],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    final newCheck = {
      'id': _uuid.v4(),
      'routine_id': routineId,
      'date': startOfDay.millisecondsSinceEpoch,
      'is_completed': 0,
      'completed_at': null,
    };

    await database.insert('routine_checks', newCheck);
    return newCheck;
  }

  Future<void> initializeChecks(DateTime date, List<String> routineIds) async {
    final batch = database.batch();
    final startOfDay = DateTime(date.year, date.month, date.day);

    for (final routineId in routineIds) {
      batch.insert('routine_checks', {
        'id': _uuid.v4(),
        'routine_id': routineId,
        'date': startOfDay.millisecondsSinceEpoch,
        'is_completed': 0,
        'completed_at': null,
      });
    }

    await batch.commit();
  }

  Future<List<String>> getAllRoutineIds() async {
    final results = await database.query(
      'routines',
      columns: ['id'],
    );
    return results.map((row) => row['id'] as String).toList();
  }
} 