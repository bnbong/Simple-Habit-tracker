import '../models/calendar_data.dart';
import '../models/routine_check.dart';

abstract class CalendarRepository {
  Future<List<CalendarData>> getMonthlyCalendarData(DateTime month);
  Future<CalendarData> getDailyCalendarData(DateTime date);
  Future<MonthlyStatistics> getMonthlyStatistics(DateTime month);
  Future<List<RoutineCheck>> getDailyRoutineChecks(DateTime date);
} 