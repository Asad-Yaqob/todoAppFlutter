import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

import 'package:animations_prep/models/todo.dart';

Future<Database> getDb() async {
  final dbPath = await sql.getDatabasesPath();

  final db = await sql.openDatabase(
    path.join(dbPath, 'todos.db'),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE todos (id TEXT PRIMARY KEY, todo TEXT, deadline TEXT)');
    },
    version: 1,
  );

  return db;
}

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  Future<void> fetchTodos() async {
    final db = await getDb();
    final data = await db.query('todos');
    final places = data
        .map(
          (row) => Todo(
            id: row['id'] as String,
            todo: row['todo'] as String,
            date: DateTime.parse(row['deadline'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addTodo(String value, DateTime? date) async {
    final data = Todo(todo: value, date: date);

    final db = await getDb();

    await db.insert(
      'todos',
      {'id': data.id, 'todo': data.todo, 'deadline': data.date.toString()},
    );

    state = [...state, data];
  }

  void updateTodo(String value, DateTime? date, String id) async {
    final itemIndex = state.indexWhere((i) => i.id == id);

    if (itemIndex == -1) {
      return;
    }

    final updatedTodo = Todo(
      todo: value,
      date: date,
      id: id,
    );

    final db = await getDb();

    await db.update(
        'todos',
        {
          ' id': id,
          'todo': updatedTodo.todo,
          'deadline': updatedTodo.date.toString(),
        },
        where: 'id = ?',
        whereArgs: [id]);

    final updatedList = [
      for (int i = 0; i < state.length; i++)
        if (i == itemIndex) updatedTodo else state[i]
    ];

    state = updatedList;
  }

  void removeTodo(Todo todoItem) async {
    final db = await getDb();
    await db.delete('todos', where: 'id = ?', whereArgs: [todoItem.id]);
    state = state.where((i) => i != todoItem).toList();
  }

  Future<bool> isUniqueTodo(String value, DateTime date) async {
    final db = await getDb();
    final data = await db.query('todos',
        where: 'todo = ? OR deadline = ?', whereArgs: [value, date.toString()]);
        
    final result = data.map(
      (row) => Todo(
        id: row['id'] as String,
        todo: row['todo'] as String,
        date: DateTime.parse(row['deadline'] as String),
      ),
    ).toList();

    if (result.isEmpty) {
      return true;
    }

    return false;
  }

  // void toggleComplete(String todoId){
  //   state = [
  //     for (final todo in state)
  //     if (todo.id == todoId)
  //     todo.copyWith(isCompleted: !todo.isCompleted)
  //     else
  //     todo
  //   ];

  // }
}

final toDoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
