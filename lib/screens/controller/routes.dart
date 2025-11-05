// routes.dart
import 'package:education/screens/controller/panel/expand_screen.dart';
import 'package:education/screens/controller/panel/my_learning_screen.dart';
import 'package:education/screens/controller/panel/settings_screen.dart';
import 'package:education/screens/controller/panel/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(
      BuildContext context) {
    return {
      '/home': (context) => const HomeScreen(),
      '/my_learning': (context) =>
          const MyLearningScreen(),
      '/expand': (context) => const ExpandScreen(),
      '/settings': (context) => const SettingsScreen(),
    };
  }
}
