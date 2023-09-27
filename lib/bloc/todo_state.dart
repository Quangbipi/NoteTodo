import 'package:equatable/equatable.dart';
import 'package:note_todo/model/todo.dart';

enum SortBy{
  all,
  finish,
  unfinished;
}

class TodoState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class TodoInitial extends TodoState{
  List<Todo> todos;

  TodoInitial(this.todos);
  @override
  // TODO: implement props
  List<Object?> get props => [todos];
}

class AddTodoSuccess extends TodoState{
  List<Todo> todos;

  AddTodoSuccess(this.todos);
  @override
  // TODO: implement props
  List<Object?> get props => [todos];
}

class AddTodoFailed extends TodoState{
  String e;

  AddTodoFailed(this.e);
  @override
  // TODO: implement props
  List<Object?> get props => [e];
}

class GetTodoSuccess extends TodoState{
  List<Todo> todos;
  GetTodoSuccess(this.todos);
  @override
  // TODO: implement props
  List<Object?> get props => [todos];

}

class ChangeStatusSuccess extends TodoState{

}

class DeleteSuccess extends TodoState{
  List<Todo> todos;

  DeleteSuccess(this.todos);
  @override
  // TODO: implement props
  List<Object?> get props => [todos];
}

class SortTodoSuccess extends TodoState{

  List<Todo> todos;

  SortTodoSuccess(this.todos);
  @override
  // TODO: implement props
  List<Object?> get props => [todos];
}

class SortTodoFailed extends TodoState{

  String e;

  SortTodoFailed(this.e);
  @override
  // TODO: implement props
  List<Object?> get props => [e];
}