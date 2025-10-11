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
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        onGenerateRoute: AppRoutes.generateroute,
        initialRoute: '/',
      ),
    );
  }
}
