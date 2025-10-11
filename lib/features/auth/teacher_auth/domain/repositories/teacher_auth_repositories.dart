import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:fpdart/fpdart.dart';

abstract class TeacherAuthRepository {
  Future<Either<Failure, Teacher>> signin(String teacherId, String password);
  Future<Either<Failure, void>> signout();
  Future<Either<Failure, Teacher>> getCurrentTeacher();
}
