import 'package:crce_connex/routes.dart';
import 'package:crce_connex/theme.dart';
import 'package:crce_connex/providers/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: signUserOut,
//               icon: const Icon(Icons.logout)
//           )
//         ],
//       ),
//       body: const Center(child: Text("LOGGED IN!")),
//     );
//   }
// }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(),
      theme: Provider.of<ThemeProvider>(context).isDarkMode
          ? AppTheme.getDarkTheme(context)
          : AppTheme.getLightTheme(context),
    );
  }
}