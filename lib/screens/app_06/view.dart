import 'dart:math';

import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../widgets/input.dart';

class App06 extends StatefulWidget {
  const App06({super.key});

  @override
  App06UI createState() => App06UI();
}

class App06UI extends State<App06> {
  final TextEditingController _randomNumberController = TextEditingController();
  String _result = '-';

  void _calculate() {
    if (_randomNumberController.text.isEmpty) {
      setState(() {
        _result = 'Please, fill the field';
      });
      return;
    }

    int randomNumber = int.tryParse(_randomNumberController.text) ?? 0;
    int generatedRandomNumber = Random().nextInt(11);

    if (randomNumber == generatedRandomNumber) {
      setState(() {
        _result = 'Well done! You got it right';
      });
    } else {
      setState(() {
        _result = 'It was $generatedRandomNumber, try again!';
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
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.network(
                    'https://live.staticflickr.com/65535/53121697601_678d04368f_z.jpg',
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
                  controller: _randomNumberController,
                  labelText: 'Get the number right',
                  hintText: 'Choose a number from 0 to 10',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('Find out'),
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
