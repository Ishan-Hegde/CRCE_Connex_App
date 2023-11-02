import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../widgets/header.dart';

class App07 extends StatefulWidget {
  const App07({super.key});

  @override
  App07UI createState() => App07UI();
}

class Item {
  String src;
  String title;
  String description;
  double price;

  Item({
    required this.src,
    required this.title,
    required this.description,
    required this.price,
  });
}

class App07UI extends State<App07> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String title = args?['title'] ?? 'Assignments';

    final List<Item> items = [
      Item(
        src:
            'https://media.licdn.com/dms/image/C4E0BAQFfYevcaYPy6A/company-logo_200_200/0/1630612004940/fr_conceicao_rodrigues_college_of_engineering_logo?e=1706745600&v=beta&t=-z6t3X2S2PVwnpmIjAh7JZdvTNR46c9jAQJDNmBWRas',
        title: 'SE Assign 2',
        description: 'Pending',
        price: 0,
      ),
      Item(
        src:
            'https://media.licdn.com/dms/image/C4E0BAQFfYevcaYPy6A/company-logo_200_200/0/1630612004940/fr_conceicao_rodrigues_college_of_engineering_logo?e=1706745600&v=beta&t=-z6t3X2S2PVwnpmIjAh7JZdvTNR46c9jAQJDNmBWRas',
        title: 'CE Assign 2',
        description: 'Pending',
        price: 0,
      ),
      Item(
        src:
            'https://media.licdn.com/dms/image/C4E0BAQFfYevcaYPy6A/company-logo_200_200/0/1630612004940/fr_conceicao_rodrigues_college_of_engineering_logo?e=1706745600&v=beta&t=-z6t3X2S2PVwnpmIjAh7JZdvTNR46c9jAQJDNmBWRas',
        title: 'WT Assign',
        description: 'Completed',
        price: 0,
      ),
      Item(
        src:
            'https://media.licdn.com/dms/image/C4E0BAQFfYevcaYPy6A/company-logo_200_200/0/1630612004940/fr_conceicao_rodrigues_college_of_engineering_logo?e=1706745600&v=beta&t=-z6t3X2S2PVwnpmIjAh7JZdvTNR46c9jAQJDNmBWRas',
        title: 'PCE Skit',
        description: 'Pending',
        price: 0,
      ),
    ];

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          header(context, title),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(
                        right: index != items.length - 1 ? 8 : 0),
                    child: buildItem(context, item.src, item.title,
                        item.description, item.price),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      )),
    );
  }
}

Widget buildItem(BuildContext context, String src, String title,
    String description, double price) {
  void onAddToCart() {}

  return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                src,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
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
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(price),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onAddToCart,
            child: const Text('Mark as Done'),
          )
        ],
      ));
}
