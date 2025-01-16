import 'package:flutter/material.dart';
import '../../domain/models/routine_check.dart';

class DailyProgressWidget extends StatelessWidget {
  final DailyProgress progress;

  const DailyProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress.completionRate,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.completedCount}/${progress.totalCount} 완료',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
} 