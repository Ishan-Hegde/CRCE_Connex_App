import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFeedbackPage extends StatelessWidget {
  const StudentFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FeedbackCard(
                icon: Icons.feedback_outlined,
                label: 'Leave Feedback',
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String userId = user.uid;
                    showDialog(
                      context: context,
                      builder: (context) => FeedbackDialog(userId: userId),
                    );
                  } else {
                    // Handle user not signed in
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FeedbackCard(
                icon: Icons.history_edu_outlined,
                label: 'Feedback History and Replies',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackHistoryPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FeedbackCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Color(0xFFB6002B),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increased padding for spacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white, // White icon color
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white, // White font color
                ),
              ),
            ],
          ),
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
        backgroundColor: Color(0xFFB6002B),
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

void main() {
  runApp(MaterialApp(
    home: StudentFeedbackPage(),
  ));
}
