// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import '../../widgets/header.dart';

class CatAssignment extends StatefulWidget {
  const CatAssignment({Key? key});

  @override
  CatAssignmentUI createState() => CatAssignmentUI();
}

class Item {
  String src;
  String title;
  String description;
  int progress;

  Item({
    required this.src,
    required this.title,
    required this.description,
    required this.progress,
  });
}

class CatAssignmentUI extends State<CatAssignment> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    String title = args?['title'] ?? 'Assignments';

    final List<Item> items = [
      Item(
        src: 'https://placekitten.com/200/300',
        title: 'Assignment 1',
        description: 'Pending',
        progress: 50,
      ),
      Item(
        src: 'https://placekitten.com/201/301',
        title: 'Assignment 2',
        description: 'Pending',
        progress: 12,
      ),
      Item(
        src: 'https://placekitten.com/202/302',
        title: 'Assignment 3',
        description: 'Completed',
        progress: 100,
      ),
      Item(
        src: 'https://placekitten.com/203/303',
        title: 'Assignment 4',
        description: 'Pending',
        progress: 25,
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
                          right: index != items.length - 1 ? 20 : 0),
                      child: buildItem(context, item),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Item item) {
    return Container(
      width: 175,
      height: 285,
      // Adjusted the height
      margin: const EdgeInsets.only(bottom: 10),
      // Added margin to the top
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.network(
                item.src,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '${item.progress}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: item.progress / 100,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Your custom action when the button is pressed
              print('Mark as Done button pressed for ${item.title}');
            },
            child: const Text('Mark as Done'),
          ),
        ],
      ),
    );
  }
}
