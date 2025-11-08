import 'package:education/features/about/presentation/screens/about_screen.dart';
import 'package:education/features/expand/presentation/screens/expand_selector_screen.dart';
import 'package:education/features/home/presentation/screens/home_dashboard_screen.dart';
import 'package:education/features/home/presentation/screens/learning_progress_screen.dart';
import 'package:education/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  const AppRoutes._();

  static Map<String, WidgetBuilder> build(
      BuildContext context) {
    return {
      '/home': (_) => const HomeScreen(),
      '/my_learning': (_) => const MyLearningScreen(),
      '/expand': (_) => const ExpandScreen(),
      '/settings': (_) => const SettingsScreen(),
      '/about': (_) => const AboutScreen(),
    };
  }
}
