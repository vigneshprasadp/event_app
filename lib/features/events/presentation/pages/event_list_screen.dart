import 'package:attend_event/features/events/domain/entities/event.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'join_event_dialog.dart';

class EventListScreen extends StatelessWidget {
  final String category;
  final String studentId;
  final String studentName;
  
  const EventListScreen({super.key, 
    required this.category,
    required this.studentId,
    required this.studentName,
  });
  
  @override
  Widget build(BuildContext context) {
    final eventRepository = EventRepository(Supabase.instance.client);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(category == 'all' ? 'All Live Events' : '$category Events'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Event>>(
        stream: eventRepository.getLiveEventsByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading events'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final events = snapshot.data ?? [];
          
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No live events available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check back later for new events',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return LiveEventCard(
                event: event,
                studentId: studentId,
                studentName: studentName,
              );
            },
          );
        },
      ),
    );
  }
}

class LiveEventCard extends StatelessWidget {
  final Event event;
  final String studentId;
  final String studentName;
  
  const LiveEventCard({super.key, 
    required this.event,
    required this.studentId,
    required this.studentName,
  });
  
  void _showJoinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => JoinEventDialog(
        eventId: event.id!,
        studentId: studentId,
        studentName: studentName,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.live_tv, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(
                    event.category,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 8),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  _formatEventTime(event.scheduledFor),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _showJoinDialog(context),
                icon: Icon(Icons.group_add),
                label: Text('Join Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatEventTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}