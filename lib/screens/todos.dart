import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:animations_prep/providers/todo.dart';
import 'package:animations_prep/widgets/todo_list.dart';
import 'package:animations_prep/widgets/add_todo.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TodosScreenState();
  }
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  late Future<void> _todosFuture;

  @override
  void initState() {
    super.initState();

    _todosFuture = ref.read(toDoProvider.notifier).fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    final todosData = ref.watch(toDoProvider);

    void openModelOverlay(Widget? widget) {
      showModalBottomSheet(
        // isScrollControlled: true,  To make model to take full height.
        context: context,
        builder: (context) => widget!,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Todos',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        openModelOverlay(
                          const AddTodo(),
                        );
                      },
                      label: const Text(
                        'add ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: FutureBuilder(
                    future: _todosFuture,
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator())
                            : TodoList(
                                todosList: todosData,
                                onPressModel: openModelOverlay,
                              ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
