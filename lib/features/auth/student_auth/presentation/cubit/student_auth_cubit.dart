import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/cur_use_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_in_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_out_case.dart';
import 'package:attend_event/features/auth/student_auth/domain/usecases/sign_up_case.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'student_auth_state.dart';

class StudentAuthCubit extends Cubit<StudentAuthState> {
  final SignUpCase signUpCase;
  final SignInCase signInCase;
  final SignOutCase signOutCase;
  final CurUserCase curUserCase;
  StudentAuthCubit({
    required this.signUpCase,
    required this.signInCase,
    required this.signOutCase,
    required this.curUserCase,
  }) : super(StudentAuthInitial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String registerno,
  }) async {
    emit(StudentAuthLoading());
    final res = await signUpCase(
      Signupparams(
        name: name,
        email: email,
        password: password,
        phone: phone,
        registerno: registerno,
      ),
    );
    res.fold(
      (failure) => emit(StudentAuthError(message: failure.message)),
      (student) => emit(StudentAuthSuccess(student: student)),
    );
  }

  Future<void> signin({required String email, required String password}) async {
    emit(StudentAuthLoading());
    final res = await signInCase(
      SignInParams(email: email, password: password),
    );
    res.fold(
      (failure) => emit(StudentAuthError(message: failure.message)),
      (student) => emit(StudentAuthSuccess(student: student)),
    );
  }

  Future<void> signout() async {
    emit(StudentAuthLoading());
    final res = await signOutCase(NoParams());
    res.fold(
      (failure) => emit(StudentAuthError(message: failure.message)),
      (_) => emit(StudentAuthInitial()),
    );
  }

  Future<void> curuser() async {
    emit(StudentAuthLoading());
    final res = await curUserCase(NoParams());
    res.fold(
      (failure) => emit(StudentAuthError(message: failure.message)),
      (student) => emit(StudentAuthSuccess(student: student)),
    );
  }
}
