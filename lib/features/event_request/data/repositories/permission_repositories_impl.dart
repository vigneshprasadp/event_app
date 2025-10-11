import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/event_request/data/datasources/permission_data_source.dart';
import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';
import 'package:attend_event/features/event_request/domain/repositories/permission_repository.dart';
import 'package:fpdart/fpdart.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionDataSource dataSource;

  PermissionRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, PermissionRequest>> requestPermission({
    required String studentId,
    required String teacherId,
  }) async {
    try {
      final result = await dataSource.requestPermission(
        studentId: studentId,
        teacherId: teacherId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PermissionRequest>>> getRequestsByStudent(
      String studentId) async {
    try {
      final result = await dataSource.getStudentRequests(studentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PermissionRequest>>> getRequestsByTeacher(
      String teacherId) async {
    try {
      final result = await dataSource.getTeacherRequests(teacherId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, PermissionRequest>> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final result = await dataSource.updateRequestStatus(
        requestId: requestId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
