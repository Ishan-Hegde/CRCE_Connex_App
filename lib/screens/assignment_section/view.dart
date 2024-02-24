import 'package:flutter/material.dart';

import '../../widgets/header.dart';

class AssignmentPg extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AssignmentPg({Key? key});

  @override
  AssignmentUI createState() => AssignmentUI();
}

class Item {
  IconData icon;
  String title;
  String description;
  int _progress; // Use private variable for progress
  late Function(int) onProgressChanged; // Callback function for progress change
  bool isDone = false; // Variable to track if item is done

  Item({
    required this.icon,
    required this.title,
    required this.description,
    required int progress,
  }) : _progress = progress;

  // Getter method for progress
  int get progress => _progress;

  // Setter method for progress
  setProgress(int value) {
    if (value >= 0 && value <= 100) {
      _progress = value;
      onProgressChanged(value); // Call the callback function when progress changes
    }
  }
}

class AssignmentUI extends State<AssignmentPg> {
  final List<Item> items = [
    Item(
      icon: Icons.assignment,
      title: 'Assignment 1',
      description: 'Pending',
      progress: 0,
    ),
    Item(
      icon: Icons.assignment,
      title: 'Assignment 2',
      description: 'Pending',
      progress: 0,
    ),
    Item(
      icon: Icons.assignment_turned_in_outlined,
      title: 'Assignment 3',
      description: 'Completed',
      progress: 100,
    ),
    Item(
      icon: Icons.assignment,
      title: 'Assignment 4',
      description: 'Pending',
      progress: 0,
    ),
    Item(
      icon: Icons.assignment,
      title: 'Assignment 5',
      description: 'Pending',
      progress: 0,
    ),
    Item(
      icon: Icons.assignment_turned_in_outlined,
      title: 'Assignment 6',
      description: 'Completed',
      progress: 100,
    ),
    Item(
      icon: Icons.assignment,
      title: 'Assignment 7',
      description: 'Pending',
      progress: 0,
    ),
    Item(
      icon: Icons.assignment,
      title: 'Assignment 8',
      description: 'Pending',
      progress: 0,
    ),
  ];

  bool showOnlyChecked = false; // Variable to track whether to show only checked assignments

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    String title = args?['title'] ?? 'Assignments';

    // Filter items based on showOnlyChecked
    List<Item> filteredItems = showOnlyChecked
        ? items.where((item) => item.isDone).toList()
        : items;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(context, title),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showOnlyChecked = !showOnlyChecked; // Toggle showOnlyChecked
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Background color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Rounded border
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showOnlyChecked ? 'Show All' : 'Show Checked',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        showOnlyChecked ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.71,
                ),
                itemCount: filteredItems.length, // Use filteredItems.length
                itemBuilder: (context, index) {
                  return buildItem(context, filteredItems[index]); // Use filteredItems
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Item item) {
    return Container(
      margin: const EdgeInsets.all(12),
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
          Icon(
            item.icon,
            size: 60,
            color: const Color(0xFFE57575),
          ),
          const SizedBox(height: 10),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFE57575),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: item.progress / 100,
                  backgroundColor: const Color(0xFFE57575).withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE57575),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Your custom action when the button is pressed
                  // ignore: avoid_print
                  print('Upload button pressed for ${item.title}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE57575),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    item.isDone = !item.isDone; // Toggle isDone on tap
                  });
                },
                child: Stack(
                  children: [
                    const Icon(
                      Icons.check_box_outline_blank,
                      size: 40,
                      color: Colors.grey,
                    ),
                    if (item.isDone)
                      const Positioned(
                        top: 3,
                        left: 3,
                        child: Icon(
                          Icons.check,
                          size: 34,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
