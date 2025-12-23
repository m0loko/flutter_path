import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Color(0xFF00BD13),
      unselectedItemColor: Color(0xFF52525E),
    ),
  );
}
