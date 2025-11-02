import 'package:json_annotation/json_annotation.dart';
import 'package:json_dart/adress.dart';

part 'human.g.dart';

@JsonSerializable()
class Human {
  String name;
  String surname;
  int age;
  List<Address> addresses;

  Human({
    required this.name,
    required this.surname,
    required this.age,
    required this.addresses,
  });

  factory Human.fromJson(Map<String, dynamic> json) => _$HumanFromJson(json);
  Map<String, dynamic> toJson() => _$HumanToJson(this);
}
