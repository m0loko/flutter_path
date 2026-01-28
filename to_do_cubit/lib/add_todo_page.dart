import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_cubit/cubit/to_do_cubit.dart';
import 'package:to_do_cubit/models/todo_models.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add new task')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Text'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ToDoCubit>().addTodo(textEditingController.text);
                Navigator.of(context).pop();
              },
              child: const Text('add'),
            ),
          ],
        ),
      ),
    );
  }
}
