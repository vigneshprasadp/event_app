import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';
import 'package:attend_event/features/event_request/domain/repositories/permission_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetTeacherRequestsCase
    implements Usecase<List<PermissionRequest>, String> {
  final PermissionRepository repository;

  GetTeacherRequestsCase({required this.repository});

  @override
  Future<Either<Failure, List<PermissionRequest>>> call(String teacherId) {
    return repository.getRequestsByTeacher(teacherId);
  }
}
