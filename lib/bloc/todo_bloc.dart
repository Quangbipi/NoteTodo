import 'dart:async';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/bloc/todo_event.dart';
import 'package:note_todo/bloc/todo_state.dart';
import 'package:note_todo/model/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{
  TodoBloc(): super(TodoInitial(todoList)){
    on<AddTodoEvent>(_handlerAddTodoEvent);
    on<DeleteTodoEvent>(_handlerDeleteEvent);
    on<ChangeStatusEvent>(_handlerChangeStatusEvent);
  }


  FutureOr<void> _handlerAddTodoEvent(AddTodoEvent event, Emitter<TodoState> emit) {
   try{
     todoList.add(event.todo);
     print(todoList.toString());
     emit(AddTodoSuccess(todoList));
     emit(GetTodoSuccess(todoList));
   }catch(e){
     emit(AddTodoFailed(e.toString()));
   }
  }

  FutureOr<void> _handlerDeleteEvent(DeleteTodoEvent event, Emitter<TodoState> emit) {
    todoList.removeAt(event.index);
    emit(DeleteSuccess(todoList));
    emit(GetTodoSuccess(todoList));
  }


  FutureOr<void> _handlerChangeStatusEvent(ChangeStatusEvent event, Emitter<TodoState> emit) {
    todoList[event.index].statusTodo=event.statusTodo;
    emit(ChangeStatusSuccess());
    emit(GetTodoSuccess(todoList));
  }
}