import 'package:animations_prep/widgets/edit_todo.dart';
import 'package:animations_prep/widgets/todo_item.dart';
import 'package:flutter/material.dart';

import 'package:animations_prep/models/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todosList,
    required this.onPressModel,
  });

  final List<Todo> todosList;
  final void Function(Widget widget) onPressModel;

  @override
  Widget build(BuildContext context) {
    if (todosList.isEmpty) {
      return Center(
        child: Text(
          'Todo List is empty.',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: todosList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(6),
          child: TodoItem(
            item: todosList[index],
            showModel: () {
              onPressModel(
                EditTodo(todo: todosList[index]),
              );
            },
          ),
        );
      },
    );
  }
}
