import 'package:flutter/material.dart';

import '../profile_personal/view.dart';
import '../profile_formation/view.dart';
import '../profile_experience/view.dart';

class App12 extends StatefulWidget {
  const App12({super.key});

  @override
  App12UI createState() => App12UI();
}

class App12UI extends State<App12> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ProfilePersonal(),
      const ProfileFormation(),
      const ProfileExperience(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 70,
        leading: IconButton(
          alignment: Alignment.center,
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _drawer(context),
      body: SafeArea(child: pages[_currentIndex]),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      child: ListView(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 132,
                height: 132,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(132 / 2),
                  child: SizedBox(
                    child: Image.network(
                      'https://avatars.githubusercontent.com/u/56116502?v=4',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Notices',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground)),
              const SizedBox(height: 32),
              ListTile(
                title: Text(
                  'Tech Notice',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Non Tech Notice',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Sports Notice',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
