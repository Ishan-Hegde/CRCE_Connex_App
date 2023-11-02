import 'package:flutter/material.dart';

import '../../widgets/header.dart';

class ProfileFormation extends StatefulWidget {
  const ProfileFormation({super.key});

  @override
  ProfileFormationUI createState() => ProfileFormationUI();
}

class ProfileFormationUI extends State<ProfileFormation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        header(context, 'Non Tech Notice'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Colgate Internship drive | TPC',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Oct 2023',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General Mills | TPC',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Nov 2023',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    )));
  }
}
