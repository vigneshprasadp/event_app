import 'package:flutter/material.dart';

class AuthStudentButton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const AuthStudentButton({
    super.key,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onpressed, child: Text(text));
  }
}
