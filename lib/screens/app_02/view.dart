import 'package:flutter/material.dart';
import '../../widgets/header.dart';

class App02 extends StatefulWidget {
  const App02({super.key});

  @override
  App02UI createState() => App02UI();
}

class App02UI extends State<App02> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    if (_counter > 0) {
      setState(() {
        _counter--;
      });
    }
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
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface),
            child: Text(
              '$_counter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _decrementCounter,
                child: const Text('-', style: TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('+', style: TextStyle(fontSize: 32)),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
