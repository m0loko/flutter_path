// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rick_and_morty/core/errors/exeption.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rick_and_morty/data/models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;
  PersonLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<List<PersonModel>> getLastPersonsFromCache() async {
    final jsonPersonsList = sharedPreferences.getStringList(
      CACHED_PERSONS_LIST,
    );

    if (jsonPersonsList != null && jsonPersonsList.isNotEmpty) {
      return jsonPersonsList
          .map((person) => PersonModel.fromJson(json.decode(person)))
          .toList();
    } else {
      throw CacheExteption();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList = persons
        .map((person) => jsonEncode(person.toJson()))
        .toList();
    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    print('Persons to write Cache: ${jsonPersonsList.length}');
    return Future.value(jsonPersonsList);
  }
}
