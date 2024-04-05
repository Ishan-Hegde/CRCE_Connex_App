import 'package:flutter/material.dart';

class TeacherSpecificPage extends StatelessWidget {
  const TeacherSpecificPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Details'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Teacher!',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your teacher-specific functionality here
              },
              child: const Text('Teacher Action'),
            ),
          ],
        ),
      ),
    );
  }
}
