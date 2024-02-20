import 'package:flutter/material.dart';
import 'package:crce_connex/components/my_button.dart';
import 'package:crce_connex/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { student, teacher }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool isTeacherLogin;
  late UserRole selectedRole;

  @override
  void initState() {
    super.initState();
    isTeacherLogin = false;
    selectedRole = UserRole.student; // Default to student role
  }

  void signUserIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showEmptyFieldsAlert();
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Assuming you have a database where user roles are stored
      UserRole userRole = await getUserRole(emailController.text);

      if (userRole == selectedRole) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        Navigator.pop(context);
      } else {
        // Show error message if user's role does not match selected role
        Navigator.pop(context);
        showRoleMismatchAlert();
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }
  }

  Future<UserRole> getUserRole(String email) async {
    // Implement your logic to retrieve user role from database based on email
    // This is a placeholder function, you should replace it with actual logic
    // For example, querying a Firestore database
    // You might need to adjust this based on your database structure
    return UserRole.student; // Placeholder return value
  }

  void showEmptyFieldsAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Empty Fields'),
          content: const Text('Please fill in both email and password fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Incorrect Email"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Incorrect Password"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showRoleMismatchAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Role Mismatch"),
          content: Text("You are not authorized to log in as a ${selectedRole.toString().split('.').last}."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Icon(
                  Icons.menu_book,
                  size: 110,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email ID',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: forgotPasswordAlert,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600],decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = UserRole.student;
                        });
                      },
                      child: _buildLoginTypeButton('Student', selectedRole == UserRole.student),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = UserRole.teacher;
                        });
                      },
                      child: _buildLoginTypeButton('Teacher', selectedRole == UserRole.teacher),
                    ),
                  ],
                ),
                const SizedBox(height: 45),
                MyButton(
                  onTap: signUserIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTypeButton(String type, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        type,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  void forgotPasswordAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Forgot Password?"),
          content: const Text("Please contact admin for password reset."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
