import 'package:education/app/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks and persists the primary seed color used across themes.
class AppPrimaryColor {
  AppPrimaryColor._();

  static const _key = 'app_primary_color';
  static const Color lightThemeDefault =
      Color(0xFF2196F3);
  static const Color darkThemeDefault =
      Color(0xFFFF9800);

  static final ValueNotifier<Color> color =
      ValueNotifier<Color>(lightThemeDefault);

  static const colors = <Color>[
    Color(0xFF2196F3),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF673AB7),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
  ];

  static Future<void> load() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();
      final stored = prefs.getInt(_key);
      if (stored != null) {
        color.value = Color(stored);
        return;
      }
      final isDark =
          AppTheme.mode.value == ThemeMode.dark;
      color.value = isDark
          ? darkThemeDefault
          : lightThemeDefault;
    } catch (_) {
      color.value = lightThemeDefault;
    }
  }

  static Future<void> save(Color color) async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setInt(_key, color.toARGB32());
    AppPrimaryColor.color.value = color;
  }
}
