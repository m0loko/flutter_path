import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[100],
      child: Center(
        child: Column(
          mainAxisSize: .max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Text('Я первая страница'),
            ),
            SizedBox(height: 150),
            Lottie.asset('assets/animations/delivery_man.json'),
          ],
        ),
      ),
    );
  }
}
