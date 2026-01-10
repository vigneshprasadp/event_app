import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/event.dart';

class EventRepository {
  final SupabaseClient supabase;

  EventRepository(this.supabase);

  // Get all teachers for dropdown
  Future<List<Teacher>> getTeachers() async {
    try {
      final response = await supabase.from('teachers').select().order('name');

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
        .map(
          (maps) =>
              maps
                  .where(
                    (map) =>
                        map['supervising_teacher_id'] == teacherId &&
                        map['status'] == 'pending',
                  )
                  .map((map) => Event.fromJson(map))
                  .toList(),
        );
  }

  // Get student's created events
  Stream<List<Event>> getStudentEvents(String studentId) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (maps) =>
              maps
                  .where((map) => map['created_by'] == studentId)
                  .map((map) => Event.fromJson(map))
                  .toList(),
        );
  }

  // Make event live
  Future<void> makeEventLive(String eventId) async {
    await supabase.from('events').update({'status': 'live'}).eq('id', eventId);
  }

  // Get live events for a category
  Stream<List<Event>> getLiveEventsByCategory(String category) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (maps) =>
              maps
                  .where((map) {
                    final isLive = map['status'] == 'live';
                    final matchesCategory =
                        category == 'all' || map['category'] == category;
                    return isLive && matchesCategory;
                  })
                  .map((map) => Event.fromJson(map))
                  .toList(),
        );
  }

  // Get all events for a teacher (supervising)
  Stream<List<Event>> getEventsForTeacher(String teacherId) {
    return supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('scheduled_for', ascending: false)
        .map(
          (maps) =>
              maps
                  .where((map) => map['supervising_teacher_id'] == teacherId)
                  .map((map) => Event.fromJson(map))
                  .toList(),
        );
  }

  // Get events where the teacher was selected by at least one student
  Future<List<Event>> getEventsTargetingTeacher(String teacherId) async {
    try {
      // 1. Get unique event IDs from requests targeting this teacher
      final response = await supabase
          .from('attendance_requests')
          .select('event_id')
          .eq('target_teacher_id', teacherId);

      if (response == null || (response as List).isEmpty) return [];

      final eventIds =
          (response as List)
              .map((e) => e['event_id'] as String)
              .toSet()
              .toList();

      if (eventIds.isEmpty) return [];

      // 2. Fetch details for these events
      final eventsData = await supabase
          .from('events')
          .select()
          .filter('id', 'in', eventIds)
          .order('scheduled_for', ascending: false);

      return (eventsData as List).map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching targeted events: $e');
      return [];
    }
  }

  // Update event status (approve/reject/stop)
  Future<void> updateEventStatus(String eventId, String status) async {
    await supabase.from('events').update({'status': status}).eq('id', eventId);
  }

  // Check if student successfully joined (pending or present)
  Future<bool> hasStudentJoined(String eventId, String studentId) async {
    try {
      final response =
          await supabase
              .from('attendance_requests')
              .select('id')
              .eq('event_id', eventId)
              .eq('student_id', studentId)
              .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await supabase.from('events').delete().eq('id', eventId);
  }
}
