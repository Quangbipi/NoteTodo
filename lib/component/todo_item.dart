import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/bloc/todo_bloc.dart';
import 'package:note_todo/bloc/todo_event.dart';
import 'package:note_todo/model/todo.dart';

class TodoItem extends StatefulWidget {
  Todo todo;
  int index;
   TodoItem({Key? key, required this.todo, required this.index}) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool value = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Dismissible(
          key: Key((widget.todo.id).toString()),
          background: Container(
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever_outlined, size: 40, color: Colors.white,),
                Text("Delete", style: TextStyle(color: Colors.white),)
              ],
            ),// Màu nền hiển thị khi vuốt đi
          ),
          onDismissed: (DismissDirection direction){
           context.read<TodoBloc>().add(DeleteTodoEvent(widget.index));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Checkbox(
                        value: widget.todo.statusTodo == StatusTodo.unfinished ? false : true,
                        onChanged: (bool? value){
                          context.read<TodoBloc>().add(ChangeStatusEvent(value! == true? StatusTodo.finish : StatusTodo.unfinished, widget.index));
                        }),
                    Text(widget.todo.content,)

                  ],
                ),
              ),
            ),
          ) ),
    );

  }
}
