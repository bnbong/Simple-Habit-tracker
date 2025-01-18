import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_providers.dart';
import 'package:intl/intl.dart';

class MonthNavigator extends ConsumerWidget {
  const MonthNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final monthFormat = DateFormat('yyyy년 M월');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            final newMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
            ref.read(selectedMonthProvider.notifier).state = newMonth;
          },
        ),
        Text(
          monthFormat.format(selectedMonth),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            final newMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
            ref.read(selectedMonthProvider.notifier).state = newMonth;
          },
        ),
      ],
    );
  }
} 