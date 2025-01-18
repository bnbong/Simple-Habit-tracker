import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_providers.dart';
import '../providers/routine_providers.dart';
import '../../domain/models/routine.dart';

class DailyDetailsSheet extends ConsumerWidget {
  final DateTime date;

  const DailyDetailsSheet({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checksAsync = ref.watch(dailyRoutineChecksProvider(date));
    final routinesAsync = ref.watch(routinesProvider);
    final dateFormat = DateFormat('yyyy년 M월 d일');

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          checksAsync.when(
            data: (checks) {
              return routinesAsync.when(
                data: (routines) {
                  if (checks.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('해당 날짜에 기록된 데이터가 없습니다'),
                      ),
                    );
                  }

                  final completedCount = checks.where((check) => check.isCompleted).length;
                  final completionRate = checks.isEmpty ? 0.0 : completedCount / checks.length;
                  final percentFormat = NumberFormat.percentPattern();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('완료율: ${percentFormat.format(completionRate)}'),
                      Text('완료된 루틴: $completedCount/${checks.length}'),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: checks.length,
                        itemBuilder: (context, index) {
                          final check = checks[index];
                          final routine = routines.firstWhere(
                            (r) => r.id == check.routineId,
                            orElse: () => Routine(
                              id: check.routineId,
                              name: '삭제된 루틴',
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            ),
                          );
                          
                          return ListTile(
                            leading: Icon(
                              check.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                              color: check.isCompleted ? Colors.green : Colors.grey,
                            ),
                            title: Text(routine.name),
                            subtitle: check.completedAt != null
                                ? Text('완료 시간: ${DateFormat('HH:mm').format(check.completedAt!)}')
                                : null,
                          );
                        },
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('루틴 데이터를 불러오는 중 오류가 발생했습니다: $error'),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('데이터를 불러오는 중 오류가 발생했습니다: $error'),
            ),
          ),
        ],
      ),
    );
  }
} 