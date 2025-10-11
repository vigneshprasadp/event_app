class PermissionRequest {
  final String id;
  final String studentId;
  final String teacherId;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime? expiresAt;

  PermissionRequest({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.status,
    required this.createdAt,
    this.expiresAt,
  });
}
