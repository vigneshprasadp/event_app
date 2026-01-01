import '../../domain/entities/teacher.dart';

class TeacherModel extends Teacher {
  TeacherModel({
    required super.id,
    required super.teacherId,
    required super.name,
    required super.email,
    required super.department,
    super.coursesTaught,
    super.yearsTaught,
    super.subjectsTaught,
    super.isHomeroomTeacher,
    super.homeroomCourse,
    super.homeroomYear,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'],
      teacherId: map['teacher_id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
      coursesTaught: (map['courses_taught'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      yearsTaught: (map['years_taught'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      subjectsTaught: (map['subjects_taught'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isHomeroomTeacher: map['is_homeroom_teacher'] ?? false,
      homeroomCourse: map['homeroom_course'],
      homeroomYear: map['homeroom_year'],
    );
  }
}
