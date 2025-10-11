import 'package:attend_event/core/errors/failure.dart';
import 'package:attend_event/core/usecase/usecase.dart';
import 'package:attend_event/features/auth/student_auth/domain/repositories/student_auth_repositories.dart';
import 'package:fpdart/fpdart.dart';

class SignOutCase implements Usecase<void, NoParams> {
  final AuthRepositories authRepositories;

  SignOutCase({required this.authRepositories});
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await authRepositories.signout();
  }
}