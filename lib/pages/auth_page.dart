import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crce_connex/pages/home_page.dart';
import 'package:crce_connex/pages/teacher_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crce_connex/pages/login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            User? user = snapshot.data;
            return FutureBuilder<String?>(
              future: getUserRole(user?.email),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while fetching user role
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.redAccent,
                    ),
                  );
                } else if (roleSnapshot.hasError) {
                  // Handle error while fetching user role
                  return const Center(child: Text('Error fetching user role'));
                } else {
                  String? userRole = roleSnapshot.data;

                  if (userRole == 'student') {
                    return const HomePage(); // Navigate to student home page
                  } else if (userRole == 'teacher') {
                    return const TeacherHomePage(); // Navigate to teacher home page
                  } else {
                    // Handle other roles by showing the login page again
                    return const LoginPage(); // Show the login page again
                  }
                }
              },
            );
          }
          // User is not logged in
          else {
            return const LoginPage();
          }
        },
      ),
    );
  }

  Future<String?> getUserRole(String? email) async {
    if (email == null) return null; // Handle null email

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String? role = querySnapshot.docs.first.get('role');
        if (role == 'teacher') {
          return 'teacher';
        } else if (role == 'student') {
          return 'student';
        }
      } else {
        print('User not found in the database');
      }
    } catch (e) {
      print('Error fetching user role: $e');
    }

    return null; // Default return null if role not found or error occurs
  }
}
