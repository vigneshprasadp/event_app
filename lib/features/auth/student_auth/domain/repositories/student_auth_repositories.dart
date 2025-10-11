import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepositories {
  Future<Either<Failure, Student>> signupwithemailandpassword(
    String email,
    String password,
    String regno,
    String name,
    String phone,
  );

  Future<Either<Failure, Student>> signinwithemailandpassword(
    String email,
    String password,
  );

  Future<Either<Failure, void>> signout();

  Future<Either<Failure, Student>> getcurrentuser();
}
