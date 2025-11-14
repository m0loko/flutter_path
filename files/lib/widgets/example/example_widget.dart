import 'package:files/widgets/example/example_widget_model.dart';
import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  ExampleWidget({Key? key}) : super(key: key);

  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final _model = ExampleWidgetModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _model.doSome,
                child: const Text('Добавить'),
              ),
              ElevatedButton(
                onPressed: _model.setup,
                child: const Text('Настроить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
