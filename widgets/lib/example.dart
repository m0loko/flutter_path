import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: SimpleCalcWidget()));
  }
}

class SimpleCalcWidget extends StatefulWidget {
  const SimpleCalcWidget({Key? key}) : super(key: key);

  @override
  State<SimpleCalcWidget> createState() => _SimpleCalcWidgetState();
}

class _SimpleCalcWidgetState extends State<SimpleCalcWidget> {
  final _model = SimpleCalcWidgetModel();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SimpleCalcWidgetProvider(
          model: _model,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FirstNumberWidget(),
              const SizedBox(height: 10),
              const SecondNumberWidget(),
              const SizedBox(height: 10),
              const SummButtonWidget(),
              const SizedBox(height: 10),
              ResultWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstNumberWidget extends StatelessWidget {
  const FirstNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          SimpleCalcWidgetProvider.read(context)?.firstNumber = value,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class SecondNumberWidget extends StatelessWidget {
  const SecondNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) =>
          SimpleCalcWidgetProvider.read(context)?.secondNumber = value,
      decoration: InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class SummButtonWidget extends StatelessWidget {
  const SummButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => SimpleCalcWidgetProvider.read(context)?.sum(),
      child: const Text('Посчитать сумму'),
    );
  }
}

/* class ResultWidget extends StatefulWidget {
  ResultWidget({Key? key}) : super(key: key);

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  String _value = '-1';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = SimpleCalcWidgetProvider.of(context)?.model;
    model?.addListener(() {
      _value = '${model?.summResult}';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = SimpleCalcWidgetProvider.of(context)?.model.summResult ?? 0;
    return Text('Результат: $_value');
  }
}
 */
class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = SimpleCalcWidgetProvider.watch(context)?.summResult ?? -1;
    return Text('Результат: $value');
  }
}

class SimpleCalcWidgetModel extends ChangeNotifier {
  int? _firstNumber;
  int? _secondNumber;
  int? summResult;

  set firstNumber(String value) => _firstNumber = int.tryParse(value);
  set secondNumber(String value) => _secondNumber = int.tryParse(value);

  void sum() {
    int? summResult;
    if (_firstNumber != null && _secondNumber != null) {
      summResult = _firstNumber! + _secondNumber!;
    } else {
      summResult = null;
    }
    notifyListeners();
    if (this.summResult != summResult) {
      this.summResult = summResult;
    }
  }
}

class SimpleCalcWidgetProvider
    extends InheritedNotifier<SimpleCalcWidgetModel> {
  final SimpleCalcWidgetModel model;
  const SimpleCalcWidgetProvider({
    super.key,
    required Widget child,

    required this.model,
  }) : super(child: child, notifier: model);

  static SimpleCalcWidgetModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SimpleCalcWidgetProvider>()
        ?.model;
  }

  static SimpleCalcWidgetModel? read(BuildContext context) {
    final widget = context.getElementForInheritedWidgetOfExactType()?.widget;
    return widget is SimpleCalcWidgetProvider ? widget.notifier : null;
  }
}
