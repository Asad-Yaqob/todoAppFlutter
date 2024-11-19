import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:animations_prep/models/todo.dart';
import 'package:animations_prep/providers/todo.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({
    super.key,
    required this.item,
    required this.showModel,
  });

  final Todo item;
  final void Function() showModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotiFier = ref.read(toDoProvider.notifier);

    return ListTile(
      title: Text(
        item.todo,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        'Deadline: ${formatter.format(item.date!)}',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: showModel,
            icon: const Icon(Icons.edit_note),
          ),
          IconButton(
            onPressed: () {
              todoNotiFier.removeTodo(item);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
