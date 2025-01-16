import '../models/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getRoutines();
  Future<Routine> getRoutine(String id);
  Future<Routine> createRoutine(String name, String? description);
  Future<Routine> updateRoutine(String id, String name, String? description);
  Future<void> deleteRoutine(String id);
} 