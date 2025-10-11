import 'package:attend_event/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class Usecase<Successtype, params> {
  Future<Either<Failure, Successtype>> call(params params);
}

class NoParams{}