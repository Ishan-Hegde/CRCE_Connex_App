import 'package:flutter/material.dart';

import '../app_11_result/view.dart';

import '../../widgets/header.dart';
import '../../widgets/input.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/slider.dart';

class App11 extends StatefulWidget {
  const App11({Key? key}) : super(key: key);

  @override
  App11UI createState() => App11UI();
}

class App11UI extends State<App11> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedScholarship = 'Elementary School';
  double _accountLimit = 200;
  bool _isBrazilian = true;

  final List<String> _genders = ['Male', 'Female'];

  final List<String> _scholarship = [
    'Elementary School',
    'High School',
    'Undergraduate Studies',
    'Graduate Studies',
    'Master\'s Degree',
    'Doctorate'
  ];

  void onCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return App11Result(
              name: _nameController.text,
              age: _ageController.text,
              gender: _selectedGender,
              scholarship: _selectedScholarship,
              accountLimit: _accountLimit,
              isBrazilian: _isBrazilian ? 'Yes' : 'No');
        },
      ),
    );
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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Input(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'What is your name?',
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            Input(
                controller: _ageController,
                labelText: 'Age',
                hintText: 'How old are you?',
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            Dropdown<String>(
              labelText: 'Gender',
              value: _selectedGender,
              items: _genders.map((gender) => gender).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            Dropdown<String>(
              labelText: 'Scholarship',
              value: _selectedScholarship,
              items: _scholarship.map((scholarship) => scholarship).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedScholarship = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            TheSlider(
              label: 'Limit',
              value: _accountLimit,
              max: 500,
              onChanged: (newValue) {
                setState(() {
                  _accountLimit = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Brazilian?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 4),
                  Switch(
                    value: _isBrazilian,
                    onChanged: (value) {
                      setState(() {
                        _isBrazilian = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onCreate,
                child: const Text('Create'),
              ),
            )
          ]),
        ),
      ],
    )));
  }
}
