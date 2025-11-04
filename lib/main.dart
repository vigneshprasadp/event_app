import 'package:attend_event/core/routes/app_routes.dart';
import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:attend_event/features/auth/teacher_auth/presentation/cubit/teacher_auth_cubit.dart';
import 'package:attend_event/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initdependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => servicelocator<StudentAuthCubit>()..curuser()),
        BlocProvider(create: (_) => servicelocator<TeacherAuthCubit>()),
      ],
      child: MaterialApp(
        title: 'Event Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF667EEA),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Color(0xFFF5F7FA),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFF667EEA),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        onGenerateRoute: AppRoutes.generateroute,
        initialRoute: '/',
      ),
    );
  }
}
