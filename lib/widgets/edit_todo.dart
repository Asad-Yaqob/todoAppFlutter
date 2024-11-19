import 'package:animations_prep/providers/todo.dart';
import 'package:flutter/material.dart';

import 'package:animations_prep/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditTodo extends ConsumerStatefulWidget {
  const EditTodo({super.key, required this.todo});

  final Todo todo;

  @override
  ConsumerState<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends ConsumerState<EditTodo> {
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
  
  void _editTodo(){
    final enteredValue = _todoController.text; 
    if( enteredValue.isEmpty || enteredValue.trim().length < 0 || selectedDate == null ){
      setState(() {
        error = 'Task and date cannot be empty';
      });
      return;
    }

    ref.read(toDoProvider.notifier).updateTodo(enteredValue, selectedDate, widget.todo.id);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _todoController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _todoController.text = widget.todo.todo;
    selectedDate = widget.todo.date;
  
    super.initState();
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
              labelText: 'task...',
              prefixIcon: const Icon(Icons.work_outline),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
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
                        : Todo.formatedDate(selectedDate!),
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
                  TextButton(
                    onPressed: _editTodo,
                    child: const Text('save'),
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
