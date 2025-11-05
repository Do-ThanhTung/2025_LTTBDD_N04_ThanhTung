// routes.dart
import 'panel/expand_screen.dart';
import 'panel/my_learning_screen.dart';
import 'panel/settings_screen.dart';
import 'panel/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(
      BuildContext context) {
    return {
      '/home': (context) => const HomeScreen(),
      '/my_learning': (context) => MyLearningScreen(),
      '/expand': (context) => const ExpandScreen(),
      '/settings': (context) => const SettingsScreen(),
    };
  }
}
