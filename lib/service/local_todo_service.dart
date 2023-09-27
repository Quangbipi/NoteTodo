import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_todo/model/todo.dart';

class LocalTodoService{
  late Box<Todo> _todoBox;

  Future<void> init() async {
    await Hive.initFlutter(); // Thêm dòng này để khởi tạo Hive cho Flutter
    await Hive.openBox<Todo>('Todo').then((box) {
      _todoBox = box;
    });
  }
  Future<void> addTodos({required List<Todo> todos}) async{
    await _todoBox.clear();
    await _todoBox.addAll(todos);
  }

  List<Todo> getTodo() => _todoBox.values.toList();
}