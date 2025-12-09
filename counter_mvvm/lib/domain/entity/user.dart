class User {
  final int age;

  User({required this.age});

  User copyWith({int? age}) {
    return User(age: age ?? this.age);
  }
}
