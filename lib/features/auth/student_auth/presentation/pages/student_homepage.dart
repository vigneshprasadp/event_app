import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomepage extends StatefulWidget {
  const StudentHomepage({super.key});

  @override
  State<StudentHomepage> createState() => _StudentHomepageState();
}

class _StudentHomepageState extends State<StudentHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('student-homepage'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<StudentAuthCubit>().signout();
              setState(() {
                Navigator.pushReplacementNamed(context, '/');
              });
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
