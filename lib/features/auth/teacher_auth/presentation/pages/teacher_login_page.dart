import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/teacher_auth_cubit.dart';
import 'teacher_home_page.dart';

class TeacherLoginPage extends StatefulWidget {
  const TeacherLoginPage({super.key});

  @override
  State<TeacherLoginPage> createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Login")),
      body: BlocConsumer<TeacherAuthCubit, TeacherAuthState>(
        listener: (context, state) {
          if (state is TeacherAuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TeacherHomePage(teacher: state.teacher),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TeacherAuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(labelText: 'Teacher ID'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<TeacherAuthCubit>().signin(
                      _idController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  },
                  child: const Text('Login'),
                ),
                if (state is TeacherAuthError)
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
