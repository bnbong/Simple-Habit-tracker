import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const MonthPickerDialog({
    super.key,
    required this.initialDate,
  });

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late DateTime _selectedDate;
  final _yearFormat = DateFormat('yyyy년');
  final _monthFormat = DateFormat('M월');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year - 1,
                        _selectedDate.month,
                      );
                    });
                  },
                ),
                Text(
                  _yearFormat.format(_selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year + 1,
                        _selectedDate.month,
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final month = index + 1;
                final date = DateTime(_selectedDate.year, month);
                final isSelected = date.year == _selectedDate.year && 
                                 date.month == _selectedDate.month;

                return InkWell(
                  onTap: () => Navigator.of(context).pop(date),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _monthFormat.format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
          ],
        ),
      ),
    );
  }
} 