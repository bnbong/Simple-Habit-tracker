import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/routine_providers.dart';

class AddRoutineDialog extends ConsumerStatefulWidget {
  const AddRoutineDialog({super.key});

  @override
  ConsumerState<AddRoutineDialog> createState() => _AddRoutineDialogState();
}

class _AddRoutineDialogState extends ConsumerState<AddRoutineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새 루틴 추가'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '루틴 이름',
                hintText: '예: 아침 운동',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '루틴 이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '설명 (선택사항)',
                hintText: '예: 30분 조깅하기',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final navigator = Navigator.of(context);
              await ref.read(routinesProvider.notifier).createRoutine(
                    _nameController.text,
                    _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                  );
              if (mounted) {
                navigator.pop();
              }
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
} 