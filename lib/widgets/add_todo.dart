import 'package:animations_prep/providers/todo.dart';
import 'package:flutter/material.dart';

import 'package:animations_prep/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final TextEditingController _todoController = TextEditingController();
  String? error;
  DateTime? selectedDate;

  void datePicker() async {
    final now = DateTime.now();
    final nextYear = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: now, lastDate: nextYear);

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void addTodo() async {
    final enteredValue = _todoController.text;
    if (enteredValue.isEmpty ||
        enteredValue.trim().length < 0 ||
        selectedDate == null) {
      setState(() {
        error = 'Task and date cannot be empty';
      });
      return;
    }

    final isUnique = await ref
        .read(toDoProvider.notifier)
        .isUniqueTodo(enteredValue, selectedDate!);

    if (isUnique) {
      ref.read(toDoProvider.notifier).addTodo(enteredValue, selectedDate);
      Navigator.pop(context);
      return;
    }

    setState(() {
      error = 'This task already exists with the selected date';
    });
  }

  @override
  void dispose() {
    _todoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _todoController,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Todo',
              suffixIcon: const Icon(Icons.work_outline),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Text(
                error!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    selectedDate == null
                        ? 'Select Deadline.'
                        : formatter.format(selectedDate!),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  IconButton(
                    onPressed: datePicker,
                    icon: const Icon(
                      Icons.date_range_outlined,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                    onPressed: addTodo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text(
                      'save',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
