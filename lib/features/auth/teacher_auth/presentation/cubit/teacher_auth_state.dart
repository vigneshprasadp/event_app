part of 'teacher_auth_cubit.dart';

@immutable
sealed class TeacherAuthState {}

final class TeacherAuthInitial extends TeacherAuthState {}
final class TeacherAuthLoading extends TeacherAuthState {}
final class TeacherAuthSuccess extends TeacherAuthState {
  final Teacher teacher;
  TeacherAuthSuccess(this.teacher);
}
final class TeacherAuthError extends TeacherAuthState {
  final String message;
  TeacherAuthError(this.message);
}
