import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/student_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  void _checkAuthState() {
    final state = context.read<StudentAuthCubit>().state;
    if (state is StudentAuthSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => StudentHomepage(student: state.student)),
        );
      });
    } else if (state is StudentAuthError || state is StudentAuthInitial) {
      // If we are just starting up, we might be 'Initial' before 'Loading'?
      // But main.dart calls curuser immediately.
      // If we are coming from Logout, we are definitely Initial.
      // Let's give a small delay to allow 'Loading' to emit if it's a fresh start,
      // but if we are truly stuck in Initial (logout), we go to login.
      // However, seeing 'Initial' could mean 'Not Started Yet' or 'Logged Out'.
      // Since main triggers it, it should be Loading.
      // If it is Initial, it means we probably dragged from Logout.
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if (state is! StudentAuthLoading) {
             Navigator.pushReplacementNamed(context, '/studentlogin');
         }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is StudentAuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => StudentHomepage(student: state.student),
            ),
          );
        } else if (state is StudentAuthError || state is StudentAuthInitial) {
          Navigator.pushReplacementNamed(context, '/studentlogin');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // College Logo
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/college_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.school, size: 60, color: Color(0xFF667EEA));
                    },
                  ),
                ),
              ),
              SizedBox(height: 32),
              
              // College Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Maharani Lakshmi Ammanni College For Womens Autonomous',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 48),
              
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
