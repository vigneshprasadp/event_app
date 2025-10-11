part of 'student_auth_cubit.dart';

@immutable
sealed class StudentAuthState {}

final class StudentAuthInitial extends StudentAuthState {}

final class StudentAuthLoading extends StudentAuthState {}

final class StudentAuthSuccess extends StudentAuthState {
  final Student student;
  StudentAuthSuccess({required this.student});
}

final class StudentAuthError extends StudentAuthState {
  final String message;
  StudentAuthError({required this.message});
}
