import 'package:flutter/material.dart';

class AuthStudentField extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  const AuthStudentField({
    super.key,
    required this.labeltext,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labeltext),
      validator: (value) {
        if (value!.isEmpty) {
          return "$value is empty";
        } else {
          return null;
        }
      },
    );
  }
}
