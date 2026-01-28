import 'package:flutter/material.dart';
import 'package:login_bloc/bloc/auth_bloc.dart';
import 'package:login_bloc/login_screen.dart';
import 'package:login_bloc/pallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
      ),
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: const LoginScreen(),
      ),
    );
  }
}
