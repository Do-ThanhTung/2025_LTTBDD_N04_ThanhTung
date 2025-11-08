import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the selected locale and keeps track of whether the app
/// should follow the system locale.
class AppLocale {
  AppLocale._();

  static const _key = 'app_locale';
  static const _supportedCodes = ['en', 'vi'];
  static final ValueNotifier<Locale> locale =
      ValueNotifier<Locale>(const Locale('en'));

  static bool _followsSystemLocale = false;

  static bool get followsSystemLocale =>
      _followsSystemLocale;

  static Future<void> load() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();
      final stored = prefs.getString(_key);
      if (stored == null) {
        _followsSystemLocale = false;
        locale.value = const Locale('en');
      } else if (stored == 'system') {
        _followsSystemLocale = true;
        locale.value = _resolveSystemLocale();
      } else if (_supportedCodes.contains(stored)) {
        _followsSystemLocale = false;
        locale.value = Locale(stored);
      } else {
        _followsSystemLocale = false;
        await prefs.setString(_key, 'en');
        locale.value = const Locale('en');
      }
    } catch (_) {
      _followsSystemLocale = false;
      locale.value = const Locale('en');
    }

    PlatformDispatcher.instance.onLocaleChanged = () {
      if (_followsSystemLocale) {
        locale.value = _resolveSystemLocale();
      }
    };
  }

  static Future<void> save(Locale locale) async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    _followsSystemLocale = false;
    AppLocale.locale.value = locale;
  }

  static Future<void> resetToSystem() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setString(_key, 'system');
    _followsSystemLocale = true;
    AppLocale.locale.value = _resolveSystemLocale();
  }

  static Locale _resolveSystemLocale() {
    final systemLocale =
        PlatformDispatcher.instance.locale;
    if (_supportedCodes
        .contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }
    return const Locale('en');
  }
}
