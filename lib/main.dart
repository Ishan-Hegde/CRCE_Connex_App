import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/menu/view.dart';
import 'providers/theme.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: SafeArea(child: Apps())),
      routes: Routes.getRoutes(),
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? AppTheme.getDarkTheme(context)
          : AppTheme.getLightTheme(context),
    );
  }
}
