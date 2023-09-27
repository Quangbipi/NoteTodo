import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'todo.g.dart';
enum StatusTodo{
  finish,
  unfinished
}

class StatusTodoAdapter extends TypeAdapter<StatusTodo> {
  @override
  final int typeId = 1; // Đặt một typeId duy nhất cho enum của bạn

  @override
  StatusTodo read(BinaryReader reader) {
    return StatusTodo.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, StatusTodo obj) {
    writer.writeInt(obj.index);
  }
}

List<Todo> todoList = [

];

@HiveType(typeId: 0)
class Todo extends Equatable{
  @HiveField(0)
  final String id;
  @HiveField(1)
  StatusTodo statusTodo;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final DateTime time;
  Todo({required this.id, this.statusTodo = StatusTodo.unfinished, required this.content, required this.time});

  @override
  // TODO: implement props
  List<Object?> get props => [id, statusTodo, content];

  @override
  String toString() {
    return 'Todo{id: $id, statusTodo: $statusTodo, content: $content, time: $time}';
  }
}