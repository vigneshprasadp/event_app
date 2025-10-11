import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/repositories/teacher_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TeacherSignInCase implements Usecase<Teacher, Params> {
  final TeacherAuthRepository teacherAuthRepository;

  TeacherSignInCase({required this.teacherAuthRepository});

  @override
  Future<Either<Failure, Teacher>> call(Params params) async {
    return await teacherAuthRepository.signin(params.teacherId, params.password);
  }
}

class Params {
  final String teacherId;
  final String password;

  Params({required this.teacherId, required this.password});
}
