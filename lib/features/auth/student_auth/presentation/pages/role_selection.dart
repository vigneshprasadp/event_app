import 'package:flutter/material.dart';

class RoleSelection extends StatefulWidget {
  const RoleSelection({super.key});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Select your role...'),
            SizedBox(height: 15.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/splashpage');
              },
              label: Text("login as student"),
              icon: Icon(Icons.school),
            ),
            SizedBox(height: 15.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/teacherlogin');
              },
              label: Text("login as Teacher"),
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
