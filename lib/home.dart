import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/bloc/todo_bloc.dart';
import 'package:note_todo/bloc/todo_event.dart';
import 'package:note_todo/bloc/todo_state.dart';
import 'package:note_todo/component/todo_item.dart';
import 'package:note_todo/model/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Todo>? todos;

  TextEditingController _todoController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width*0.7,

                  height: 50,
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: 'Công việc của bạn',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      contentPadding: EdgeInsets.only(left: 15)
                    ),

                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                        minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))
                      ),
                      onPressed: (){
                          if(_todoController.text.isNotEmpty){
                            Todo todo = Todo(id: '${ Random().nextInt(500)}', content: _todoController.text);
                            context.read<TodoBloc>().add(AddTodoEvent(todo));
                          }else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text('Thông báo', style: TextStyle(color: Colors.red),),
                                    content: Text('Bạn chưa nhập công việc'),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text('Đóng'))
                                    ],
                                  );
                                });
                          }
                      },
                      child: Text('Thêm', style: TextStyle(color: Colors.white),),
                    ))
              ],

            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state){
                if( state is GetTodoSuccess ){
                  return ListView.builder(
                    itemCount: state.todos.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TodoItem(todo: state.todos[index], index: index,),
                        );
                      });
                }
                return Center(child: Text('Không có dữ liệu'),);
              },
            )
            
          )
             
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
