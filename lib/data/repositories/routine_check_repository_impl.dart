import '../../domain/models/routine_check.dart';
import '../../domain/repositories/routine_check_repository.dart';
import '../datasources/routine_check_local_datasource.dart';

class RoutineCheckRepositoryImpl implements RoutineCheckRepository {
  final RoutineCheckLocalDataSource _localDataSource;

  RoutineCheckRepositoryImpl(this._localDataSource);

  @override
  Future<List<RoutineCheck>> getDailyChecks(DateTime date) async {
    final checksData = await _localDataSource.getDailyChecks(date);
    return checksData.map((data) => RoutineCheck.fromMap(data)).toList();
  }

  @override
  Future<RoutineCheck> toggleRoutineCheck(String routineId, DateTime date) async {
    final checkData = await _localDataSource.toggleCheck(routineId, date);
    return RoutineCheck.fromMap(checkData);
  }

  @override
  Future<void> initializeDailyChecks(DateTime date) async {
    // 루틴 ID 목록을 가져와서 초기화
    final routineIds = await _localDataSource.getAllRoutineIds();
    await _localDataSource.initializeChecks(date, routineIds);
  }

  @override
  Future<DailyProgress> getDailyProgress(DateTime date) async {
    final checks = await getDailyChecks(date);
    final completedCount = checks.where((check) => check.isCompleted).length;
    return DailyProgress(
      date: date,
      completedCount: completedCount,
      totalCount: checks.length,
    );
  }

  @override
  Future<void> archiveCompletedRoutines(DateTime date) async {
    // 구현 예정
  }
} 