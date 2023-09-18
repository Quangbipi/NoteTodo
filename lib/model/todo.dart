import 'package:equatable/equatable.dart';

enum StatusTodo{
  finish,
  unfinished
}

List<Todo> todoList = [

];


class Todo extends Equatable{
  String id;
  StatusTodo statusTodo;
  String content;

  Todo({required this.id, this.statusTodo = StatusTodo.unfinished, required this.content});

  @override
  // TODO: implement props
  List<Object?> get props => [id, statusTodo, content];

  @override
  String toString() {
    return 'Todo{id: $id, statusTodo: $statusTodo, content: $content}';
  }
}