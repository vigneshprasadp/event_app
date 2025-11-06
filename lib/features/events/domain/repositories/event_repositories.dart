import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/event.dart';

class EventRepository {
  final SupabaseClient supabase;

  EventRepository(this.supabase);

  // Get all teachers for dropdown
  Future<List<Teacher>> getTeachers() async {
    try {
      final response = await supabase
          .from('teachers')
          .select()
          .order('name');

      if (response is List) {
        return response.map<Teacher>((teacherData) {
          return Teacher.fromJson(teacherData);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error loading teachers: $e');
      return [];
    }
  }

  // Create event with teacher request
  Future<void> createEventWithTeacherRequest(Event event) async {
    await supabase.from('events').insert(event.toJson());
  }

  // Get pending requests for teacher
  Stream<List<Event>> getPendingRequestsForTeacher(String teacherId) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps
            .where((map) => 
                map['supervising_teacher_id'] == teacherId && 
                map['status'] == 'pending'
            )
            .map((map) => Event.fromJson(map))
            .toList()
        );
  }

  // Get student's created events
  Stream<List<Event>> getStudentEvents(String studentId) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps
            .where((map) => map['created_by'] == studentId)
            .map((map) => Event.fromJson(map))
            .toList()
        );
  }

  // Make event live
  Future<void> makeEventLive(String eventId) async {
    await supabase
        .from('events')
        .update({'status': 'live'})
        .eq('id', eventId);
  }

  // Get live events for a category
  Stream<List<Event>> getLiveEventsByCategory(String category) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps
            .where((map) {
              final isLive = map['status'] == 'live';
              final matchesCategory = category == 'all' || map['category'] == category;
              return isLive && matchesCategory;
            })
            .map((map) => Event.fromJson(map))
            .toList()
        );
  }

  // Update event status (approve/reject)
  Future<void> updateEventStatus(String eventId, String status) async {
    await supabase
        .from('events')
        .update({'status': status})
        .eq('id', eventId);
  }
}