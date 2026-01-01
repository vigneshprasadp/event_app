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
  
  String get _title {
    switch (category) {
      case 'all': return 'All Events';
      case 'NCC': return 'NCC Events';
      case 'NSS': return 'NSS Events';
      case 'Sports': return 'Sports Events';
      default: return '$category Events';
    }
  }

  Gradient get _gradient {
    switch (category) {
      case 'NCC': return LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]);
      case 'NSS': return LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)]);
      case 'Sports': return LinearGradient(colors: [Color(0xFFFF9966), Color(0xFFFF5E62)]);
      default: return LinearGradient(colors: [Color(0xFF6A11CB), Color(0xFF2575FC)]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventRepository = EventRepository(Supabase.instance.client);
    
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_title, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _gradient),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
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
                   Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey[300]),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No live events available',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check back later for new events',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: EdgeInsets.all(16),
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
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {}, // Detail view maybe?
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Colors.red),
                          SizedBox(width: 6),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      _formatEventTime(event.scheduledFor),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  event.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                ),
                SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], height: 1.5),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        event.category,
                        style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showJoinDialog(context),
                      icon: Icon(Icons.login_rounded, size: 20),
                      label: Text('Join Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2575FC),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _formatEventTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
