import 'dart:ui';

import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../widgets/input.dart';

class App04 extends StatefulWidget {
  const App04({super.key});

  @override
  App04UI createState() => App04UI();
}

class App04UI extends State<App04> {
  final TextEditingController _ethanolController = TextEditingController();
  final TextEditingController _gasolineController = TextEditingController();
  String _result = '-';

  void _calculate() {
    if (_ethanolController.text.isEmpty || _gasolineController.text.isEmpty) {
      setState(() {
        _result = 'Please, fill both fields';
      });
      return;
    }

    double ethanolPrice = double.tryParse(_ethanolController.text) ?? 0.0;
    double gasolinePrice = double.tryParse(_gasolineController.text) ?? 0.0;
    double ratio = ethanolPrice / gasolinePrice;

    setState(() {
      if (ratio <= 0.7) {
        _result = 'Ethanol is cheaper!';
      } else {
        _result = 'Gasoline is cheaper!';
      }
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
                    'https://s2.glbimg.com/fLLjtcmosminFpbQVwWjJ6qEdNU=/512x320/smart/e.glbimg.com/og/ed/f/original/2015/09/10/ads_macgyver1.jpg',
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
                  controller: _ethanolController,
                  labelText: 'Ethanol price (L)',
                  hintText: 'Ethanol price by liter',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              Input(
                  controller: _gasolineController,
                  labelText: 'Gasoline price (L)',
                  hintText: 'Gasoline price by liter',
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculate,
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
