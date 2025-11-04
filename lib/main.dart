import 'screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'services/translation_service.dart';
import 'services/notification_service.dart';

// App-level theme holder (persisted)
class AppTheme {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier(ThemeMode.light); // Default: Light
  static const _key = 'app_theme';

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final s = p.getString(_key);
      if (s == null) {
        // No saved preference, use Light as default
        mode.value = ThemeMode.light;
      } else {
        mode.value = s == 'dark'
            ? ThemeMode.dark
            : s == 'light'
                ? ThemeMode.light
                : ThemeMode.system;
      }
    } catch (e) {
      // If SharedPreferences fails for any reason, fallback to light
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

// App-level locale holder (persisted with SharedPreferences)
class AppLocale {
  static final ValueNotifier<Locale> locale =
      ValueNotifier(const Locale('en'));
  static const _key = 'app_locale';

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final code = p.getString(_key) ?? 'en';
      locale.value = Locale(code);
    } catch (e) {
      locale.value = const Locale('en');
    }
  }

  static Future<void> save(Locale loc) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, loc.languageCode);
    locale.value = loc;
  }
}

// App-level primary color holder (persisted with SharedPreferences)
class AppPrimaryColor {
  static final ValueNotifier<Color> color =
      ValueNotifier(
          const Color(0xFF2196F3)); // Default: Blue
  static const _key = 'app_primary_color';

  static const colors = [
    Color(0xFF2196F3), // Blue
    Color(0xFF009688), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF673AB7), // Deep Purple
    Color(0xFFFF9800), // Orange
    Color(0xFFE91E63), // Pink
  ];

  // Default colors for each theme
  static const Color lightThemeDefault =
      Color(0xFF2196F3); // Blue for light
  static const Color darkThemeDefault =
      Color(0xFFFF9800); // Orange for dark

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final colorValue = p.getInt(_key);
      if (colorValue != null) {
        color.value = Color(colorValue);
      } else {
        // Set default based on current theme
        final isDark =
            AppTheme.mode.value == ThemeMode.dark;
        color.value = isDark
            ? darkThemeDefault
            : lightThemeDefault;
      }
    } catch (e) {
      color.value = const Color(0xFF2196F3);
    }
  }

  static Future<void> save(Color c) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_key, c.value);
    color.value = c;
  }

  // Auto-adjust color when theme changes
  static void onThemeChanged(ThemeMode newThemeMode) {
    // Only auto-adjust if using first time (not persisted)
    // This is optional - remove this if you want to keep user's choice
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.load();
  await AppTheme.load();
  await AppPrimaryColor
      .load(); // Load saved primary color
  // preload local translation dictionaries if available
  try {
    await Future.wait([
      // these calls ignore errors if assets are missing
      // TranslationService is a lightweight local mapping loader
      // (file: lib/services/translation_service.dart)
      // We call it here so translations are ready when user taps translate.
      // Note: if you run on web and don't bundle these assets, loadAssets will silently fail.
      // No harm in calling it.
      // ignore: unawaited_futures
      TranslationService.instance.loadAssets(),
    ]);
  } catch (_) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Listen to theme, locale and primary color so updates apply at runtime
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, themeMode, __) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocale.locale,
          builder: (context, locale, _) {
            return ValueListenableBuilder<Color>(
              valueListenable: AppPrimaryColor.color,
              builder: (context, primaryColor, _) {
                // expose navigatorKey to NotificationService so it can show overlays without BuildContext
                NotificationService.instance
                    .navigatorKey = navigatorKey;
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
                    GlobalMaterialLocalizations
                        .delegate,
                    GlobalWidgetsLocalizations
                        .delegate,
                    GlobalCupertinoLocalizations
                        .delegate,
                  ],
                  // Fallback logic if saved locale isn't supported
                  localeResolutionCallback:
                      (deviceLocale,
                          supportedLocales) {
                    // If the selected locale is supported, use it.
                    if (supportedLocales.any((l) =>
                        l.languageCode ==
                        locale.languageCode)) {
                      return locale;
                    }
                    // Try to match device locale by language code.
                    if (deviceLocale != null) {
                      final match =
                          supportedLocales.firstWhere(
                        (l) =>
                            l.languageCode ==
                            deviceLocale.languageCode,
                        orElse: () =>
                            supportedLocales.first,
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
                  home: const BaseScreen(),
                );
              },
            );
          },
        );
      },
    );
  }
}
