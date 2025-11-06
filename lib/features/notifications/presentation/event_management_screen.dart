import 'package:attend_event/features/events/domain/entities/event.dart';
import 'package:attend_event/features/events/domain/repositories/attendance_repository.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventManagementScreen extends StatefulWidget {
  final Event event;
  final String hostStudentId;

  const EventManagementScreen({super.key, 
    required this.event,
    required this.hostStudentId,
  });

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  final AttendanceRepository _attendanceRepository = AttendanceRepository(Supabase.instance.client);
  final EventRepository _eventRepository = EventRepository(Supabase.instance.client);
  
  final Map<String, Map<String, dynamic>> _studentDetails = {};

  @override
  void initState() {
    super.initState();
    _loadStudentDetails();
  }

  Future<void> _loadStudentDetails() async {
    try {
      final studentsResponse = await Supabase.instance.client
          .from('students')
          .select('id, full_name, class');
      
      if (studentsResponse is List) {
        for (var student in studentsResponse) {
          _studentDetails[student['id']] = {
            'name': student['full_name'],
            'class': student['class'],
          };
        }
        setState(() {});
      }
    } catch (e) {
      print('Error loading student details: $e');
    }
  }

  String _getStudentName(String studentId) {
    return _studentDetails[studentId]?['name'] ?? 'Loading...';
  }

  String _getStudentClass(String studentId) {
    return _studentDetails[studentId]?['class'] ?? 'Loading...';
  }

  Future<void> _markStudentPresent(Map<String, dynamic> request) async {
    try {
      final studentId = request['student_id'];
      final studentName = _getStudentName(studentId);
      final studentClass = _getStudentClass(studentId);

      await _attendanceRepository.markStudentPresentAndNotify(
        eventId: widget.event.id!,
        studentId: studentId,
        targetTeacherId: request['target_teacher_id'],
        studentName: studentName,
        studentClass: studentClass,
        eventTitle: widget.event.title,
      );

      // Generate certificate
      await _generateAttendanceCertificate(
        studentName: studentName,
        studentClass: studentClass,
        eventTitle: widget.event.title,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ $studentName marked present! Certificate generated.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to mark student present: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _generateAttendanceCertificate({
    required String studentName,
    required String studentClass,
    required String eventTitle,
  }) async {
    final certificateContent = '''
🎓 ATTENDANCE CERTIFICATE

This is to certify that 
**$studentName**
from class **$studentClass** 
has successfully attended the event:

**"$eventTitle"**

📅 Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}
⏰ Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}

Hosted by: ${_getStudentName(widget.hostStudentId)}

✅ Verified Attendance
''';

    _showCertificateDialog(certificateContent, studentName);
  }

  void _showCertificateDialog(String content, String studentName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.verified, color: Colors.green),
            SizedBox(width: 8),
            Text('Certificate for $studentName'),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('📄 Certificate saved for $studentName')),
              );
              Navigator.pop(context);
            },
            child: Text('Save Certificate'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage ${widget.event.title}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Event Info Card
          Card(
            margin: EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.event.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          widget.event.category,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.live_tv, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'LIVE EVENT',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Pending Requests Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '📋 Pending Join Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _attendanceRepository.getAttendanceRequestsWithStudentDetails(widget.event.id!),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.length ?? 0;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: count > 0 ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Mark students as present after verification',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          // Requests List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _attendanceRepository.getAttendanceRequestsWithStudentDetails(widget.event.id!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading requests'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final requests = snapshot.data ?? [];

                if (requests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No pending requests',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Students will appear here when they\nrequest to join your event',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final studentId = request['student_id'];
                    final studentName = _getStudentName(studentId);
                    final studentClass = _getStudentClass(studentId);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(
                            studentName[0],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          studentName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Class: $studentClass'),
                            Text(
                              '🕒 ${_formatTime(DateTime.parse(request['created_at']))}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: () => _markStudentPresent(request),
                          icon: Icon(Icons.verified, size: 18),
                          label: Text('Present'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}