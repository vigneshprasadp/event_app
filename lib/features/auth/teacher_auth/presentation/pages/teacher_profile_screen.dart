import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatefulWidget {
  final Teacher teacher;

  const TeacherProfileScreen({super.key, required this.teacher});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  late Teacher _teacher;

  @override
  void initState() {
    super.initState();
    _teacher = widget.teacher;
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _teacher.name);
    final phoneController = TextEditingController(text: ''); // Phone not in entity yet, using placeholder
    final departmentController = TextEditingController(text: _teacher.department);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: departmentController,
                decoration: InputDecoration(labelText: 'Department'),
              ),
              SizedBox(height: 16),
               TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone (Optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement backend update
              setState(() {
                // Optimistic update for UI demo
                // In real app, we would emit event to Cubit
                // _teacher = _teacher.copyWith(name: nameController.text ...);
                // But Teacher entity might not be copyable easily without method.
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully! (Demo)')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                   _buildStatsRow(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Personal Information'),
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF667EEA)),
                        onPressed: _showEditProfileDialog,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildPersonalInfoCard(),
                  SizedBox(height: 20),
                  _buildSectionTitle('Academic Details'),
                  SizedBox(height: 10),
                  _buildAcademicInfoCard(),
                 
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Gradient Background
        Container(
          height: 240,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        
        // Back Button
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        
        // Title
        Positioned(
          top: 60,
          child: Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Profile Card Overlap
        Positioned(
          bottom: -60,
          child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFE0E5EC),
              child: Text(
                _teacher.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF764BA2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatsRow() {
    return Container(
      margin: EdgeInsets.only(top: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Classes', _teacher.coursesTaught.length.toString()),
          _buildStatDivider(),
          _buildStatItem('Years', _teacher.yearsTaught.length.toString()),
          _buildStatDivider(),
          _buildStatItem('Subjects', _teacher.subjectsTaught.length.toString()),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoRow(Icons.badge_outlined, 'Teacher ID', _teacher.teacherId),
            Divider(color: Colors.grey[100], height: 24),
            _buildInfoRow(Icons.person_outline, 'Full Name', _teacher.name),
            Divider(color: Colors.grey[100], height: 24),
            _buildInfoRow(Icons.email_outlined, 'Email', _teacher.email ?? 'N/A'),
            Divider(color: Colors.grey[100], height: 24),
            _buildInfoRow(Icons.business, 'Department', _teacher.department ?? 'N/A'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAcademicInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        _buildTagGroup('Courses Taught', _teacher.coursesTaught),
            SizedBox(height: 20),
            _buildTagGroup('Years Taught', _teacher.yearsTaught),
            SizedBox(height: 20),
            _buildTagGroup('Subjects', _teacher.subjectsTaught),
            if(_teacher.isHomeroomTeacher) ...[
              SizedBox(height: 20),
               Divider(color: Colors.grey[100]),
               SizedBox(height: 10),
               Row(
                 children: [
                   Icon(Icons.star, color: Colors.orange, size: 20),
                   SizedBox(width: 8),
                   Text(
                     'Homeroom Teacher',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: Color(0xFF333333),
                     ),
                   )
                 ],
               ),
               SizedBox(height: 8),
               Padding(
                 padding: const EdgeInsets.only(left: 28.0),
                 child: Text(
                   '${_teacher.homeroomCourse ?? ''} - ${_teacher.homeroomYear ?? ''}',
                   style: TextStyle(
                     fontSize: 16,
                     color: Color(0xFF667EEA),
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Color(0xFF667EEA), size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTagGroup(String title, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFF667EEA).withOpacity(0.3)),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: Color(0xFF667EEA),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
