import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_providers.dart';
import '../widgets/month_navigator.dart';
import '../widgets/calendar_heatmap.dart';
import '../widgets/monthly_statistics_widget.dart';
import '../widgets/month_picker_dialog.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final statisticsAsync = ref.watch(monthlyStatisticsProvider(selectedMonth));

    return Scaffold(
      appBar: AppBar(
        title: const Text('활동 캘린더'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showMonthPicker(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: MonthNavigator(),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarHeatmap(),
            ),
            const SizedBox(height: 16),
            statisticsAsync.when(
              data: (statistics) => MonthlyStatisticsWidget(statistics: statistics),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('통계를 불러오는 중 오류가 발생했습니다: $error'),
                    ElevatedButton(
                      onPressed: () => ref.refresh(monthlyStatisticsProvider(selectedMonth)),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context, WidgetRef ref) async {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final newDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthPickerDialog(initialDate: selectedMonth),
    );

    if (newDate != null) {
      ref.read(selectedMonthProvider.notifier).state = newDate;
    }
  }
} 