// ex_notifier_model_1/lib/main.dart
import 'package:widgets/math_inherited.dart';
import 'package:widgets/math_model.dart';
import 'package:flutter/material.dart';

class InputValue extends StatelessWidget {
  final void Function(String value) onChanged;
  const InputValue({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: onChanged, // передача управления в функцию
    );
  }
}

class MyButton extends StatelessWidget {
  final void Function(MathModel mathModel) onPressed;
  final String text;

  const MyButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    // получаем модель без подписки на изменения
    final mathModel = MathInherited.modelOf(context);
    return ElevatedButton(
      // передача управления в функцию
      onPressed: () => onPressed(mathModel),
      child: Text(text),
    );
  }
}
