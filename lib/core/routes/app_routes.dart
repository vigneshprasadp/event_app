import 'package:attend_event/features/auth/student_auth/presentation/pages/role_selection.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/splash_pages.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/student_homepage.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/student_login.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/student_register.dart';
import 'package:attend_event/features/auth/teacher_auth/presentation/pages/teacher_login_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateroute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const RoleSelection());
      case '/studenthome':
        return MaterialPageRoute(builder: (_) => const StudentHomepage());
      case '/studentregister':
        return MaterialPageRoute(builder: (_) => const StudentRegister());
      case '/studentlogin':
        return MaterialPageRoute(builder: (_) => const StudentLogin());
      case '/splashpage':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/teacherlogin':
        return MaterialPageRoute(builder: (_) => TeacherLoginPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(
                  child: Text(
                    '404 — No route defined for this path!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
        );
    }
  }
}
