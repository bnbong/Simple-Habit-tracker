import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/routine_check.dart';
import '../../data/repositories/routine_check_repository_impl.dart';
import 'database_providers.dart';

final routineCheckRepositoryProvider = Provider<RoutineCheckRepositoryImpl>((ref) {
  final dataSource = ref.watch(routineCheckLocalDataSourceProvider);
  return RoutineCheckRepositoryImpl(dataSource);
});

final dailyChecksProvider = StateNotifierProvider<DailyChecksNotifier, AsyncValue<List<RoutineCheck>>>((ref) {
  final repository = ref.watch(routineCheckRepositoryProvider);
  return DailyChecksNotifier(repository);
});

final dailyProgressProvider = StateNotifierProvider<DailyProgressNotifier, AsyncValue<DailyProgress>>((ref) {
  final repository = ref.watch(routineCheckRepositoryProvider);
  return DailyProgressNotifier(repository);
});

class DailyChecksNotifier extends StateNotifier<AsyncValue<List<RoutineCheck>>> {
  final RoutineCheckRepositoryImpl _repository;

  DailyChecksNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTodayChecks();
  }

  Future<void> loadTodayChecks() async {
    state = const AsyncValue.loading();
    try {
      final checks = await _repository.getDailyChecks(DateTime.now());
      state = AsyncValue.data(checks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleCheck(String routineId) async {
    try {
      await _repository.toggleRoutineCheck(routineId, DateTime.now());
      await loadTodayChecks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

class DailyProgressNotifier extends StateNotifier<AsyncValue<DailyProgress>> {
  final RoutineCheckRepositoryImpl _repository;

  DailyProgressNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProgress();
  }

  Future<void> loadProgress() async {
    try {
      final progress = await _repository.getDailyProgress(DateTime.now());
      state = AsyncValue.data(progress);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
} 