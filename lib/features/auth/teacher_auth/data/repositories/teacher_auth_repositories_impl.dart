import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/auth/teacher_auth/data/datasources/tecaher_auth_datasorces.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/repositories/teacher_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class TeacherAuthRepositoryImpl implements TeacherAuthRepository {
  final TeacherAuthDatasource teacherAuthDatasource;

  TeacherAuthRepositoryImpl({required this.teacherAuthDatasource});

  @override
  Future<Either<Failure, Teacher>> signin(String teacherId, String password) async {
    try {
      final teacher = await teacherAuthDatasource.signin(teacherId, password);
      return right(teacher);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signout() async {
    try {
      await teacherAuthDatasource.signout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Teacher>> getCurrentTeacher() async {
    try {
      final teacher = await teacherAuthDatasource.getCurrentTeacher();
      return right(teacher);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
