import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';
import 'package:attend_event/features/event_request/domain/repositories/permission_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateRequestStatusCase
    implements Usecase<PermissionRequest, UpdateStatusParams> {
  final PermissionRepository repository;

  UpdateRequestStatusCase({required this.repository});

  @override
  Future<Either<Failure, PermissionRequest>> call(
      UpdateStatusParams params) {
    return repository.updateRequestStatus(
      requestId: params.requestId,
      status: params.status,
    );
  }
}

class UpdateStatusParams {
  final String requestId;
  final String status; // approved/rejected

  UpdateStatusParams({
    required this.requestId,
    required this.status,
  });
}
