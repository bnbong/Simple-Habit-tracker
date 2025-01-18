import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/routine_providers.dart';
import '../providers/routine_check_providers.dart';
import '../widgets/routine_check_list.dart';
import '../widgets/daily_progress.dart';
import '../widgets/add_routine_dialog.dart';
import '../providers/database_providers.dart';
import 'calendar_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbState = ref.watch(databaseInitializerProvider);

    return dbState.when(
      data: (_) => const _HomeScreenContent(),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
      ),
    );
  }
}

class _HomeScreenContent extends ConsumerWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesState = ref.watch(routinesProvider);
    final checksState = ref.watch(dailyChecksProvider);
    final progressState = ref.watch(dailyProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('일일 루틴'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CalendarScreen(),
              ),
            ),
          ),
        ],
      ),
      body: routinesState.when(
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('등록된 루틴이 없습니다'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddRoutineDialog(context, ref),
                    child: const Text('루틴 추가하기'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              progressState.when(
                data: (progress) => DailyProgressWidget(progress: progress),
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('진행 상황 로딩 오류: $error'),
              ),
              Expanded(
                child: checksState.when(
                  data: (checks) => RoutineCheckList(
                    routines: routines,
                    checks: checks,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) =>
                      Center(child: Text('체크리스트 로딩 오류: $error')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('오류가 발생했습니다: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRoutineDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddRoutineDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddRoutineDialog(),
    );
  }
}
