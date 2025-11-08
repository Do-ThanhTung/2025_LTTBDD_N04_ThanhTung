import 'package:education/app/config/app_locale.dart';
import 'package:education/app/config/app_primary_color.dart';
import 'package:education/app/config/app_theme.dart';
import 'package:education/app/routing/app_routes.dart';
import 'package:education/core/localization/app_localizations.dart';
import 'package:education/core/services/notification_service.dart';
import 'package:education/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (_, themeMode, __) {
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocale.locale,
          builder: (_, locale, __) {
            return ValueListenableBuilder<Color>(
              valueListenable: AppPrimaryColor.color,
              builder: (_, primaryColor, __) {
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
                  localeResolutionCallback:
                      (deviceLocale,
                          supportedLocales) {
                    if (supportedLocales.any(
                      (l) =>
                          l.languageCode ==
                          locale.languageCode,
                    )) {
                      return locale;
                    }
                    if (deviceLocale != null) {
                      return supportedLocales
                          .firstWhere(
                        (l) =>
                            l.languageCode ==
                            deviceLocale.languageCode,
                        orElse: () =>
                            supportedLocales.first,
                      );
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
                  routes: AppRoutes.build(context),
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
