import 'package:attend_event/features/auth/student_auth/domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.registerno,
    required super.year,
    required super.course,
  });

  Map<String, dynamic> tojson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'register_number': registerno,
      'year': year,
      'course': course,
    };
  }

  factory StudentModel.fromjson(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      registerno: map['register_number'] as String,
      year: map['year']?.toString() ?? 'First Year',
      course: map['course']?.toString() ?? 'BCA',
    );
  }
}