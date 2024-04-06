import 'package:crce_connex/screens/student_assets/feedback_section/view.dart';
import 'package:crce_connex/screens/teacher_assets/teacher_assignment_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(
    const TeacherApp(),
  );
}

class TeacherApp extends StatelessWidget {
  const TeacherApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeacherHomePage(),
    );
  }
}

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key});

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRCE Connex - Teacher Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ProfilePage(),
          TeacherAssignmentPage(),
          FeedbackModule(),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 30.0, left: 10.0, right: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 64.0,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(34.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildDrawerItem(Icons.person, 'Profile', 0),
            _buildDrawerItem(Icons.assignment, 'Assignments', 1),
            _buildDrawerItem(Icons.feedback, 'Feedback', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:
              _currentIndex == index ? Colors.transparent : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: _currentIndex == index ? Colors.redAccent : Colors.white,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight:
                    _currentIndex == index ? FontWeight.w900 : FontWeight.w400,
                color: _currentIndex == index ? Colors.redAccent : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Teacher Profile Page',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
