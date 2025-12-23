import 'package:multiple_result/multiple_result.dart';
import 'package:rick_and_morty/core/errors/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Result<Failure, Type>> call(Params params);
}
