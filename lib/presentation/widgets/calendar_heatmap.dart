import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/calendar_data.dart';
import '../providers/calendar_providers.dart';
import 'daily_details_sheet.dart';

class CalendarHeatmap extends ConsumerWidget {
  const CalendarHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final calendarDataAsync = ref.watch(monthlyCalendarDataProvider(selectedMonth));

    return calendarDataAsync.when(
      data: (calendarData) => _buildHeatmap(context, calendarData, ref),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('데이터를 불러오는 중 오류가 발생했습니다: $error'),
            ElevatedButton(
              onPressed: () => ref.refresh(monthlyCalendarDataProvider(selectedMonth)),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap(BuildContext context, List<CalendarData> data, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final firstWeekday = DateTime(selectedMonth.year, selectedMonth.month, 1).weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6주 x 7일
      itemBuilder: (context, index) {
        // 달력의 빈 칸 처리
        if (index < firstWeekday - 1 || index >= firstWeekday - 1 + daysInMonth) {
          return const SizedBox();
        }

        final dayOfMonth = index - firstWeekday + 2;
        final date = DateTime(selectedMonth.year, selectedMonth.month, dayOfMonth);
        final calendarData = data.firstWhere(
          (d) => d.date.year == date.year && d.date.month == date.month && d.date.day == date.day,
          orElse: () => CalendarData(
            date: date,
            completionRate: 0,
            completedCount: 0,
            totalCount: 0,
          ),
        );

        return GestureDetector(
          onTap: () => _showDayDetails(context, ref, calendarData),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _getColorForCompletionRate(calendarData.completionRate),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                dayOfMonth.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getColorForCompletionRate(double rate) {
    if (rate == 0) return Colors.grey.shade200;
    if (rate < 0.3) return Colors.blue.shade100;
    if (rate < 0.7) return Colors.blue.shade300;
    return Colors.blue.shade500;
  }

  void _showDayDetails(BuildContext context, WidgetRef ref, CalendarData data) {
    ref.read(selectedDateProvider.notifier).state = data.date;
    showModalBottomSheet(
      context: context,
      builder: (context) => DailyDetailsSheet(date: data.date),
    );
  }
} 