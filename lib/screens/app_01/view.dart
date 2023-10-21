import 'package:flutter/material.dart';
import '../../widgets/header.dart';

class App01 extends StatelessWidget {
  const App01({super.key, Key? app01});

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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surface),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    "Name: Ishan Hegde \nRoll Number: 9477 \nYear: TE ECS",
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ))
        ],
      )),
    );
  }
}
