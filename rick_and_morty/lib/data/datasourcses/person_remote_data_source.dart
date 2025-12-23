import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_and_morty/core/errors/exeption.dart';
import 'package:rick_and_morty/data/models/person_model.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons(int page);
  Future<List<PersonModel>> searchPerson(String query);
}

class PessonRemoteDataSourseImpl implements PersonRemoteDataSource {
  var client = http.Client();
  PessonRemoteDataSourseImpl({required this.client});
  @override
  Future<List<PersonModel>> getAllPersons(int page) => _getPersonFromUrl(
    'https://rickandmortyapi.com/api/character/?page=$page',
  );

  @override
  Future<List<PersonModel>> searchPerson(String query) => _getPersonFromUrl(
    'https://rickandmortyapi.com/api/character/?name=$query',
  );

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> persons = json.decode(response.body);
      final List results = persons['results'];
      return results.map((person) => PersonModel.fromJson(person)).toList();
    } else {
      throw ServerExteption();
    }
  }
}
