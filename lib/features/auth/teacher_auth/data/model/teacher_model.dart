import '../../domain/entities/teacher.dart';

class TeacherModel extends Teacher {
  TeacherModel({
    required super.id,
    required super.teacherId,
    required super.name,
    required super.email,
    required super.department,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'],
      teacherId: map['teacher_id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
    );
  }
}
