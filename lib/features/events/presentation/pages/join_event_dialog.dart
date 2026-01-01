import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/events/domain/repositories/attendance_repository.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JoinEventDialog extends StatefulWidget {
  final String eventId;
  final String studentId;
  final String studentName;
  
  const JoinEventDialog({super.key, 
    required this.eventId,
    required this.studentId,
    required this.studentName,
  });
  
  @override
  State<JoinEventDialog> createState() => _JoinEventDialogState();
}

class _JoinEventDialogState extends State<JoinEventDialog> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository(Supabase.instance.client);
  final EventRepository _eventRepository = EventRepository(Supabase.instance.client);
  
  String? _selectedClass;
  String? _selectedTeacherId;
  List<Teacher> _teachers = [];
  final List<String> _classes = ['First Year', 'Second Year', 'Third Year'];
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }
  
  Future<void> _loadTeachers() async {
    try {
      final teachers = await _eventRepository.getTeachers();
      setState(() => _teachers = teachers);
    } catch (e) {
      print('Error loading teachers: $e');
    }
  }
  
  Future<void> _joinEvent() async {
    if (_selectedClass == null || _selectedTeacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select class and teacher')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Check if already requested
      final hasRequest = await _attendanceRepository.hasExistingRequest(
        widget.eventId, 
        widget.studentId
      );
      
      if (hasRequest) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already requested to join this event')),
        );
        Navigator.pop(context);
        return;
      }
      
      // Create attendance request
      await _attendanceRepository.createAttendanceRequest(
        eventId: widget.eventId,
        studentId: widget.studentId,
        studentClass: _selectedClass!,
        targetTeacherId: _selectedTeacherId!,
      );
      
      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Join request sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.group_add, color: Colors.blue),
          SizedBox(width: 8),
          Text('Join Event'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${widget.studentName}!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            
            // Class Dropdown
            DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: InputDecoration(
                labelText: 'Your Class',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.class_),
              ),
              items: _classes
                  .map((classItem) => DropdownMenuItem(
                        value: classItem,
                        child: Text(classItem),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedClass = value!);
              },
            ),
            SizedBox(height: 16),
            
            // Teacher Dropdown
            if (_teachers.isEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'No teachers available. Please contact administrator.',
                  style: TextStyle(color: Colors.orange),
                ),
              )
            else
              DropdownButtonFormField<String>(
                value: _selectedTeacherId,
                isExpanded: true, // Fix Horizontal Overflow
                decoration: InputDecoration(
                  labelText: 'Select Reporting Teacher',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: _teachers
                    .map((teacher) => DropdownMenuItem(
                          value: teacher.id,
                          child: Text(
                            teacher.department != null 
                                ? '${teacher.name} (${teacher.department})'
                                : teacher.name,
                            overflow: TextOverflow.ellipsis, // detailed handling
                            maxLines: 1,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedTeacherId = value!);
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading || _teachers.isEmpty ? null : _joinEvent,
          child: _isLoading 
              ? SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text('Send Join Request'),
        ),
      ],
    );
  }
}