import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? selectedPurpose;
  String captchaValue = '';
  TextEditingController captchaController = TextEditingController();
  bool captchaVerified = false;
  bool isLoading = false;

  List<String> purposeOptions = [
    'Lorem Ipsum 1',
    'Lorem Ipsum 2',
    'Lorem Ipsum 3',
  ];

  void generateCaptcha() {
    // Generate a random captcha value
    final random = Random();
    const int minAscii = 65; // ASCII value for 'A'
    const int maxAscii = 90; // ASCII value for 'Z'
    const int length = 4; // Captcha length
    String captcha = '';

    for (int i = 0; i < length; i++) {
      int ascii = minAscii + random.nextInt(maxAscii - minAscii + 1);
      captcha += String.fromCharCode(ascii);
    }

    setState(() {
      captchaValue = captcha;
      captchaVerified = false;
    });
  }

  void verifyCaptcha() {
    if (captchaController.text.toUpperCase() == captchaValue) {
      setState(() {
        captchaVerified = true;
        isLoading = true; // Show loader
      });
      initiatePayment();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Incorrect captcha. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> initiatePayment() async {
    // Simulate payment process with a delay
    await Future.delayed(Duration(seconds: 1));

    UpiIndia upiIndia = UpiIndia();
    try {
      UpiResponse response = await upiIndia.startTransaction(
        app: UpiApp.paytm,
        receiverUpiId: 'saieeraj.acharya@okicici',
        receiverName: 'Receiver Name',
        transactionRefId: 'uniqueTransactionRefId',
        transactionNote: selectedPurpose ?? 'Default Transaction Note',
        // Use selectedPurpose or a default value
        amount: double.parse(amountController.text),
      );
      print(response);
    } catch (e) {
      print('Error initiating transaction: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loader after payment process completes
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateCaptcha(); // Generate initial captcha when the widget is initialized
  }

  Future<void> delayedRefresh() async {
    // Simulate a delay of 1 second before refreshing
    await Future.delayed(Duration(seconds: 1));

    // Clear input fields and generate new captcha
    emailController.clear();
    phoneNumberController.clear();
    amountController.clear();
    selectedPurpose = null;
    captchaController.clear();
    generateCaptcha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: delayedRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedPurpose,
                onChanged: (value) {
                  setState(() {
                    selectedPurpose = value;
                  });
                },
                items: purposeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Purpose'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Text('Captcha: $captchaValue'), // Display the captcha value
              const SizedBox(height: 16.0),
              TextField(
                controller: captchaController,
                decoration: const InputDecoration(labelText: 'Verify Captcha'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: captchaVerified ? initiatePayment : verifyCaptcha,
                child:
                    Text(captchaVerified ? 'Make Payment' : 'Verify Captcha'),
              ),
              const SizedBox(height: 16.0),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(), // Show loader if isLoading is true
            ],
          ),
        ),
      ),
    );
  }
}
