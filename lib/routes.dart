import 'package:crce_connex/screens/student_assets/payment_page/view.dart';
import 'package:flutter/material.dart';
import 'package:crce_connex/screens/student_assets/feedback_section/view.dart';
import 'package:crce_connex/screens/student_assets/assignment_section/view.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/feedback_section': (context) => const FeedbackPage(),
      // Specify the import path for FeedbackPage
      '/payment_page': (context) => const PaymentPage(),
      '/assignment_section': (context) => const AssignmentPg(),
    };
  }
}
