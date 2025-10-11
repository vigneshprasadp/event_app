import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/features/event_request/data/datasources/permission_data_source.dart';
import 'package:attend_event/features/event_request/data/models/permission_request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PermissionDataSourceImpl implements PermissionDataSource {
  final SupabaseClient supabaseClient;
  final uuid = const Uuid();

  PermissionDataSourceImpl({required this.supabaseClient});

  @override
  Future<PermissionRequestModel> requestPermission({
    required String studentId,
    required String teacherId,
  }) async {
    try {
      final id = uuid.v4();
      final createdAt = DateTime.now();
      final expiresAt = createdAt.add(const Duration(hours: 24));

      final response = await supabaseClient.from('event_permissions').insert({
        'id': id,
        'student_id': studentId,
        'teacher_id': teacherId,
        'status': 'pending',
        'created_at': createdAt.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
      }).select().single();

      return PermissionRequestModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PermissionRequestModel>> getStudentRequests(
      String studentId) async {
    try {
      final response = await supabaseClient
          .from('event_permissions')
          .select()
          .eq('student_id', studentId)
          .order('created_at', ascending: false);

      return response
          .map<PermissionRequestModel>(
              (data) => PermissionRequestModel.fromJson(data))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PermissionRequestModel>> getTeacherRequests(
      String teacherId) async {
    try {
      final response = await supabaseClient
          .from('event_permissions')
          .select()
          .eq('teacher_id', teacherId)
          .order('created_at', ascending: false);

      return response
          .map<PermissionRequestModel>(
              (data) => PermissionRequestModel.fromJson(data))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PermissionRequestModel> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final response = await supabaseClient
          .from('event_permissions')
          .update({'status': status})
          .eq('id', requestId)
          .select()
          .single();

      return PermissionRequestModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
