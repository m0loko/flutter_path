import 'package:to_do_cubit/models/todo_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoCubit extends Cubit<List<Todo>> {
  ToDoCubit() : super([]);
  void addTodo(String title) {
    final todo = Todo(name: title, createdAt: DateTime.now());
    emit([...state, todo]);
  }

  @override
  void onChange(Change<List<Todo>> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
