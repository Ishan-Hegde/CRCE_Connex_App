import 'dart:ui';

import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../widgets/input.dart';

class App05 extends StatefulWidget {
  const App05({super.key});

  @override
  App05UI createState() => App05UI();
}

class App05UI extends State<App05> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _result = '-';

  void _calculateBMI() {
    if (_heightController.text.isEmpty || _weightController.text.isEmpty) {
      setState(() {
        _result = 'Please, fill both fields';
      });
      return;
    }

    double height = double.tryParse(_heightController.text) ?? 0.0;
    double weight = double.tryParse(_weightController.text) ?? 0.0;

    height = height / 100;

    double bmi = weight / (height * height);

    String classification = '';

    if (bmi < 18.5) {
      classification = 'Underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      classification = 'Normal Weight';
    } else if (bmi >= 25 && bmi <= 29.9) {
      classification = 'Overweight';
    } else if (bmi >= 30 && bmi <= 34.9) {
      classification = 'Obesity Class I';
    } else if (bmi >= 35 && bmi <= 39.9) {
      classification = 'Obesity Class II';
    } else {
      classification = 'Obesity Class III (Morbid Obesity)';
    }

    setState(() {
      _result = '${bmi.toStringAsFixed(2)} - $classification';
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String title = args?['title'] ?? 'Default Title';

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          header(context, title),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.network(
                    'https://a.espncdn.com/photo/2023/0714/r1197560_1296x729_16-9.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Input(
                  controller: _heightController,
                  labelText: 'Height (CM)',
                  hintText: 'Fill in your height',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Input(
                  controller: _weightController,
                  labelText: 'Weight (KG)',
                  hintText: 'Fill in your weight',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateBMI,
                child: const Text('Calculate'),
              ),
            ]),
          ),
          const SizedBox(height: 40),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface),
            child: Text(
              _result,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
