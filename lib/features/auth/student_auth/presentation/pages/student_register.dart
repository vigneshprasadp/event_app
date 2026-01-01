import 'package:attend_event/core/theme/app_theme.dart';
import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_button.dart';
import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_field.dart';
import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
import 'package:attend_event/features/auth/student_auth/presentation/pages/student_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({super.key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final nmcontroller = TextEditingController();
  final emcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  final phcontroller = TextEditingController();
  final regnocontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  String? _selectedYear;
  String? _selectedCourse;
  bool obscurePassword = true;

  void register() {
    if (formkey.currentState!.validate()) {
      context.read<StudentAuthCubit>().signup(
        name: nmcontroller.text.trim(),
        email: emcontroller.text.trim(),
        password: passcontroller.text.trim(),
        phone: phcontroller.text.trim(),
        registerno: regnocontroller.text.trim(),
        year: _selectedYear!,
        course: _selectedCourse!,
      );
    }
  }

  @override
  void dispose() {
    nmcontroller.dispose();
    emcontroller.dispose();
    passcontroller.dispose();
    phcontroller.dispose();
    regnocontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is StudentAuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => StudentHomepage(student: state.student),
            ),
          );
        } else if (state is StudentAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is StudentAuthLoading;
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            child: SafeArea(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    // Back Button and Title
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Form Card
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              AuthStudentField(
                                labeltext: 'Full Name',
                                controller: nmcontroller,
                                icon: Icons.person,
                              ),
                              SizedBox(height: 20),
                              AuthStudentField(
                                labeltext: 'Email',
                                controller: emcontroller,
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              AuthStudentField(
                                labeltext: 'Phone Number',
                                controller: phcontroller,
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (value.length < 10) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              AuthStudentField(
                                labeltext: 'Registration Number',
                                controller: regnocontroller,
                                icon: Icons.badge,
                              ),
                              SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                value: _selectedCourse,
                                decoration: InputDecoration(
                                  labelText: 'Select Course',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.class_outlined),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: ['BCA', 'BBA', 'BCom', 'BSc', 'BA']
                                    .map((course) => DropdownMenuItem(
                                          value: course,
                                          child: Text(course),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _selectedCourse = value),
                                validator: (value) => value == null ? 'Please select your course' : null,
                              ),
                              SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                value: _selectedYear,
                                decoration: InputDecoration(
                                  labelText: 'Select Year',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.school_outlined),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                ),
                                items: ['First Year', 'Second Year', 'Third Year']
                                    .map((year) => DropdownMenuItem(
                                          value: year,
                                          child: Text(year),
                                        ))
                                    .toList(),
                                onChanged: (value) => setState(() => _selectedYear = value),
                                validator: (value) => value == null ? 'Please select your year' : null,
                              ),
                              SizedBox(height: 20),
                              AuthStudentField(
                                labeltext: 'Password',
                                controller: passcontroller,
                                isPassword: true,
                                obscureText: obscurePassword,
                                onTogglePassword: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                                icon: Icons.lock,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 32),
                              AuthStudentButton(
                                text: 'Create Account',
                                onpressed: register,
                                isLoading: isLoading,
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
