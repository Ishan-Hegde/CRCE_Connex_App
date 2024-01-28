import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../widgets/header.dart';
import '../../widgets/input.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/slider.dart';

class App10 extends StatefulWidget {
  const App10({Key? key}) : super(key: key);

  @override
  App10UI createState() => App10UI();
}

class App10UI extends State<App10> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedScholarship = 'Elementary School';
  double _accountLimit = 200;
  bool _isBrazilian = true;

  String _inputNameResult = '-';
  String _inputAgeResult = '-';
  String _selectedGenderResult = '-';
  String _selectedScholarshipResult = '-';
  double _accountLimitResult = 0;
  bool _isBrazilianResult = false;

  final List<String> _genders = ['Male', 'Female'];

  final List<String> _scholarship = [
    'Elementary School',
    'High School',
    'Undergraduate Studies',
    'Graduate Studies',
    'Master\'s Degree',
    'Doctorate'
  ];

  void print() {
    setState(() {
      _inputNameResult = _nameController.text;
      _inputAgeResult = _ageController.text;
      _selectedGenderResult = _selectedGender;
      _selectedScholarshipResult = _selectedScholarship;
      _accountLimitResult = _accountLimit;
      _isBrazilianResult = _isBrazilian;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String title = args?['title'] ?? 'Default Title';

    return Scaffold(
        body: SafeArea(
            child: ListView(
      children: [
        Column(
          children: [
            header(context, title),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      items: _scholarship
                          .map((scholarship) => scholarship)
                          .toList(),
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
                                  color:
                                      Theme.of(context).colorScheme.primary)),
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
                        onPressed: print,
                        child: const Text('Create'),
                      ),
                    )
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
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _inputNameResult,
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
                      'Age',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _inputAgeResult,
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
                      'Gender',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _selectedGenderResult,
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
                      'Scholarship',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _selectedScholarshipResult,
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
                      'Account limit',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                          .format(_accountLimitResult),
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
                      'Brazilian',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _isBrazilianResult ? 'Yes' : 'No',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                )
              ]),
            ),
          ],
        )
      ],
    )));
  }
}
