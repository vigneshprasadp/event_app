import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class CurUserCase implements Usecase<Student, NoParams> {
  final AuthRepositories authRepositories;

  CurUserCase({required this.authRepositories});
  @override
  Future<Either<Failure, Student>> call(NoParams params) async {
    return await authRepositories.getcurrentuser();
  }
}