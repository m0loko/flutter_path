import 'package:multiple_result/multiple_result.dart';
import 'package:rick_and_morty/core/errors/failure.dart';
import 'package:rick_and_morty/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<Result<Failure, List<PersonEntity>>> getAllPerson(int page);
  Future<Result<Failure, List<PersonEntity>>> searchPerson(String query);
}
