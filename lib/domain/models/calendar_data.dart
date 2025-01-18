import 'routine_check.dart';

class CalendarData {
  final DateTime date;
  final double completionRate;
  final int completedCount;
  final int totalCount;

  const CalendarData({
    required this.date,
    required this.completionRate,
    required this.completedCount,
    required this.totalCount,
  });

  factory CalendarData.fromDailyProgress(DailyProgress progress) {
    return CalendarData(
      date: progress.date,
      completionRate: progress.completionRate,
      completedCount: progress.completedCount,
      totalCount: progress.totalCount,
    );
  }
}

class MonthlyStatistics {
  final DateTime month;
  final double averageCompletionRate;
  final DateTime? bestPerformanceDate;
  final int currentStreak;

  const MonthlyStatistics({
    required this.month,
    required this.averageCompletionRate,
    this.bestPerformanceDate,
    required this.currentStreak,
  });
} 