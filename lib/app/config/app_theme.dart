import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles persisting and toggling the global theme mode.
class AppTheme {
  AppTheme._();

  static const _key = 'app_theme';
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  static Future<void> load() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();
      final stored = prefs.getString(_key);
      if (stored == null) {
        mode.value = ThemeMode.light;
        return;
      }
      switch (stored) {
        case 'dark':
          mode.value = ThemeMode.dark;
          break;
        case 'light':
          mode.value = ThemeMode.light;
          break;
        case 'system':
          mode.value = ThemeMode.system;
          break;
        default:
          mode.value = ThemeMode.light;
      }
    } catch (_) {
      mode.value = ThemeMode.light;
    }
  }

  static Future<void> save(ThemeMode mode) async {
    final prefs =
        await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_key, value);
    AppTheme.mode.value = mode;
  }
}
