import 'package:attend_event/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AuthStudentField extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final IconData? icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  
  const AuthStudentField({
    super.key,
    required this.labeltext,
    required this.controller,
    this.isPassword = false,
    this.obscureText = true,
    this.onTogglePassword,
    this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      decoration: AppTheme.modernInputDecoration(
        labeltext,
        icon: icon,
      ).copyWith(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.primaryColor,
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labeltext';
        }
        if (isPassword && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
