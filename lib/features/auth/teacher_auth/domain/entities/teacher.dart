class Teacher {
  final String id;
  final String teacherId;
  final String name;
  final String? email;
  final String? department;
  final String? password;
  
  // Enhanced Fields
  final List<String> coursesTaught;
  final List<String> yearsTaught;
  final List<String> subjectsTaught;
  
  final bool isHomeroomTeacher;
  final String? homeroomCourse;
  final String? homeroomYear;

  Teacher({
    required this.id,
    required this.teacherId,
    required this.name,
    this.email,
    this.department,
    this.password,
    this.coursesTaught = const [],
    this.yearsTaught = const [],
    this.subjectsTaught = const [],
    this.isHomeroomTeacher = false,
    this.homeroomCourse,
    this.homeroomYear,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Teacher',
      email: json['email']?.toString(),
      department: json['department']?.toString(),
      password: json['password']?.toString(),
      
      coursesTaught: (json['courses_taught'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      yearsTaught: (json['years_taught'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
      subjectsTaught: (json['subjects_taught'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [],
              
      isHomeroomTeacher: json['is_homeroom_teacher'] ?? false,
      homeroomCourse: json['homeroom_course']?.toString(),
      homeroomYear: json['homeroom_year']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'name': name,
      'email': email,
      'department': department,
      'password': password,
      'courses_taught': coursesTaught,
      'years_taught': yearsTaught,
      'subjects_taught': subjectsTaught,
      'is_homeroom_teacher': isHomeroomTeacher,
      'homeroom_course': homeroomCourse,
      'homeroom_year': homeroomYear,
    };
  }
}
