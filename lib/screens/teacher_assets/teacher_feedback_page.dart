import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:uuid/uuid.dart'; // Import Uuid package for generating unique IDs

class TeacherFeedbackPage extends StatelessWidget {
  const TeacherFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FeedbackModule(),
      ),
    );
  }
}

class FeedbackModule extends StatefulWidget {
  const FeedbackModule({Key? key});

  @override
  _FeedbackModuleState createState() => _FeedbackModuleState();
}

class _FeedbackModuleState extends State<FeedbackModule> {
  List<Map<String, dynamic>> feedbackDocs = [];

  @override
  void initState() {
    super.initState();
    loadFeedbackData();
  }

  Future<void> loadFeedbackData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('feedback').get();
    setState(() {
      feedbackDocs = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'text': doc.get('text'),
                'userId': doc.get('userId'),
                'userEmail': '', // Placeholder for user email
              })
          .toList();
    });
    // Fetch and update user emails
    await fetchUserEmails();
  }

  Future<void> fetchUserEmails() async {
    for (var feedback in feedbackDocs) {
      String userId = feedback['userId'];
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        feedback['userEmail'] = userDoc.get('email');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final feedback = feedbackDocs[index]['text'];
              final userEmail = feedbackDocs[index]['userEmail'];
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User: $userEmail',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Color for user info
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Feedback: $feedback',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Text('Reply: '),
                    ElevatedButton(
                      onPressed: () async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          String userId = user.uid;
                          String feedbackId = feedbackDocs[index]['id'];
                          showDialog(
                            context: context,
                            builder: (context) => ReplyDialog(
                                userId: userId, feedbackId: feedbackId),
                          );
                        } else {
                          // Handle user not signed in
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFB6002B), // Changed button color
                      ),
                      child: const Text('Reply'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ReplyDialog extends StatefulWidget {
  final String userId;
  final String feedbackId;

  const ReplyDialog({Key? key, required this.userId, required this.feedbackId})
      : super(key: key);

  @override
  _ReplyDialogState createState() => _ReplyDialogState();
}

class _ReplyDialogState extends State<ReplyDialog> {
  final TextEditingController _replyController = TextEditingController();

  void submitReply() async {
    if (!mounted) {
      return; // Exit if the widget is not mounted
    }

    String reply = _replyController.text.trim();
    if (reply.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('feedback')
            .doc(widget.feedbackId)
            .update({
          'reply': reply,
          'userId': widget.userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reply submitted!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit reply. Please try again.')),
        );
      }
      Navigator.pop(context); // Close the dialog
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reply.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reply to Feedback'),
      content: TextField(
        controller: _replyController,
        decoration: const InputDecoration(
          labelText: 'Enter your reply',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel',
              style: TextStyle(color: Color(0xFFB6002B))), // Changed text color
        ),
        ElevatedButton(
          onPressed: submitReply, // Call submitReply method directly
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB6002B), // Changed button color
          ),
          child: const Text('Send Reply'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: TeacherFeedbackPage(),
  ));
}
