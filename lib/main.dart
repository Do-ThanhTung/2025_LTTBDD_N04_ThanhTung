import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'screens/auth/auth_wrapper.dart';
import 'screens/controller/routes.dart';
import 'services/notification_service.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
  static const _key = 'app_theme';

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final s = p.getString(_key);
      if (s == null) {
        mode.value = ThemeMode.light;
      } else {
        mode.value = s == 'dark'
            ? ThemeMode.dark
            : s == 'light'
                ? ThemeMode.light
                : ThemeMode.system;
      }
    } catch (e) {
      mode.value = ThemeMode.light;
    }
  }

  static Future<void> save(ThemeMode m) async {
    final p = await SharedPreferences.getInstance();
    final s = m == ThemeMode.dark
        ? 'dark'
        : m == ThemeMode.light
            ? 'light'
            : 'system';
    await p.setString(_key, s);
    mode.value = m;
  }
}

class AppLocale {
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));
  static const _key = 'app_locale';
  static const _supportedCodes = ['en', 'vi'];
  static bool _followsSystemLocale = false;

  static bool get followsSystemLocale => _followsSystemLocale;

  static Locale _resolveSystemLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    if (_supportedCodes.contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }
    return const Locale('en');
  }

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final code = p.getString(_key);
      if (code == null) {
        // Default to English
        _followsSystemLocale = false;
        locale.value = const Locale('en');
      } else if (code == 'system') {
        _followsSystemLocale = true;
        locale.value = _resolveSystemLocale();
      } else if (_supportedCodes.contains(code)) {
        _followsSystemLocale = false;
        locale.value = Locale(code);
      } else {
        // Default to English
        _followsSystemLocale = false;
        await p.setString(_key, 'en');
        locale.value = const Locale('en');
      }
    } catch (e) {
      _followsSystemLocale = false;
      locale.value = const Locale('en');
    }

    PlatformDispatcher.instance.onLocaleChanged = () {
      if (_followsSystemLocale) {
        locale.value = _resolveSystemLocale();
      }
    };
  }

  static Future<void> save(Locale loc) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, loc.languageCode);
    _followsSystemLocale = false;
    locale.value = loc;
  }

  static Future<void> resetToSystem() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, 'system');
    _followsSystemLocale = true;
    locale.value = _resolveSystemLocale();
  }
}

class AppPrimaryColor {
  static final ValueNotifier<Color> color =
      ValueNotifier(const Color(0xFF2196F3));
  static const _key = 'app_primary_color';

  static const colors = [
    Color(0xFF2196F3),
    Color(0xFF009688),
    Color(0xFF4CAF50),
    Color(0xFF673AB7),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
  ];

  static const Color lightThemeDefault = Color(0xFF2196F3);
  static const Color darkThemeDefault = Color(0xFFFF9800);

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final colorValue = p.getInt(_key);
      if (colorValue != null) {
        color.value = Color(colorValue);
      } else {
        final isDark = AppTheme.mode.value == ThemeMode.dark;
        color.value = isDark ? darkThemeDefault : lightThemeDefault;
      }
    } catch (e) {
      color.value = const Color(0xFF2196F3);
    }
  }

  static Future<void> save(Color c) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_key, c.toARGB32());
    color.value = c;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.load();
  await AppTheme.load();
  await AppPrimaryColor.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, themeMode, __) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocale.locale,
          builder: (context, locale, _) {
            return ValueListenableBuilder<Color>(
              valueListenable: AppPrimaryColor.color,
              builder: (context, primaryColor, _) {
                NotificationService.instance.navigatorKey = navigatorKey;
                return MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Education App',
                  locale: locale,
                  supportedLocales: const [
                    Locale('en'),
                    Locale('vi'),
                  ],
                  localizationsDelegates: const [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (deviceLocale, supportedLocales) {
                    if (supportedLocales
                        .any((l) => l.languageCode == locale.languageCode)) {
                      return locale;
                    }
                    if (deviceLocale != null) {
                      final match = supportedLocales.firstWhere(
                        (l) => l.languageCode == deviceLocale.languageCode,
                        orElse: () => supportedLocales.first,
                      );
                      return match;
                    }
                    return supportedLocales.first;
                  },
                  theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: primaryColor,
                      brightness: Brightness.light,
                    ),
                    fontFamily: 'Poppins',
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: primaryColor,
                      brightness: Brightness.dark,
                    ),
                    fontFamily: 'Poppins',
                  ),
                  themeMode: themeMode,
                  routes: Routes.getRoutes(context),
                  home: const AuthWrapper(),
                );
              },
            );
          },
        );
      },
    );
  }
}
