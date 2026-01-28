import 'package:flutter/material.dart';
import 'package:to_do_cubit/add_todo_page.dart';
import 'package:to_do_cubit/cubit/to_do_cubit.dart';
import 'package:to_do_cubit/toDo_list.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const ToDoList(),
          '/add-todo': (_) => const AddTodoPage(),
        },
      ),
    );
  }
}
