import 'package:attend_event/core/common/secrets.dart';
import 'package:attend_event/features/auth/student_auth/data/datasources/student_auth_sources.dart';
import 'package:attend_event/features/auth/student_auth/data/repositories/student_auth_repository_impl.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/cur_use_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_in_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_out_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_up_case.dart';
import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:attend_event/features/auth/teacher_auth/data/datasources/tecaher_auth_datasorces.dart';
import 'package:attend_event/features/auth/teacher_auth/data/repositories/teacher_auth_repositories_impl.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/repositories/teacher_auth_repositories.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/usecases/teacher_sign_in.dart';
import 'package:attend_event/features/auth/teacher_auth/presentation/cubit/teacher_auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final servicelocator = GetIt.instance;
Future<void> initdependencies() async {
  _studentauth();
  _teacherauth();
  await Supabase.initialize(
    url: Secrets.supabaseurl,
    anonKey: Secrets.supabaseanonkey,
  );
  servicelocator.registerLazySingleton(() => Supabase.instance.client);
}

void _studentauth() {
  servicelocator.registerFactory<AuthDataSources>(
    () => AuthDatasourcesImpl(supabaseClient: servicelocator<SupabaseClient>()),
  );

  servicelocator.registerFactory<AuthRepositories>(
    () => AuthRepositoriesImpl(
      authDataSources: servicelocator<AuthDataSources>(),
    ),
  );

  servicelocator.registerFactory(
    () => SignUpCase(authRepositories: servicelocator<AuthRepositories>()),
  );

  servicelocator.registerFactory(
    () => SignInCase(authRepositories: servicelocator<AuthRepositories>()),
  );

  servicelocator.registerFactory(
    () => SignOutCase(authRepositories: servicelocator<AuthRepositories>()),
  );

  servicelocator.registerFactory(
    () => CurUserCase(authRepositories: servicelocator<AuthRepositories>()),
  );

  servicelocator.registerLazySingleton<StudentAuthCubit>(
    () => StudentAuthCubit(
      signUpCase: servicelocator<SignUpCase>(),
      signInCase: servicelocator<SignInCase>(),
      signOutCase: servicelocator<SignOutCase>(),
      curUserCase: servicelocator<CurUserCase>(),
    ),
  );
}

void _teacherauth() {
  servicelocator.registerFactory<TeacherAuthDatasource>(
    () => TeacherAuthDatasourceImpl(supabaseClient: servicelocator()),
  );

  servicelocator.registerFactory<TeacherAuthRepository>(
    () => TeacherAuthRepositoryImpl(teacherAuthDatasource: servicelocator()),
  );

  servicelocator.registerFactory(
    () => TeacherSignInCase(teacherAuthRepository: servicelocator()),
  );

  servicelocator.registerLazySingleton(
    () => TeacherAuthCubit(teacherSignInCase: servicelocator()),
  );
}
