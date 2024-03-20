import 'package:flutter/material.dart';
import 'screens/app_02/view.dart';
import 'screens/app_05/view.dart';
import 'screens/assignment_section/view.dart';
import 'screens/feedback_section/view.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/feedback_section': (context) => const FeedbackPage(),
      // Specify the import path for FeedbackPage
      '/app02': (context) => const App02(),
      '/app05': (context) => const App05(),
      '/app07': (context) => const AssignmentPg(),
    };
  }
}
