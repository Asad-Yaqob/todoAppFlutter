import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

class Todo {
  Todo({
    required this.todo,
    required this.date,
    this.isCompleted = false,
    String? id
  }) : id = id ?? uuid.v4();

  final String id;
  final String todo;
  final DateTime? date;
  final bool isCompleted;

   static String formatedDate(DateTime date) {
    return formatter.format(date);
  }

  Todo copyWith({
   String? id,
   String? todo,
   DateTime? date,
   bool? isCompleted, 
  }){
    return Todo(todo: todo ?? this.todo, date: date ?? this.date, isCompleted: isCompleted ?? this.isCompleted,);
  }

}

