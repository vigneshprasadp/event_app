import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/auth/student_auth/data/datasources/student_auth_sources.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoriesImpl implements AuthRepositories {
  final AuthDataSources authDataSources;

  AuthRepositoriesImpl({required this.authDataSources});
  @override
  Future<Either<Failure, Student>> getcurrentuser() async {
    try {
      final user = await authDataSources.getcurrentuser();
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Student>> signinwithemailandpassword(
    String email,
    String password,
  ) async {
    try {
      final user = await authDataSources.signinwithemailandpassword(
        email,
        password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signout() async {
    try {
      await authDataSources.signout();
      // ignore: void_checks
      return right(unit);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Student>> signupwithemailandpassword(
    String email,
    String password,
    String regno,
    String name,
    String phone,
  ) async {
    try {
      final user = await authDataSources.signupwithemailandpassword(
        email,
        password,
        regno,
        name,
        phone,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}