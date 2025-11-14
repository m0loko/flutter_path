import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

part 'example_widget_model.g.dart';

class ExampleWidgetModel {
  Future<Box<User>>? userBox;
  void setup() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    userBox = Hive.openBox<User>('user_box');
    userBox?.then((box) {
      box.listenable().addListener(() {
        print('box ${box.length}');
      });
    });
  }

  void doSome() async {
    final box = await userBox;
    final user = User('ivan', 15);
    await box?.add(user);
  }
}

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  User(this.name, this.age);

  @override
  String toString() => '$name: $age ';
}

@HiveType(typeId: 1)
class Pet extends HiveObject {
  @HiveField(0)
  String name;

  Pet(this.name);

  @override
  String toString() => 'имя: $name';
}
// Лишняя } удалена