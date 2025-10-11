import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_button.dart';
import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_field.dart';
import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final emcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState!.validate()) {
      context.read<StudentAuthCubit>().signin(
        email: emcontroller.text.trim(),
        password: passcontroller.text.trim(),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is StudentAuthSuccess) {
          Navigator.pushReplacementNamed(context, '/studenthome');
        } else if (state is StudentAuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is StudentAuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(title: Text('Student-register'), centerTitle: true),
          body: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthStudentField(labeltext: 'Email', controller: emcontroller),
                SizedBox(height: 15.0), 
                SizedBox(height: 15.0),
                AuthStudentField(
                  labeltext: 'Password',
                  controller: passcontroller,
                ),
                SizedBox(height: 20.0),
                AuthStudentButton(
                  text: 'login',
                  onpressed: () {
                    login();
                  },
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/studentregister'),
                  child: Text('Don/t  have an account?.. register'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
