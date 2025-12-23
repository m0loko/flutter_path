import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rick_and_morty/core/errors/failure.dart';
import 'package:rick_and_morty/core/usecases/usecase.dart';
import 'package:rick_and_morty/domain/entities/person_entity.dart';
import 'package:rick_and_morty/domain/repositories/person_repository.dart';

class SearchPerson extends Usecase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson({required this.personRepository});

  Future<Result<Failure, List<PersonEntity>>> call(
    SearchPersonParams params,
  ) async {
    return await personRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];
}
