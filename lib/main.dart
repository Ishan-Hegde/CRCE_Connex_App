import 'package:crce_connex/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crce_connex/providers/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crce_connex/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
