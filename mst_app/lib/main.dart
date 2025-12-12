// Файл: lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Не забудьте импорт!

// Импорты ваших экранов (проверьте пути)
import 'onboarding_screen.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isPremium = prefs.getBool('is_premium') ?? false;

  runApp(MyApp(startOnHome: isPremium));
}

class MyApp extends StatelessWidget {
  final bool startOnHome;

  const MyApp({super.key, required this.startOnHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MST App',
      home: startOnHome ? const HomePage() : const OnboardingScreen(),
    );
  }
}
