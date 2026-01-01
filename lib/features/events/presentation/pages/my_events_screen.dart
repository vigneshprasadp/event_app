import 'package:attend_event/features/events/domain/entities/event.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:attend_event/features/notifications/presentation/event_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class MyEventsScreen extends StatefulWidget {
  final String studentId;

  const MyEventsScreen({super.key, required this.studentId});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  final EventRepository _eventRepository = EventRepository(
    Supabase.instance.client,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('My Events', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<Event>>(
        stream: _eventRepository.getStudentEvents(widget.studentId),
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
                    child: Icon(Icons.event_note_rounded, size: 60, color: Colors.grey[300]),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No events created yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first event to get started!',
                    style: TextStyle(color: Colors.grey[600]),
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
              return _buildEventCard(event);
            },
          );
        },
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    Color statusColor = _getStatusColor(event.status);
    
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
          onTap: () {},
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
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _confirmDelete(event.id!),
                        tooltip: "Delete Event",
                    ),
                  ],
                ),
                Text(
                  _formatEventDate(event.scheduledFor),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  event.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                ),
                SizedBox(height: 8),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                     Chip(
                      label: Text(
                        event.category,
                        style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                
                // Actions
                if (event.status == 'approved' || event.status == 'live') ...[
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 10),
                  if (event.status == 'approved')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _makeEventLive(event, context),
                        icon: Icon(Icons.videocam_rounded, size: 20),
                        label: Text('GO LIVE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  if (event.status == 'live')
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventManagementScreen(
                                    event: event,
                                    hostStudentId: widget.studentId,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.settings_rounded, size: 20),
                            label: Text('Manage Event'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                         SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _confirmStop(event.id!),
                            icon: Icon(Icons.pause_circle_outline, size: 20),
                            label: Text('Stop Event (Pause)'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: BorderSide(color: Colors.orange),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                         SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _confirmComplete(event.id!),
                            icon: Icon(Icons.check_circle_outline, size: 20),
                            label: Text('End Event'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved': return Colors.green;
      case 'pending': return Colors.orange;
      case 'rejected': return Colors.red;
      case 'live': return Colors.redAccent;
      case 'completed': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _formatEventDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(date);
  }

  Future<void> _makeEventLive(Event event, BuildContext context) async {
    // Check if today is the event day
    final now = DateTime.now();
    final scheduled = event.scheduledFor;
    final isSameDay = now.year == scheduled.year && 
                      now.month == scheduled.month && 
                      now.day == scheduled.day;
    
    if (!isSameDay) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wait! You can only go live on the scheduled day (${DateFormat('MMM d').format(scheduled)}).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await _eventRepository.updateEventStatus(event.id!, 'live');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Event is now live! Students can join now.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to make event live: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmStop(String eventId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Stop Event?"),
        content: Text("If you stop the event now, it will go back to pending status and require teacher approval to start again."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true), 
            child: Text("Stop Event")
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _eventRepository.updateEventStatus(eventId, 'pending'); // Revert to pending
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event stopped. Teacher approval required to restart.")));
    }
  }
  
  Future<void> _confirmComplete(String eventId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("End Event?"),
        content: Text("This will mark the event as completed and remove it from the live list. Students can no longer join."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true), 
            child: Text("End Event")
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _eventRepository.updateEventStatus(eventId, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Event marked as completed!")));
    }
  }

  Future<void> _confirmDelete(String eventId) async {
     final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Event?"),
        content: Text("Are you sure you want to delete this event? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true), 
            child: Text("Delete")
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _eventRepository.deleteEvent(eventId);
    }
  }
}
