import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rick_and_morty/core/errors/failure.dart';
import 'package:rick_and_morty/core/usecases/usecase.dart';
import 'package:rick_and_morty/domain/entities/person_entity.dart';
import 'package:rick_and_morty/domain/repositories/person_repository.dart';

class GetAllPersons extends Usecase<List<PersonEntity>, PagePersonParams> {
  final PersonRepository personRepository;

  GetAllPersons({required this.personRepository});

  Future<Result<Failure, List<PersonEntity>>> call(
    PagePersonParams params,
  ) async {
    return await personRepository.getAllPerson(params.page);
  }
}

class PagePersonParams extends Equatable {
  final int page;

  PagePersonParams({required this.page});
  @override
  // TODO: implement props
  List<Object?> get props => [page];
}
