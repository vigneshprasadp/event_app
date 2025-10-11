import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';
import 'package:fpdart/fpdart.dart';


abstract class PermissionRepository {
  Future<Either<Failure, PermissionRequest>> requestPermission({
    required String studentId,
    required String teacherId,
  });

  Future<Either<Failure, List<PermissionRequest>>> getRequestsByStudent(
    String studentId,
  );

  Future<Either<Failure, List<PermissionRequest>>> getRequestsByTeacher(
    String teacherId,
  );

  Future<Either<Failure, PermissionRequest>> updateRequestStatus({
    required String requestId,
    required String status, // approved | rejected
  });
}
