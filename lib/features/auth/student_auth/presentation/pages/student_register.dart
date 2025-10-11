import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_button.dart';
import 'package:attend_event/features/auth/student_auth/presentation/components/auth_student_field.dart';
import 'package:attend_event/features/auth/student_auth/presentation/cubit/student_auth_cubit.dart';
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

  void register() {
    if (formkey.currentState!.validate()) {
      context.read<StudentAuthCubit>().signup(
        name: nmcontroller.text.trim(),
        email: emcontroller.text.trim(),
        password: passcontroller.text.trim(),
        phone: phcontroller.text.trim(),
        registerno: regnocontroller.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentAuthCubit, StudentAuthState>(
      listener: (context, state) {
        if (state is StudentAuthSuccess) {
          Navigator.pushReplacementNamed(context, '/studenthome');
        } else if (state is StudentAuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is StudentAuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(title: Text('Student-register'), centerTitle: true),
          body: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthStudentField(labeltext: 'Name', controller: nmcontroller),
                SizedBox(height: 15.0),
                AuthStudentField(labeltext: 'Email', controller: emcontroller),
                SizedBox(height: 15.0),
                AuthStudentField(labeltext: 'Phone', controller: phcontroller),
                SizedBox(height: 15.0),
                AuthStudentField(
                  labeltext: 'Register-no',
                  controller: regnocontroller,
                ),
                SizedBox(height: 15.0),
                AuthStudentField(
                  labeltext: 'Password',
                  controller: passcontroller,
                ),
                SizedBox(height: 20.0),
                AuthStudentButton(
                  text: 'Register',
                  onpressed: () {
                    register();
                  },
                ),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Already have an account?.. Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
