import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart'; // Import Uuid package for generating unique IDs

class TeacherFeedbackPage extends StatelessWidget {
  const TeacherFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FeedbackModule(),
      ),
    );
  }
}

class FeedbackModule extends StatelessWidget {
  const FeedbackModule({Key? key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () async {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              String userId = user.uid;
              String feedbackId = Uuid().v4(); // Generate unique feedback ID
              showDialog(
                context: context,
                builder: (context) =>
                    ReplyDialog(userId: userId, feedbackId: feedbackId),
              );
            } else {
              // Handle user not signed in
            }
          },
          child: const Text(
            'Reply to Feedback',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<DocumentSnapshot> feedbackDocs = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: feedbackDocs.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackDocs[index].get('text');
                    return ListTile(
                      title: Text(
                        feedback,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          const Text('Reply: '),
                          ElevatedButton(
                            onPressed: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                String userId = user.uid;
                                String feedbackId = feedbackDocs[index].id;
                                showDialog(
                                  context: context,
                                  builder: (context) => ReplyDialog(
                                      userId: userId, feedbackId: feedbackId),
                                );
                              } else {
                                // Handle user not signed in
                              }
                            },
                            child: const Text('Reply'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submitReply, // Call submitReply method directly
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
