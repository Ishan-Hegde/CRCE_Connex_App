import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../widgets/input.dart';

class App03 extends StatefulWidget {
  const App03({super.key});

  @override
  App03UI createState() => App03UI();
}

class App03UI extends State<App03> {
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();
  String _result = '-';

  void _calculateMultiplication() {
    if (_firstNumberController.text.isEmpty ||
        _secondNumberController.text.isEmpty) {
      setState(() {
        _result = 'Please, fill both fields';
      });
      return;
    }

    int firstNumber = int.tryParse(_firstNumberController.text) ?? 1;
    int secondNumber = int.tryParse(_secondNumberController.text) ?? 1;

    int multiplicationResult = firstNumber * secondNumber;

    setState(() {
      _result = '$firstNumber x $secondNumber = $multiplicationResult';
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Input(
                  controller: _firstNumberController,
                  labelText: 'First number',
                  hintText: 'The first number to be multiplied',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Input(
                  controller: _secondNumberController,
                  labelText: 'Second number',
                  hintText: 'The second number to be multiplied',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculateMultiplication,
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
