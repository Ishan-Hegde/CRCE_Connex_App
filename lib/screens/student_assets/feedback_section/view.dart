import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFeedbackPage extends StatelessWidget {
  const StudentFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Feedback'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String userId = user.uid;
                  // Show feedback dialog and pass userId to submitFeedback
                  showDialog(
                    context: context,
                    builder: (context) => FeedbackDialog(userId: userId),
                  );
                } else {
                  // Handle user not signed in
                }
              },
              child: const Text('Leave Feedback'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedbackHistoryPage(),
                  ),
                );
              },
              child: const Text('Feedback History and Replies'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  final String userId;

  const FeedbackDialog({Key? key, required this.userId}) : super(key: key);

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();

  void submitFeedback(String userId) async {
    String feedback = _feedbackController.text.trim();
    if (mounted && feedback.isNotEmpty) {
      // Check if the widget is mounted
      FirebaseFirestore.instance.collection('feedback').add({
        'text': feedback,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((docRef) {
        if (mounted) {
          // Check again before showing a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback submitted!')),
          );
        }
      }).catchError((error) {
        if (mounted) {
          // Check again before showing a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit feedback. Please try again.'),
            ),
          );
        }
      });
      Navigator.pop(context); // Close the dialog
    } else {
      if (mounted) {
        // Check again before showing a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter feedback.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Input Feedback'),
      content: TextField(
        controller: _feedbackController,
        decoration: const InputDecoration(
          labelText: 'Enter your feedback',
          border: OutlineInputBorder(),
        ),
        maxLines: 5,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            submitFeedback(widget.userId);
          },
          child: const Text('Submit Feedback'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}

class FeedbackHistoryPage extends StatelessWidget {
  const FeedbackHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback History'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .limit(15)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> feedbackDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final feedback = feedbackDocs[index].get('text');
              final data = feedbackDocs[index].data() as Map<String, dynamic>;
              final reply =
                  data.containsKey('reply') ? data['reply'] : 'No reply';
              return ListTile(
                title: Text(
                  'Feedback: $feedback',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Reply: $reply'),
              );
            },
          );
        },
      ),
    );
  }
}
