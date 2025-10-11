import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is StudentAuthSuccess) {
          Navigator.pushReplacementNamed(context, '/studenthome');
        } else if (state is StudentAuthError || state is StudentAuthInitial) {
          Navigator.pushReplacementNamed(context, '/studentlogin');
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
