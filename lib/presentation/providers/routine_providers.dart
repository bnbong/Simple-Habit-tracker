import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/routine.dart';
import '../../data/repositories/routine_repository_impl.dart';
import '../providers/database_providers.dart';

final routineRepositoryProvider = Provider<RoutineRepositoryImpl>((ref) {
  final dataSource = ref.watch(routineLocalDataSourceProvider);
  return RoutineRepositoryImpl(dataSource);
});

final routinesProvider = StateNotifierProvider<RoutinesNotifier, AsyncValue<List<Routine>>>((ref) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutinesNotifier(repository);
});

class RoutinesNotifier extends StateNotifier<AsyncValue<List<Routine>>> {
  final RoutineRepositoryImpl _repository;

  RoutinesNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadRoutines();
  }

  Future<void> loadRoutines() async {
    try {
      final routines = await _repository.getRoutines();
      state = AsyncValue.data(routines);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createRoutine(String name, String? description) async {
    try {
      await _repository.createRoutine(name, description);
      await loadRoutines();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateRoutine(String id, String name, String? description) async {
    try {
      await _repository.updateRoutine(id, name, description);
      await loadRoutines();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await _repository.deleteRoutine(id);
      await loadRoutines();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
} 