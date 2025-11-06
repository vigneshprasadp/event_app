import 'package:attend_event/features/events/domain/entities/event.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherRequestsScreen extends StatelessWidget {
  final String teacherId;
  
  const TeacherRequestsScreen({super.key, required this.teacherId});
  
  @override
  Widget build(BuildContext context) {
    final eventRepository = EventRepository(Supabase.instance.client);
    
    return Scaffold(
      appBar: AppBar(title: Text('Event Requests')),
      body: StreamBuilder<List<Event>>(
        stream: eventRepository.getPendingRequestsForTeacher(teacherId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final events = snapshot.data ?? [];
          
          if (events.isEmpty) {
            return Center(child: Text('No pending requests'));
          }
          
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventRequestCard(
                event: event,
                onAccept: () => _handleRequest(context, event, EventStatus.approved),
                onReject: () => _handleRequest(context, event, EventStatus.rejected),
              );
            },
          );
        },
      ),
    );
  }
  
  Future<void> _handleRequest(BuildContext context, Event event, EventStatus status) async {
    try {
      final eventRepository = EventRepository(Supabase.instance.client);
      await eventRepository.updateEventStatus(event.id!, status.name);
      
      final action = status == EventStatus.approved ? 'approved' : 'rejected';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event request $action successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: $e')),
      );
    }
  }
}

// ADD THIS WIDGET - Event Request Card
class EventRequestCard extends StatelessWidget {
  final Event event;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  
  const EventRequestCard({super.key, 
    required this.event,
    required this.onAccept,
    required this.onReject,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(event.description),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(event.category)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Scheduled: ${_formatEventDate(event.scheduledFor)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text('Reject'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    child: Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatEventDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}