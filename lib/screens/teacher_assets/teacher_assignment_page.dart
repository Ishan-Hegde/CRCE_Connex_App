import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAssignmentPage extends StatefulWidget {
  const TeacherAssignmentPage({Key? key}) : super(key: key);

  @override
  _TeacherAssignmentPageState createState() => _TeacherAssignmentPageState();
}

class _TeacherAssignmentPageState extends State<TeacherAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Uploaded Assignments - TE ECS',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('assignments')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final List<AssignmentItem> assignmentItems = snapshot
                      .data!.docs
                      .map((doc) => AssignmentItem.fromSnapshot(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: assignmentItems.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<String>(
                        future: getStudentEmail(assignmentItems[index].userId),
                        builder: (context, emailSnapshot) {
                          if (emailSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox
                                .shrink(); // Return an empty SizedBox while waiting for the email
                          }
                          if (emailSnapshot.hasError) {
                            return Text(
                                'Error fetching email: ${emailSnapshot.error}');
                          }
                          final studentEmail = emailSnapshot.data ?? 'Unknown';
                          return buildAssignmentCard(
                            context,
                            assignmentItems[index],
                            studentEmail,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getStudentEmail(String userId) async {
    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final email = userSnapshot.get('email');
        if (email != null) {
          return email.toString(); // Convert email to string
        } else {
          print('Error: Email field is null for user ID $userId');
          return 'Unknown';
        }
      } else {
        print('Error: User document not found for user ID $userId');
        return 'User not found';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Unknown';
    }
  }

  Widget buildAssignmentCard(
      BuildContext context, AssignmentItem item, String studentEmail) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        leading: Icon(Icons.assignment),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Email:\n$studentEmail',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Uploaded File: ${item.title}'),
            SizedBox(height: 8),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle viewing the uploaded file URL
            // Example: launchURL(item.uploadedFileURL);
          },
          child: const Text('View File'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB6002B),
          ),
        ),
      ),
    );
  }
}

class AssignmentItem {
  final String title;
  final String userId; // Assuming userId is available in your assignment item
  final String uploadedFileName;

  AssignmentItem({
    required this.title,
    required this.userId,
    required this.uploadedFileName,
  });

  factory AssignmentItem.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AssignmentItem(
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      uploadedFileName: data['uploadedFileName'] ?? '',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TeacherAssignmentPage(),
  ));
}
