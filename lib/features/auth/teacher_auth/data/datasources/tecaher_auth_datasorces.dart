import 'package:attend_event/core/errors/exceptions.dart';
import 'package:attend_event/features/auth/teacher_auth/data/model/teacher_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


abstract class TeacherAuthDatasource {
  Future<TeacherModel> signin(String teacherId, String password);
  Future<void> signout();
  Future<TeacherModel> getCurrentTeacher();
}

class TeacherAuthDatasourceImpl implements TeacherAuthDatasource {
  final SupabaseClient supabaseClient;

  TeacherAuthDatasourceImpl({required this.supabaseClient});

  @override
  Future<TeacherModel> signin(String teacherId, String password) async {
    final response = await supabaseClient
        .from('teachers')
        .select()
        .eq('teacher_id', teacherId)
        .eq('password', password)
        .maybeSingle();

    if (response == null) {
      throw const ServerException('Invalid teacher ID or password');
    }



    return TeacherModel.fromJson(response);
  }

  @override
  Future<void> signout() async {
    await supabaseClient.from('teacher_sessions').delete().neq('id', '');
  }

  @override
  Future<TeacherModel> getCurrentTeacher() async {
    final data = await supabaseClient.from('teacher_sessions').select().maybeSingle();

    if (data == null) throw const ServerException('No teacher logged in');

    final teacher = await supabaseClient
        .from('teachers')
        .select()
        .eq('id', data['teacher_id'])
        .single();

    return TeacherModel.fromJson(teacher);
  }
}
