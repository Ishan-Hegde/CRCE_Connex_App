import 'package:crce_connex/providers/theme.dart';
import 'package:crce_connex/routes.dart';
import 'package:crce_connex/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(),
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? AppTheme.getDarkTheme(context)
          : AppTheme.getLightTheme(context),
    );
  }
}
