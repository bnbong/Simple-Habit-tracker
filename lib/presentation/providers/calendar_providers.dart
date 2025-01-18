import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/calendar_data.dart';
import '../../domain/models/routine_check.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../providers/database_providers.dart';

final calendarRepositoryProvider = Provider<CalendarRepositoryImpl>((ref) {
  final dataSource = ref.watch(routineCheckLocalDataSourceProvider);
  return CalendarRepositoryImpl(dataSource);
});

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final monthlyCalendarDataProvider = FutureProvider.family<List<CalendarData>, DateTime>((ref, month) async {
  final repository = ref.watch(calendarRepositoryProvider);
  return await repository.getMonthlyCalendarData(month);
});

final monthlyStatisticsProvider = FutureProvider.family<MonthlyStatistics, DateTime>((ref, month) async {
  final repository = ref.watch(calendarRepositoryProvider);
  return await repository.getMonthlyStatistics(month);
});

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

final dailyRoutineChecksProvider = FutureProvider.family<List<RoutineCheck>, DateTime>((ref, date) async {
  final repository = ref.watch(calendarRepositoryProvider);
  return await repository.getDailyRoutineChecks(date);
}); 