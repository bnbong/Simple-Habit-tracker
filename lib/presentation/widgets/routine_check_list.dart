import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/routine.dart';
import '../../domain/models/routine_check.dart';
import '../providers/routine_check_providers.dart';

class RoutineCheckList extends ConsumerWidget {
  final List<Routine> routines;
  final List<RoutineCheck> checks;

  const RoutineCheckList({
    super.key,
    required this.routines,
    required this.checks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Building RoutineCheckList with ${routines.length} routines and ${checks.length} checks');
    
    return ListView.builder(
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        final check = checks.firstWhere(
          (check) => check.routineId == routine.id,
          orElse: () {
            print('No check found for routine: ${routine.id}');
            return RoutineCheck(
              id: '',
              routineId: routine.id,
              date: DateTime.now(),
              isCompleted: false,
            );
          },
        );

        return CheckboxListTile(
          title: Text(routine.name),
          subtitle: routine.description != null ? Text(routine.description!) : null,
          value: check.isCompleted,
          onChanged: (value) {
            ref.read(dailyChecksProvider.notifier).toggleCheck(routine.id);
          },
        );
      },
    );
  }
} 