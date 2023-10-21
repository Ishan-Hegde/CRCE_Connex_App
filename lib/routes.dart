import 'package:flutter/material.dart';
import 'screens/app_01/view.dart';
import 'screens/app_02/view.dart';
import 'screens/app_03/view.dart';
import 'screens/app_04/view.dart';
import 'screens/app_05/view.dart';
import 'screens/app_06/view.dart';
import 'screens/app_07/view.dart';
import 'screens/app_08/view.dart';
import 'screens/app_09/view.dart';
import 'screens/app_10/view.dart';
import 'screens/app_11/view.dart';
import 'screens/app_12/view.dart';
import 'screens/app_13/view.dart';
import 'screens/app_14/view.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/app01': (context) => const App01(),
      '/app02': (context) => const App02(),
      '/app03': (context) => const App03(),
      '/app04': (context) => const App04(),
      '/app05': (context) => const App05(),
      '/app06': (context) => const App06(),
      '/app07': (context) => const App07(),
      '/app08': (context) => const App08(),
      '/app09': (context) => const App09(),
      '/app10': (context) => const App10(),
      '/app11': (context) => const App11(),
      '/app12': (context) => const App12(),
      '/app13': (context) => const App13(),
      '/app14': (context) => const App14(),
    };
  }
}
