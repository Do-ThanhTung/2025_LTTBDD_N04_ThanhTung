// routes.dart
import 'package:flutter/material.dart';

import '../features/about/about_screen.dart';
import '../features/expand/expand_selector_screen.dart';
import '../features/settings/settings_screen.dart';
import '../home/home_dashboard_screen.dart';
import '../home/learning_progress_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      '/home': (context) => const HomeScreen(),
      '/my_learning': (context) => const MyLearningScreen(),
      '/expand': (context) => const ExpandScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/about': (context) => const AboutScreen(),
    };
  }
}
