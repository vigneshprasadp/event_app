import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class SignUpCase implements Usecase<Student, Signupparams> {
  final AuthRepositories authRepositories;

  SignUpCase({required this.authRepositories});
  @override
  Future<Either<Failure, Student>> call(Signupparams params) async {
    return await authRepositories.signupwithemailandpassword(
      params.email,
      params.password,
      params.registerno,
      params.name,
      params.phone,
    );
  }
}

class Signupparams {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String registerno;

  Signupparams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.registerno,
  });
}
