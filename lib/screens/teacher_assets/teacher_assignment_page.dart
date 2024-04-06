import 'package:flutter/material.dart';

class TeacherAssignmentPage extends StatelessWidget {
  const TeacherAssignmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploaded Assignments - TE ECS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: assignmentItems.length,
                itemBuilder: (context, index) {
                  return buildAssignmentCard(context, assignmentItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAssignmentCard(BuildContext context, AssignmentItem item) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Icon(Icons.assignment),
          title: Text(item.title),
          subtitle: Text(item.description),
          trailing: ElevatedButton(
            onPressed: () {
              // Handle viewing the uploaded file URL
              // Example: launchURL(item.uploadedFileURL);
            },
            child: const Text('View File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 227, 70, 70),
            ),
          ),
        ));
  }
}

class AssignmentItem {
  final String title;
  final String description;
  final String uploadedFileURL;

  AssignmentItem({
    required this.title,
    required this.description,
    required this.uploadedFileURL,
  });
}

final List<AssignmentItem> assignmentItems = [
  AssignmentItem(
    title: 'Assignment 1',
    description: 'Submitted by Saieeraj',
    uploadedFileURL: 'https://example.com/assignment1.pdf',
  ),
  AssignmentItem(
    title: 'Assignment 2',
    description: 'Submitted by Shantanu',
    uploadedFileURL: 'https://example.com/assignment2.pdf',
  ),
  AssignmentItem(
    title: 'Assignment 3',
    description: 'Submitted by Ishan',
    uploadedFileURL: 'https://example.com/assignment3.pdf',
  ),
];
