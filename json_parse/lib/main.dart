import 'dart:convert';

import 'package:json_dart/adress.dart';
import 'package:json_dart/human.dart';

final List<Human> humans = [
  Human(
    name: 'Иван',
    surname: 'Иванов',
    age: 17,
    addresses: [
      Address(city: 'Москва', street: 'Баумана', house: '12а', flat: 12),
      Address(city: 'Новосибирск', street: 'Батурина', house: '1', flat: 1),
      Address(city: 'Питер', street: 'Моховая', house: '198г', flat: 561),
    ],
  ),
  Human(
    name: 'Петр',
    surname: 'Петров',
    age: 17,
    addresses: [
      Address(city: 'Москва', street: 'Мира', house: '54', flat: 67),
      Address(city: 'Казань', street: 'Ленина', house: '23', flat: 56),
      Address(city: 'Пенза', street: 'Карла Маркса', house: '136', flat: 12),
    ],
  ),
];
void main() {
  // JSON данные (исправленная версия)
  final jsonString = '''
  [
    {
      "name": "Иван",
      "surname": "Иванов",
      "age": 17,
      "address": [
        {"city": "Москва", "street": "Баумана", "house": "12a", "flat": 12},
        {"city": "Новосибирск", "street": "Батурина", "house": "1", "flat": 1},
        {"city": "Питер", "street": "Моховая", "house": "198r", "flat": 561}
      ]
    },
    {
      "name": "НеИван",
      "surname": "НеИванов",
      "age": 71,
      "address": [
        {"city": "НеМосква", "street": "Баумана", "house": "12a", "flat": 12},
        {"city": "НеНовосибирск", "street": "Батурина", "house": "1", "flat": 1},
        {"city": "НеПитер", "street": "Моховая", "house": "198r", "flat": 561}
      ]
    }
  ]
  ''';
  /* 
  try {
    final json = jsonDecode(jsonString) as List<dynamic>;

    final humans = json
        .map((e) => Human.fromJson(e as Map<String, dynamic>))
        .toList();
    print(humans);
  } catch (error) {
    print(error);
  } */
  final objects = humans.map((e) => e.toJson()).toList();
  final jsonStringTwo = jsonEncode(objects);
  print(jsonStringTwo);
}
