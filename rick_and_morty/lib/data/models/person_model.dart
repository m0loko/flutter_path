import 'dart:convert';

import 'package:rick_and_morty/data/models/location_model.dart';
import 'package:rick_and_morty/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.origin,
    required super.location,
    required super.image,
    required super.episode,
    required super.created,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: json['origin'] != null
          ? LocationModel.fromJson(json['origin'])
          : LocationModel(name: 'unknown', url: ''),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : LocationModel(name: 'unknown', url: ''),
      image: json['image'],
      episode: (json['episode'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      created: DateTime.parse(json['created'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
      'episode': episode,
      'created': created.toIso8601String(),
    };
  }
}
