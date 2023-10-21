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
    String title = args?['title'] ?? 'Default Title';

    final List<Item> items = [
      Item(
        src: 'https://imgnike-a.akamaihd.net/250x250/027648DD.jpg',
        title: 'Jordan x J Balvin',
        description: 'Casual',
        price: 399.99,
      ),
      Item(
        src: 'https://imgnike-a.akamaihd.net/250x250/025685NX.jpg',
        title: 'Bolsa Transversal Nike Heritage Unissex',
        description: 'Treino & Academia',
        price: 229.99,
      ),
      Item(
        src: 'https://imgnike-a.akamaihd.net/360x360/027173BP.jpg',
        title: 'Camiseta Jordan Paris Saint-Germain Masculina',
        description: 'Casual',
        price: 249.99,
      ),
      Item(
        src: 'https://imgnike-a.akamaihd.net/360x360/0137025B.jpg',
        title: 'Tênis Nike Court Vision Low Next Nature Masculino',
        description: 'Casual',
        price: 539.99,
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
            child: const Text('Add to cart'),
          )
        ],
      ));
}
