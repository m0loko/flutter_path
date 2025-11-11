import 'package:flutter/material.dart';
import 'package:themoviedb/widgets/app/my_app.dart';
import 'package:themoviedb/widgets/app/my_app_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.checkAuth();
  final app = MyApp(model: model);
  runApp(app);
}
