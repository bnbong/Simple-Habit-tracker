import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class RoutineLocalDataSource {
  final Database database;
  final _uuid = const Uuid();

  RoutineLocalDataSource(this.database);

  Future<List<Map<String, dynamic>>> getRoutines() async {
    return await database.query('routines', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>> getRoutine(String id) async {
    final results = await database.query(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (results.isEmpty) {
      throw Exception('루틴을 찾을 수 없습니다');
    }
    
    return results.first;
  }

  Future<Map<String, dynamic>> insertRoutine(String name, String? description) async {
    final now = DateTime.now();
    final routine = {
      'id': _uuid.v4(),
      'name': name,
      'description': description,
      'created_at': now.millisecondsSinceEpoch,
      'updated_at': now.millisecondsSinceEpoch,
    };

    await database.insert('routines', routine);
    return routine;
  }

  Future<Map<String, dynamic>> updateRoutine(
    String id,
    String name,
    String? description,
  ) async {
    final routine = {
      'name': name,
      'description': description,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    };

    await database.update(
      'routines',
      routine,
      where: 'id = ?',
      whereArgs: [id],
    );

    return await getRoutine(id);
  }

  Future<void> deleteRoutine(String id) async {
    await database.delete(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 