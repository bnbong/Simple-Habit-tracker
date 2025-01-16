import '../models/routine_check.dart';

abstract class RoutineCheckRepository {
  Future<List<RoutineCheck>> getDailyChecks(DateTime date);
  Future<RoutineCheck> toggleRoutineCheck(String routineId, DateTime date);
  Future<void> initializeDailyChecks(DateTime date);
  Future<DailyProgress> getDailyProgress(DateTime date);
  Future<void> archiveCompletedRoutines(DateTime date);
} 