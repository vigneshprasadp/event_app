import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/auth/teacher_auth/domain/usecases/teacher_sign_in.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'teacher_auth_state.dart';

class TeacherAuthCubit extends Cubit<TeacherAuthState> {
  final TeacherSignInCase teacherSignInCase;

  TeacherAuthCubit({required this.teacherSignInCase})
      : super(TeacherAuthInitial());

  Future<void> signin(String teacherId, String password) async {
    emit(TeacherAuthLoading());
    final res = await teacherSignInCase(Params(teacherId: teacherId, password: password));
    res.fold(
      (failure) => emit(TeacherAuthError(failure.message)),
      (teacher) => emit(TeacherAuthSuccess(teacher)),
    );
  }
}
