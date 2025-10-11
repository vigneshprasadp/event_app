import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';
import 'package:attend_event/features/event_request/domain/repositories/permission_repository.dart';
import 'package:fpdart/fpdart.dart';

class RequestPermissionCase
    implements Usecase<PermissionRequest, RequestPermissionParams> {
  final PermissionRepository repository;

  RequestPermissionCase({required this.repository});

  @override
  Future<Either<Failure, PermissionRequest>> call(
      RequestPermissionParams params) {
    return repository.requestPermission(
      studentId: params.studentId,
      teacherId: params.teacherId,
    );
  }
}

class RequestPermissionParams {
  final String studentId;
  final String teacherId;

  RequestPermissionParams({
    required this.studentId,
    required this.teacherId,
  });
}
