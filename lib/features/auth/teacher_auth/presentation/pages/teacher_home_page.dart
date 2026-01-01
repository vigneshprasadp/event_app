import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/auth/teacher_auth/presentation/pages/teacher_attendance_screen.dart';
import 'package:attend_event/features/auth/teacher_auth/presentation/pages/teacher_profile_screen.dart';
import 'package:attend_event/features/events/presentation/pages/teacher_notifiactions.dart';
import 'package:attend_event/features/events/presentation/pages/tecaher_request_creation.dart';
import 'package:attend_event/features/notifications/domain/notifications.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeacherHomePage extends StatelessWidget {
  final Teacher teacher;
  const TeacherHomePage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Stack(
        children: [
          // 1. Background Gradient Header
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Color(0xFF667EEA).withOpacity(0.1),
                              child: Text(
                                teacher.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Color(0xFF764BA2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Teacher Portal',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                teacher.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      Row(
                        children: [
                          // Logout Button
                          Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.logout_rounded, color: Colors.white),
                              onPressed: () {
                                // Logout Logic
                                Supabase.instance.client.auth.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                              },
                              tooltip: 'Logout',
                            ),
                          ),

                          // Notification Badge
                          StreamBuilder<List<Notifications>>(
                            stream: _getUnreadNotificationsStream(),
                            builder: (context, snapshot) {
                              final unreadCount = snapshot.data?.length ?? 0;
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TeacherNotificationsScreen(teacherId: teacher.id),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.notifications_outlined, color: Colors.white),
                                    ),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 12,
                                          minHeight: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // Department Info (Inside Header)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            teacher.department ?? "General Department",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // White Body Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(24),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Dashboard Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8, // Adjusted for overflow prevention
                            children: [
                              _buildDashboardCard(
                                context,
                                'Event Requests',
                                'Manage pending approvals',
                                Icons.verified_user_outlined,
                                Colors.orange,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherRequestsScreen(teacherId: teacher.id),
                                    ),
                                  );
                                },
                              ),
                              _buildDashboardCard(
                                context,
                                'Notifications',
                                'View recent updates',
                                Icons.notifications_active_outlined,
                                Colors.blue,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherNotificationsScreen(teacherId: teacher.id),
                                    ),
                                  );
                                },
                              ),
                              _buildDashboardCard(
                                context,
                                'Attendance',
                                'View reports',
                                Icons.bar_chart_rounded,
                                Colors.green,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherAttendanceScreen(teacher: teacher),
                                    ),
                                  );
                                },
                              ),
                              _buildDashboardCard(
                                context,
                                'Profile',
                                'Edit details',
                                Icons.person_outline_rounded,
                                Colors.purple,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TeacherProfileScreen(teacher: teacher),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24),
                          
                          // Quick Stats or Recent Activity Placeholder
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded, size: 20, color: Colors.grey),
                                    SizedBox(width: 8),
                                    Text(
                                      "Teacher Information",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 24),
                                _buildInfoRow("Teacher ID", teacher.teacherId),
                                SizedBox(height: 12),
                                _buildInfoRow("Email", teacher.email ?? "N/A"),
                                SizedBox(height: 12),
                                _buildInfoRow("Courses", teacher.coursesTaught.isEmpty 
                                    ? "None" 
                                    : teacher.coursesTaught.join(", ")),
                                SizedBox(height: 12),
                                _buildInfoRow("Years", teacher.yearsTaught.isEmpty 
                                    ? "None" 
                                    : teacher.yearsTaught.join(", ")),
                                if (teacher.isHomeroomTeacher) ...[
                                  SizedBox(height: 12),
                                  _buildInfoRow("Homeroom", "${teacher.homeroomCourse ?? 'N/A'} - ${teacher.homeroomYear ?? 'N/A'}"),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Colorful light background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2), width: 1), // Subtle border
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white, // White icon background for pop
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Real-time unread notifications stream
  Stream<List<Notifications>> _getUnreadNotificationsStream() {
    return Supabase.instance.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .map((maps) => maps
            .where((map) => map['teacher_id'] == teacher.id && map['is_read'] == false)
            .map((map) => Notifications.fromJson(map))
            .toList()
        );
  }
}