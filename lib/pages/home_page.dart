// ignore_for_file: use_key_in_widget_constructors, avoid_print, avoid_print, duplicate_ignore, library_private_types_in_public_api

import 'package:crce_connex/screens/app_07/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackForm {
  String subject;
  String feedback;

  FeedbackForm({
    required this.subject,
    required this.feedback,
  });
}

final kFirstDay = DateTime(2000, 1, 1);
final kLastDay = DateTime(2050, 12, 31);

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return SubjectCard(
            subjectName: 'Subject $index',
            onTap: () {
              print('Subject $index tapped!');
            },
            page: const CatAssignment(),
          );
        },
      ),
    );
  }
}

class SubjectCard extends StatefulWidget {
  final String subjectName;
  final Widget page;

  const SubjectCard({
    required this.subjectName,
    required this.page,
    super.key,
    required Null Function() onTap,
  });

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.page),
        );
      },
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Card(
        elevation: isHovered ? 8.0 : 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(18.0),
              child: const Icon(
                Icons.book,
                size: 48.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.subjectName,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key});

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? user = FirebaseAuth.instance.currentUser;
  File? _image;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = user?.displayName ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 48.0,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : NetworkImage(user?.photoURL ?? '')
                      as ImageProvider<Object>?,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Email: ${user?.email ?? ''}',
            style: const TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Username:',
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              hintText: 'Enter your username',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Upload Profile Picture'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late User? user; // Define user here

  // Feedback variables
  final GlobalKey<FormState> _feedbackFormKey = GlobalKey<FormState>();
  final TextEditingController _feedbackSubjectController =
      TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final List<FeedbackForm> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    user = FirebaseAuth.instance.currentUser;
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRCE Connex'),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Assignments'),
            Tab(text: 'Calendar'),
            Tab(text: 'Profile'),
            Tab(text: 'Feedback'),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assignments'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(3);
              },
            ),
            const Divider(),
            ListTile(
              title: Text('Welcome, ${user?.displayName ?? ''}!'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const AssignmentsPage(),
          const TableBasicsExample(),
          const ProfileTab(),
          FeedbackPage(
            formKey: _feedbackFormKey,
            subjectController: _feedbackSubjectController,
            feedbackController: _feedbackController,
            feedbackList: _feedbackList,
            submitFeedback: submitFeedback,
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  // Feedback methods
  void submitFeedback() {
    if (_feedbackFormKey.currentState?.validate() ?? false) {
      FeedbackForm newFeedback = FeedbackForm(
        subject: _feedbackSubjectController.text,
        feedback: _feedbackController.text,
      );

      setState(() {
        _feedbackList.add(newFeedback);
      });

      // Clear the form fields
      _feedbackFormKey.currentState?.reset();
      _feedbackSubjectController.clear();
      _feedbackController.clear();
    }
  }
}

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({Key? key});

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          headerStyle: HeaderStyle(
            titleTextStyle: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            formatButtonDecoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
            formatButtonTextStyle: const TextStyle(color: Colors.white),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController subjectController;
  final TextEditingController feedbackController;
  final List<FeedbackForm> feedbackList;
  final VoidCallback submitFeedback;

  const FeedbackPage({
    required this.formKey,
    required this.subjectController,
    required this.feedbackController,
    required this.feedbackList,
    required this.submitFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: feedbackController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Feedback'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: submitFeedback,
                child: const Text('Submit Feedback'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Recent Feedback:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(feedbackList[index].subject),
                      subtitle: Text(feedbackList[index].feedback),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
