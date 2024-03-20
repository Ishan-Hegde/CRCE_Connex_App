// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const FeedbackWidget(),
    );
  }
}

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({Key? key});

  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();
  bool isTeacher = true; // Set to false for student view

  List<String> feedbackList = [
    'Great work!',
    'Could use some improvements.',
    'Very informative.',
  ];

  List<String> replyList = [
    'Thank you!',
    'Noted, we will work on it.',
    'Glad you found it useful!',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isTeacher)
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Feedback (for students)',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          if (!isTeacher) const SizedBox(height: 16.0),
          if (!isTeacher)
            ElevatedButton(
              onPressed: () {
                // Handle feedback submission
                String feedback = _feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  // Process feedback submission (e.g., send to backend)
                  // You can add your logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback submitted!')),
                  );
                  _feedbackController.clear();
                  setState(() {
                    feedbackList.add(feedback);
                    replyList.add(''); // Initialize with an empty reply
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter feedback.')),
                  );
                }
              },
              child: const Text('Submit Feedback'),
            ),
          const SizedBox(height: 32.0),
          if (isTeacher)
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(feedbackList[index]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Reply: ${replyList[index]}'),
                        const Divider(),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showReplyDialog(context, index);
                      },
                      child: const Text('Reply'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to Feedback'),
          content: TextField(
            controller: _replyController,
            decoration: const InputDecoration(
              labelText: 'Enter your reply',
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
              onPressed: () {
                String reply = _replyController.text.trim();
                if (reply.isNotEmpty) {
                  setState(() {
                    replyList[index] = reply;
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reply.')),
                  );
                }
              },
              child: const Text('Send Reply'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _replyController.dispose();
    super.dispose();
  }
}
