import 'package:flutter/material.dart';
import 'package:education/main.dart';
import 'package:education/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ...existing code...

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    Locale loc,
  ) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocale.locale,
      builder: (_, current, __) {
        return ListTile(
          title: Text(title),
          trailing: current.languageCode == loc.languageCode
              ? const Icon(Icons.check)
              : null,
          onTap: () {
            AppLocale.save(loc);
            // Schedule the SnackBar to show after the frame so
            // MaterialApp has rebuilt with the new locale and
            // `Localizations.localeOf(context)` reflects the change.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final saved = AppLocale.locale.value.languageCode;
              final current = Localizations.localeOf(context).languageCode;
              // show a simple diagnostic SnackBar (local to Settings)
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('saved: $saved, localizations: $current')),
              );
            });
          },
        );
      },
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    String title,
    ThemeMode mode,
  ) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (_, current, __) {
        return ListTile(
          title: Text(title),
          trailing: current == mode ? const Icon(Icons.check) : null,
          onTap: () {
            AppTheme.save(mode);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('${AppLocalizations.t(context, 'theme')}: $title')),
            );
          },
        );
      },
    );
  }

  // ...existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.t(context, 'settings'),
        ),
      ),
      body: ListView(
        children: [
          // current selection status
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ValueListenableBuilder<Locale>(
              valueListenable: AppLocale.locale,
              builder: (_, loc, __) {
                return Text(
                  '${AppLocalizations.t(context, 'language')}: ${loc.languageCode}',
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 0,
            ),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: AppTheme.mode,
              builder: (_, mode, __) {
                final name = mode == ThemeMode.dark
                    ? AppLocalizations.t(
                        context,
                        'dark',
                      )
                    : mode == ThemeMode.light
                        ? AppLocalizations.t(
                            context,
                            'light',
                          )
                        : AppLocalizations.t(
                            context,
                            'system_default',
                          );
                return Text(
                  '${AppLocalizations.t(context, 'theme')}: $name',
                );
              },
            ),
          ),

          const Divider(),

          ListTile(
            title: Text(
              AppLocalizations.t(context, 'language'),
            ),
          ),
          _buildLanguageTile(
            context,
            AppLocalizations.t(context, 'english'),
            const Locale('en'),
          ),
          _buildLanguageTile(
            context,
            AppLocalizations.t(context, 'vietnamese'),
            const Locale('vi'),
          ),
          const Divider(),
          ListTile(
            title: Text(
              AppLocalizations.t(context, 'theme'),
            ),
          ),
          _buildThemeTile(
            context,
            AppLocalizations.t(
              context,
              'system_default',
            ),
            ThemeMode.system,
          ),
          _buildThemeTile(
            context,
            AppLocalizations.t(context, 'light'),
            ThemeMode.light,
          ),
          _buildThemeTile(
            context,
            AppLocalizations.t(context, 'dark'),
            ThemeMode.dark,
          ),
        ],
      ),
    );
  }
}
