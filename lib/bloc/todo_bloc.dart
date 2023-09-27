import 'dart:async';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/bloc/todo_event.dart';
import 'package:note_todo/bloc/todo_state.dart';
import 'package:note_todo/model/todo.dart';
import 'package:note_todo/service/local_todo_service.dart';
import 'package:note_todo/service/notification_service.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{

  LocalTodoService _localTodoService = LocalTodoService();
  TodoBloc(): super(TodoInitial(todoList)){
    on<AddTodoEvent>(_handlerAddTodoEvent);
    on<DeleteTodoEvent>(_handlerDeleteEvent);
    on<ChangeStatusEvent>(_handlerChangeStatusEvent);
    on<SortTodoEvent>(_handlerSortTodoEvent);
    on<GetTodoEvent>(_handlerGetTodoEvent);
  }


  FutureOr<void> _handlerAddTodoEvent(AddTodoEvent event, Emitter<TodoState> emit)async {
   try{
     todoList.add(event.todo);
     print(todoList.toString());
     _localTodoService.addTodos(todos: todoList);
     emit(AddTodoSuccess(todoList));
     emit(GetTodoSuccess(todoList));
     var res = await NotificationService().scheduleMultipleNotifications(todoList);
     print("---------------------RES: ${res.toString()}-------------------------------------");

   }catch(e){
     emit(AddTodoFailed(e.toString()));
   }
  }

  FutureOr<void> _handlerDeleteEvent(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    if (todoList != null && todoList.isNotEmpty && event.index >= 0 && event.index < todoList.length) {
      var removedItem = todoList[event.index];
      await NotificationService().cancelNotification(int.parse(removedItem.id));
      todoList.removeAt(event.index);
      _localTodoService.addTodos(todos: todoList);
      emit(DeleteSuccess(todoList));
      emit(GetTodoSuccess(todoList));
    } else {
      print('Lỗi');
    }


  }


  FutureOr<void> _handlerChangeStatusEvent(ChangeStatusEvent event, Emitter<TodoState> emit) {
    todoList[event.index].statusTodo=event.statusTodo;
    emit(ChangeStatusSuccess());
    emit(GetTodoSuccess(todoList));
  }

  FutureOr<void> _handlerSortTodoEvent(SortTodoEvent event, Emitter<TodoState> emit) {
    if(event.index == 0){
      emit(SortTodoSuccess(todoList));

      emit(GetTodoSuccess(todoList));
    }
    if(event.index == 1){
      var todos = todoList.where((todo) => todo.statusTodo == StatusTodo.finish).toList();
      emit(SortTodoSuccess(todos));
      print('đã hoàn thành');
      _localTodoService.addTodos(todos: todoList);
      emit(GetTodoSuccess(todos));
    }
    if(event.index == 2){
      var todos = todoList.where((todo) => todo.statusTodo == StatusTodo.unfinished).toList();
      print('Chưa hoàn thành: ${todoList.toString()}');
      emit(SortTodoSuccess(todos));
      _localTodoService.addTodos(todos: todoList);
      emit(GetTodoSuccess(todos));
    }

  }

  FutureOr<void> _handlerGetTodoEvent(GetTodoEvent event, Emitter<TodoState> emit) async{
    await _localTodoService.init();
    if(todoList.isEmpty){
      todoList = _localTodoService.getTodo();
    }
    emit(GetTodoSuccess(todoList));
  }
}