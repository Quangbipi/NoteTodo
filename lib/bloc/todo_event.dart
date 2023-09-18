import 'package:equatable/equatable.dart';
import 'package:note_todo/model/todo.dart';

class TodoEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class AddTodoEvent extends TodoEvent{
  Todo todo;

  AddTodoEvent(this.todo);
  @override
  // TODO: implement props
  List<Object?> get props => [todo];
}

class ChangeStatusEvent extends TodoEvent{
  int index;
  StatusTodo statusTodo;
  ChangeStatusEvent(this.statusTodo, this.index);
  @override
  // TODO: implement props
  List<Object?> get props => [statusTodo];
}

class DeleteTodoEvent extends TodoEvent{
  int index;

  DeleteTodoEvent(this.index);
  @override
  // TODO: implement props
  List<Object?> get props => [index];
}

