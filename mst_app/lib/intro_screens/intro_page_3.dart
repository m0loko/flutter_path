import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100],
      child: Center(
        child: Column(
          mainAxisSize: .max,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Text('Я третья страница'),
            ),
            SizedBox(height: 150),
            Lottie.asset('assets/animations/delivery_man.json'),
          ],
        ),
      ),
    );
  }
}
