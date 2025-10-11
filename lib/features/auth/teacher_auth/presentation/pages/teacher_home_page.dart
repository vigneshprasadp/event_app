import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:flutter/material.dart';


class TeacherHomePage extends StatelessWidget {
  final Teacher teacher;
  const TeacherHomePage({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${teacher.name}")),
      body: Center(
        child: Text(
          "Department: ${teacher.department}",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
