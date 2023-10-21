import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../widgets/header.dart';

class App08 extends StatefulWidget {
  const App08({super.key});

  @override
  App08UI createState() => App08UI();
}

class Vacancy {
  String position;
  double salary;
  String description;
  String contact;

  Vacancy({
    required this.position,
    required this.salary,
    required this.description,
    required this.contact,
  });
}

class App08UI extends State<App08> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String title = args?['title'] ?? 'Default Title';

    final List<Vacancy> vacancies = [
      Vacancy(
        position: 'Flutter Developer',
        description: 'Senior Flutter developer for innovative project.',
        salary: 8000,
        contact: 'jobs@bigcompany1.com',
      ),
      Vacancy(
        position: 'Data Engineer',
        description: 'Experience in Big Data and data pipelines.',
        salary: 10000,
        contact: 'careers@bigcompany2.com',
      ),
      Vacancy(
        position: 'UI/UX Designer',
        description: 'Create amazing user experiences for applications.',
        salary: 7000,
        contact: 'design@bigcompany3.com',
      ),
      Vacancy(
        position: 'Cybersecurity Specialist',
        description: 'Protect systems against cyber threats.',
        salary: 12000,
        contact: 'security@bigcompany4.com',
      ),
    ];

    return Scaffold(
        body: SafeArea(
            child: ListView(children: [
      Column(children: [
        header(context, title),
        Column(
            children: vacancies.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Padding(
            padding:
                EdgeInsets.only(bottom: index != vacancies.length - 1 ? 8 : 0),
            child: buildItem(context, item.contact, item.position,
                item.description, item.salary),
          );
        }).toList()),
      ])
    ])));
  }
}

Widget buildItem(BuildContext context, String contact, String position,
    String description, double salary) {
  void onAddToCart() {}

  return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                position,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                contact,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                    .format(salary),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onAddToCart,
                child: const Text('Apply'),
              )
            ],
          ))
        ],
      ));
}
