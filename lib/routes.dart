import 'package:crce_connex/screens/payment_page/view.dart';
import 'package:flutter/material.dart';
import 'screens/app_05/view.dart';
import 'screens/assignment_section/view.dart';
import 'screens/feedback_section/view.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/feedback_section': (context) => const FeedbackPage(),
      // Specify the import path for FeedbackPage
      '/payment_page': (context) => const PaymentPage(),
      '/app05': (context) => const App05(),
      '/assignment_section': (context) => const AssignmentPg(),
    };
  }
}
