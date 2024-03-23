// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  List<String> feedbackList = [];
  List<String> replyList = [];

  void submitFeedback() {
    String feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
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
  }

  void showReplyDialog(int index) {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            // Show input feedback module
            showDialog(
              context: context,
              builder: (context) {
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
                        submitFeedback();
                        Navigator.pop(context);
                      },
                      child: const Text('Submit Feedback'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE57575),
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Leave Feedback',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: () {
            // Show previously sent messages module
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Feedback History'),
                  content: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: feedbackList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            feedbackList[index],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Reply: ${replyList[index]}'),
                        );
                      },
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE57575)),
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE57575),
            textStyle: const TextStyle(fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'View Feedback History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _replyController.dispose();
    super.dispose();
  }
}