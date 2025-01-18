import '../../domain/models/calendar_data.dart';
import '../../domain/models/routine_check.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/routine_check_local_datasource.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final RoutineCheckLocalDataSource _routineCheckDataSource;

  CalendarRepositoryImpl(this._routineCheckDataSource);

  @override
  Future<List<CalendarData>> getMonthlyCalendarData(DateTime month) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);
    
    final List<CalendarData> calendarData = [];
    for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      final dailyData = await getDailyCalendarData(date);
      calendarData.add(dailyData);
    }
    
    return calendarData;
  }

  @override
  Future<CalendarData> getDailyCalendarData(DateTime date) async {
    final checks = await _routineCheckDataSource.getDailyChecks(date);
    final completedCount = checks.where((check) => check['is_completed'] == 1).length;
    
    return CalendarData(
      date: date,
      completionRate: checks.isEmpty ? 0 : completedCount / checks.length,
      completedCount: completedCount,
      totalCount: checks.length,
    );
  }

  @override
  Future<MonthlyStatistics> getMonthlyStatistics(DateTime month) async {
    final calendarData = await getMonthlyCalendarData(month);
    
    if (calendarData.isEmpty) {
      return MonthlyStatistics(
        month: month,
        averageCompletionRate: 0,
        currentStreak: 0,
      );
    }

    final averageRate = calendarData.map((d) => d.completionRate).reduce((a, b) => a + b) / calendarData.length;
    final bestDay = calendarData.reduce((a, b) => a.completionRate > b.completionRate ? a : b).date;
    
    // 현재 연속 달성일 계산
    int streak = 0;
    final today = DateTime.now();
    for (var i = calendarData.length - 1; i >= 0; i--) {
      final data = calendarData[i];
      if (data.date.isAfter(today) || data.completionRate < 1.0) break;
      streak++;
    }

    return MonthlyStatistics(
      month: month,
      averageCompletionRate: averageRate,
      bestPerformanceDate: bestDay,
      currentStreak: streak,
    );
  }

  @override
  Future<List<RoutineCheck>> getDailyRoutineChecks(DateTime date) async {
    final checksData = await _routineCheckDataSource.getDailyChecks(date);
    return checksData.map((data) => RoutineCheck.fromMap(data)).toList();
  }
} 