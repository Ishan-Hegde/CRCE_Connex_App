import 'package:flutter/material.dart';

import '../profile_personal/view.dart';
import '../profile_formation/view.dart';
import '../profile_experience/view.dart';

class App14 extends StatelessWidget {
  const App14({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Tech Notice'),
              Tab(icon: Icon(Icons.school), text: 'Non Tech Notice'),
              Tab(icon: Icon(Icons.work), text: 'Sports Notice'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProfilePersonal(),
            ProfileFormation(),
            ProfileExperience(),
          ],
        ),
      ),
    );
  }
}
