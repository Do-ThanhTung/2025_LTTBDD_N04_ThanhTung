import 'package:education/screens/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:education/main.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() =>
      _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLocale.locale,
      builder: (context, _, __) {
        final routes = Routes.getRoutes(context);
        final routeList = [
          '/home',
          '/my_learning',
          '/expand'
        ];
        final currentRoute = (_selectedIndex >= 0 &&
                _selectedIndex < routeList.length)
            ? routeList[_selectedIndex]
            : '/settings';
        final pageBuilder = routes[currentRoute] ??
            routes['/settings']!;
        String t(String key) =>
            AppLocalizations.t(context, key);

        return Scaffold(
          body: pageBuilder(context),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            backgroundColor: Colors.white,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.book),
                  label: t('dictionary')),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.school),
                  label: t('my_learning')),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.expand_more),
                  label: t('expand')),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
