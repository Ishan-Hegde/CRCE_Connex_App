import 'package:crce_connex/firebase_options.dart';
import 'package:crce_connex/providers/theme.dart';
import 'package:crce_connex/routes.dart';
import 'package:crce_connex/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: Routes.getRoutes(),
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? AppTheme.getDarkTheme(context)
          : AppTheme.getLightTheme(context),
    );
  }
}
