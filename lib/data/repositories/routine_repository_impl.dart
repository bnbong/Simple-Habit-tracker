import '../../domain/models/routine.dart';
import '../../domain/repositories/routine_repository.dart';
import '../datasources/routine_local_datasource.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineLocalDataSource _localDataSource;

  RoutineRepositoryImpl(this._localDataSource);

  @override
  Future<List<Routine>> getRoutines() async {
    final routinesData = await _localDataSource.getRoutines();
    return routinesData.map((data) => Routine.fromMap(data)).toList();
  }

  @override
  Future<Routine> getRoutine(String id) async {
    final routineData = await _localDataSource.getRoutine(id);
    return Routine.fromMap(routineData);
  }

  @override
  Future<Routine> createRoutine(String name, String? description) async {
    final routineData = await _localDataSource.insertRoutine(name, description);
    return Routine.fromMap(routineData);
  }

  @override
  Future<Routine> updateRoutine(String id, String name, String? description) async {
    final routineData = await _localDataSource.updateRoutine(id, name, description);
    return Routine.fromMap(routineData);
  }

  @override
  Future<void> deleteRoutine(String id) async {
    await _localDataSource.deleteRoutine(id);
  }
} 