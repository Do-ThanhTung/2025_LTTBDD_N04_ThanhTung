import 'package:education/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/services/translation_service.dart';
import 'package:education/services/notification_service.dart';

// App-level theme holder (persisted)
class AppTheme {
  static final ValueNotifier<ThemeMode> mode =
      ValueNotifier(ThemeMode.system);
  static const _key = 'app_theme';

  static Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final s = p.getString(_key) ?? 'system';
      mode.value = s == 'dark'
          ? ThemeMode.dark
          : s == 'light'
              ? ThemeMode.light
              : ThemeMode.system;
    } catch (e) {
      // If SharedPreferences fails for any reason, fallback to system
      mode.value = ThemeMode.system;
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.load();
  await AppTheme.load();
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
  const MyApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Listen to theme and locale so updates apply at runtime
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, themeMode, __) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocale.locale,
          builder: (context, locale, _) {
            // expose navigatorKey to NotificationService so it can show overlays without BuildContext
            NotificationService.instance.navigatorKey =
                navigatorKey;
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
              // Fallback logic if saved locale isn't supported
              localeResolutionCallback:
                  (deviceLocale, supportedLocales) {
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
                primarySwatch: Colors.blue,
                fontFamily: 'Poppins',
                textTheme: const TextTheme(
                  titleLarge: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  displayMedium: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                // Palette provided (light -> dark):
                // #E7F5DC, #CFE1B9, #B6C99B, #98A77C, #88976C, #728156
                scaffoldBackgroundColor:
                    const Color(0xFF728156), // darkest
                canvasColor: const Color(0xFF728156),
                cardColor: const Color(
                    0xFFB6C99B), // lighter card tone
                appBarTheme: const AppBarTheme(
                  backgroundColor:
                      Color(0xFF88976C), // medium-dark
                  foregroundColor: Color(0xFFE7F5DC),
                  iconTheme: IconThemeData(
                      color: Color(0xFFE7F5DC)),
                ),
                // Use the palette for color scheme too so widgets pick palette colors
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF98A77C),
                  secondary: Color(0xFFB6C99B),
                  surface: Color(0xFFB6C99B),
                  onPrimary: Color(0xFFFFFFFF),
                  onSecondary: Color(0xFF728156),
                ),
                // Text and icons should use white for maximum readability
                textTheme: const TextTheme(
                  titleLarge: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                  bodyLarge: TextStyle(
                    fontSize: 20,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                  displayMedium: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                iconTheme: const IconThemeData(
                    color: Color(0xFFFFFFFF)),
                dividerColor: const Color(0xFF98A77C),
                floatingActionButtonTheme:
                    const FloatingActionButtonThemeData(
                  backgroundColor: Color(0xFF98A77C),
                  foregroundColor: Color(0xFFE7F5DC),
                ),
                // Button and control themes using the palette
                elevatedButtonTheme:
                    ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF98A77C),
                    foregroundColor:
                        const Color(0xFFE7F5DC),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        const Color(0xFFE7F5DC),
                  ),
                ),
                outlinedButtonTheme:
                    OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFFE7F5DC),
                    side: const BorderSide(
                        color: Color(0xFFCFE1B9)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                  ),
                ),
                switchTheme: SwitchThemeData(
                  thumbColor: WidgetStateProperty.all(
                      const Color(0xFFE7F5DC)),
                  trackColor: WidgetStateProperty.all(
                      const Color(0xFF98A77C)),
                ),
                toggleButtonsTheme:
                    const ToggleButtonsThemeData(
                  color: Color(0xFFE7F5DC),
                  fillColor: Color(0xFF98A77C),
                  selectedBorderColor:
                      Color(0xFFB6C99B),
                  borderColor: Color(0xFF88976C),
                ),
                sliderTheme: const SliderThemeData(
                  activeTrackColor: Color(0xFF98A77C),
                  inactiveTrackColor:
                      Color(0xFF88976C),
                  thumbColor: Color(0xFFE7F5DC),
                  overlayColor: Color(0x33E7F5DC),
                ),
                // Bottom navigation: background uses a lighter palette tone,
                // unselected items use the darkest tone, selected use the lightest.
                bottomNavigationBarTheme:
                    const BottomNavigationBarThemeData(
                  backgroundColor: Color(0xFFB6C99B),
                  unselectedItemColor:
                      Color(0xFF728156),
                  unselectedIconTheme: IconThemeData(
                      color: Color(0xFF728156)),
                  unselectedLabelStyle: TextStyle(
                      color: Color(0xFF728156)),
                  selectedItemColor: Colors.white,
                  selectedIconTheme: IconThemeData(
                      color: Colors.white),
                  selectedLabelStyle:
                      TextStyle(color: Colors.white),
                  showUnselectedLabels: true,
                ),
              ),
              themeMode: themeMode,
              home: const BaseScreen(),
            );
          },
        );
      },
    );
  }
}
