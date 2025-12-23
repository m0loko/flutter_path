import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/auth/auth_gate.dart';
import 'package:supabase_test/pages/login_page.dart';

void main() async {
  //supabase setup
  await Supabase.initialize(
    anonKey: 'sb_publishable_2dxCNvVDwoY8YWGvyPpGcQ_-nPG49XU',
    url: 'https://lmtolxhtogjhydlpaqgf.supabase.co',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: AuthGate(),
    );
  }
}
