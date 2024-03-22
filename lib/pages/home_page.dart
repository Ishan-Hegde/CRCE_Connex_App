// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:crce_connex/screens/feedback_section/view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/assignment_section/view.dart';
import 'package:upi_india/upi_india.dart';

// Added import for FeedbackPage

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRCE Connex'),
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
        children: [
          const ProfilePage(),
          const AssignmentPg(),
          PaymentPage(),
          const FeedbackPage(), // Changed to FeedbackPage
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
            _buildDrawerItem(Icons.payment, 'Payment', 2),
            _buildDrawerItem(Icons.feedback, 'Feedback', 3),
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
        'Profile Page',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}



// class PaymentPage extends StatelessWidget {
//   final UpiIndia _upiIndia = UpiIndia();
//
//   Future<UpiResponse> initiateTransaction(UpiApp app) async {
//     return _upiIndia.startTransaction(
//       app: app,
//       receiverUpiId: "9078600498@ybl",
//       receiverName: 'Md Azharuddin',
//       transactionRefId: 'TestingUpiIndiaPlugin',
//       transactionNote: 'Not actual. Just an example.',
//       amount: 1.00,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () async {
//           // Call initiateTransaction method when button is pressed
//           UpiResponse response = await initiateTransaction(UpiApp.googlePay);
//           // Handle response here
//           print(response);
//         },
//         child: Text('Make Payment'),
//       ),
//     );
//   }
// }
class PaymentPage extends StatelessWidget {
  Future<void> initiatePayment() async {
    UpiIndia upiIndia = UpiIndia();
    try {
      UpiResponse response = await upiIndia.startTransaction(
        app: UpiApp.googlePay, // Use your desired UPI app here
        receiverUpiId: 'saieeraj.acharya@okicici', // Replace with the receiver's UPI ID
        receiverName: 'Saieeraj Acharya',
        transactionRefId: 'uniqueTransactionRefId',
        transactionNote: 'Test transaction',
        amount: 60.00, // Replace with the amount to be paid
      );
      // Handle the transaction response
      print(response);
    } catch (e) {
      print('Error initiating transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: initiatePayment,
        child: Text('Make Payment'),
      ),
    );
  }
}