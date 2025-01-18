import 'package:flutter/material.dart';
import '../../domain/models/calendar_data.dart';
import 'package:intl/intl.dart';

class MonthlyStatisticsWidget extends StatelessWidget {
  final MonthlyStatistics statistics;

  const MonthlyStatisticsWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final percentFormat = NumberFormat.percentPattern();
    final dateFormat = DateFormat('M월 d일');

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '월간 통계',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('평균 완료율: ${percentFormat.format(statistics.averageCompletionRate)}'),
            if (statistics.bestPerformanceDate != null)
              Text('가장 성실한 날: ${dateFormat.format(statistics.bestPerformanceDate!)}'),
            Text('현재 연속 달성: ${statistics.currentStreak}일'),
          ],
        ),
      ),
    );
  }
} 