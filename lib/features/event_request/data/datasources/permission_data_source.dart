import 'package:attend_event/features/event_request/data/models/permission_request_model.dart';

abstract class PermissionDataSource {
  Future<PermissionRequestModel> requestPermission({
    required String studentId,
    required String teacherId,
  });

  Future<List<PermissionRequestModel>> getStudentRequests(String studentId);

  Future<List<PermissionRequestModel>> getTeacherRequests(String teacherId);

  Future<PermissionRequestModel> updateRequestStatus({
    required String requestId,
    required String status,
  });
}
