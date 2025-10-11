import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class SignInCase implements Usecase<Student, SignInParams> {
  final AuthRepositories authRepositories;

  SignInCase({required this.authRepositories});
  @override
  Future<Either<Failure, Student>> call(SignInParams params) async {
    return await authRepositories.signinwithemailandpassword(
      params.email,
      params.password,
    );
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}
