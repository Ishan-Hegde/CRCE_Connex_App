// import 'package:crce_connex/routes.dart';
// import 'package:crce_connex/theme.dart';
// import 'package:crce_connex/providers/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
// import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:image_picker/image_picker.dart';


final kFirstDay = DateTime(2000, 1, 1);
final kLastDay = DateTime(2050, 12, 31);

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

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
          );
        },
      ),
    );
  }
}

class SubjectCard extends StatefulWidget {
  final String subjectName;
  final VoidCallback onTap;

  const SubjectCard({
    required this.subjectName,
    required this.onTap,
    super.key,
  });

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovered) {
        setState(() {
          isHovered = hovered;
        });
      },
      child: Material(
        elevation: isHovered ? 8.0 : 4.0,
        borderRadius: BorderRadius.circular(16.0),
        child: InkResponse(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16.0),
                child: const Icon(
                  Icons.book,
                  size: 48.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.subjectName,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

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
            backgroundImage: _image != null
                ? FileImage(_image!) as ImageProvider<Object>?
                : NetworkImage(user?.photoURL ?? '') as ImageProvider<Object>?,
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
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Upload Profile Picture'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: [
  //         IconButton(
  //             onPressed: signUserOut,
  //             icon: const Icon(Icons.logout)
  //         )
  //       ],
  //     ),
  //     body: const Center(child: Text("LOGGED IN!")),
  //   );
  // }


// // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       routes: Routes.getRoutes(),
//       theme: Provider.of<ThemeProvider>(context).isDarkMode
//           ? AppTheme.getDarkTheme(context)
//           : AppTheme.getLightTheme(context),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        child: ListView(
          children: [
            ListTile(
              title: const Text('Assignments'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _tabController.animateTo(0); // Switch to Assignments tab
              },
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _tabController.animateTo(1); // Switch to Calendar tab
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _tabController.animateTo(2); // Switch to Profile tab
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AssignmentsPage(),
          TableBasicsExample(),
          ProfileTab(),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}


class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({super.key});

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
            titleTextStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
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

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

