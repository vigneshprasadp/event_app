import 'package:attend_event/features/event_request/domain/entities/permission_request.dart';

class PermissionRequestModel extends PermissionRequest {
  PermissionRequestModel({
    required super.id,
    required super.studentId,
    required super.teacherId,
    required super.status,
    required super.createdAt,
    super.expiresAt,
  });

  factory PermissionRequestModel.fromJson(Map<String, dynamic> json) {
    return PermissionRequestModel(
      id: json['id'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'teacher_id': teacherId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
