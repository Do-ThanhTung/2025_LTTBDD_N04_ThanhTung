import 'package:education/app/config/app_locale.dart';
import 'package:education/app/routing/app_routes.dart';
import 'package:education/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() =>
      _MainHomeScreenState();
}

class _MainHomeScreenState
    extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLocale.locale,
      builder: (context, _, __) {
        final routes = AppRoutes.build(context);
        final routeList = [
          '/home',
          '/my_learning',
          '/settings'
        ];
        final currentRoute = (_selectedIndex >= 0 &&
                _selectedIndex < routeList.length)
            ? routeList[_selectedIndex]
            : '/home';
        final pageBuilder =
            routes[currentRoute] ?? routes['/home']!;
        String t(String key) =>
            AppLocalizations.t(context, key);

        return Scaffold(
          body: pageBuilder(context),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.6),
            backgroundColor:
                Theme.of(context).colorScheme.surface,
            elevation: 8,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: t('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.school),
                label: t('my_learning'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: t('settings'),
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}
