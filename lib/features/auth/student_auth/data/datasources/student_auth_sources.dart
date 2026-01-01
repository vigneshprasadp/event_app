import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/features/auth/student_auth/data/models/student_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthDataSources {
  Future<StudentModel> signupwithemailandpassword(
    String email,
    String password,
    String regno,
    String name,
    String phone,
    String year,
    String course,
  );
  Future<StudentModel> signinwithemailandpassword(
    String email,
    String password,
  );
  Future<void> signout();
  Future<StudentModel> getcurrentuser();
  Future<void> resetPassword(String email);
}

class AuthDatasourcesImpl implements AuthDataSources {
  final SupabaseClient supabaseClient;

  AuthDatasourcesImpl({required this.supabaseClient});

  @override
  Future<void> resetPassword(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<StudentModel> getcurrentuser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw const ServerException('No current user');

    final response = await supabaseClient
        .from('students')
        .select()
        .eq('id', user.id);

    if (response.isEmpty) {
      throw const ServerException('Student record not found in database');
    }

    final stud = response.first;

    return StudentModel.fromjson(stud);
  }

  @override
  Future<StudentModel> signinwithemailandpassword(
    String email,
    String password,
  ) async {
    try {
      final responce = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (responce.user == null) {
        throw const ServerException('User is null');
      }
      final stud =
          await supabaseClient
              .from('students')
              .select()
              .eq('id', responce.user!.id)
              .single();
      return StudentModel.fromjson(stud);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<StudentModel> signupwithemailandpassword(
    String email,
    String password,
    String regno,
    String name,
    String phone,
    String year,
    String course,
  ) async {
    try {
      final responce = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (responce.user == null) {
        throw const ServerException('User is null');
      }
      final studentdata = StudentModel(
        id: responce.user!.id,
        name: name,
        email: email,
        phone: phone,
        registerno: regno,
        year: year,
        course: course,
      );
      final stud =
          await supabaseClient
              .from('students')
              .insert(studentdata.tojson())
              .select()
              .single();

      return StudentModel.fromjson(stud);
    } catch (e) {
      if (e.toString().contains('register_number')) {
        throw const ServerException('Register number already exists');
      }

      throw ServerException(e.toString());
    }
  }
}
