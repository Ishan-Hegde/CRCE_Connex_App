import 'package:flutter/material.dart';

import '../profile_personal/view.dart';
import '../profile_formation/view.dart';
import '../profile_experience/view.dart';

class App13 extends StatefulWidget {
  const App13({Key? key}) : super(key: key);

  @override
  App13State createState() => App13State();
}

class App13State extends State<App13> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfilePersonal(),
    const ProfileFormation(),
    const ProfileExperience(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Formation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Experience',
          ),
        ],
      ),
    );
  }
}
