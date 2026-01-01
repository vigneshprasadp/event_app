import 'package:attend_event/features/events/domain/entities/attendance_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceRepository {
  final SupabaseClient supabase;

  AttendanceRepository(this.supabase);

  // Create attendance request
  Future<void> createAttendanceRequest({
    required String eventId,
    required String studentId,
    required String studentClass,
    required String targetTeacherId,
  }) async {
    try {
      await supabase.from('attendance_requests').insert({
        'event_id': eventId,
        'student_id': studentId,
        'student_year': studentClass,
        'target_teacher_id': targetTeacherId,
        'status': 'pending', 
      });
      
      // Create notification for the selected teacher
      await supabase.from('notifications').insert({
        'teacher_id': targetTeacherId, // This is where we use the param!
        'student_id': studentId,
        'event_id': eventId,
        'type': 'attendance',
        'title': 'New Join Request',
        'body': 'A student has requested to join your event.',
        'is_read': false,
      });
    } catch (e) {
      print('Error creating attendance request: $e');
      rethrow;
    }
  }

  // Check if student already requested to join an event
  Future<bool> hasExistingRequest(String eventId, String studentId) async {
    try {
      final response = await supabase
          .from('attendance_requests')
          .select()
          .eq('event_id', eventId)
          .eq('student_id', studentId)
          .maybeSingle();

      return response != null && response.isNotEmpty;
    } catch (e) {
      print('Error checking existing request: $e');
      return false;
    }
  }

  // Get attendance requests for an event (for host)
  Stream<List<AttendanceRequest>> getAttendanceRequestsForEvent(String eventId) {
    return supabase
        .from('attendance_requests')
        .stream(primaryKey: ['event_id', 'student_id'])
        .map((maps) => maps
            .where((map) => map['event_id'] == eventId)
            .map((map) => AttendanceRequest.fromJson(map))
            .toList()
        );
  }

  // Mark student as present
  Future<void> markStudentPresent(String eventId, String studentId) async {
    await supabase
        .from('attendance_requests')
        .update({'status': 'present'})
        .eq('event_id', eventId)
        .eq('student_id', studentId);
  }

  // MARK STUDENT PRESENT AND NOTIFY - PHASE 5 CORE
  Future<void> markStudentPresentAndNotify({
    required String eventId,
    required String studentId,
    required String targetTeacherId,
    required String studentName,
    required String studentClass,
    required String eventTitle,
  }) async {
    try {
      // Update attendance status
      await supabase
          .from('attendance_requests')
          .update({'status': 'present'})
          .eq('event_id', eventId)
          .eq('student_id', studentId);

      // Create notification for teacher - PHASE 5 ACTION
      await supabase.from('notifications').insert({
        'teacher_id': targetTeacherId,
        'student_id': studentId,
        'event_id': eventId,
        'title': 'Attendance Confirmed ✅',
        'body': 'Student $studentName from class $studentClass has attended: "$eventTitle"',
        'type': 'attendance',
        'is_read': false,
      });

    } catch (e) {
      print('Error marking student present and notifying: $e');
      rethrow;
    }
  }

  // Get attendance requests with student details - FOR EVENT MANAGEMENT SCREEN
  Stream<List<Map<String, dynamic>>> getAttendanceRequestsWithStudentDetails(String eventId) {
    return supabase
        .from('attendance_requests')
        .stream(primaryKey: ['event_id', 'student_id'])
        .map((maps) => maps
            .where((map) => map['event_id'] == eventId && map['status'] == 'pending')
            .toList()
        );
  }

  // Get student details for a specific student
  Future<Map<String, dynamic>?> getStudentDetails(String studentId) async {
    try {
      final response = await supabase
          .from('students')
          .select('full_name, class')
          .eq('id', studentId)
          .single();
      
      return response;
    } catch (e) {
      print('Error getting student details: $e');
      return null;
    }
  }
}