import 'package:flutter/material.dart';
import '../../../../main.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.t(context, 'settings'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionHeader(
            context,
            icon: Icons.language,
            title: AppLocalizations.t(
                context, 'language'),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<Locale>(
            valueListenable: AppLocale.locale,
            builder: (context, currentLocale, _) {
              return Text(
                currentLocale.languageCode == 'en'
                    ? 'English'
                    : 'Tiếng Việt',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildLanguageChips(context),

          const SizedBox(height: 32),

          // Theme Section
          _buildSectionHeader(
            context,
            icon: Icons.brightness_6,
            title:
                AppLocalizations.t(context, 'theme'),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.mode,
            builder: (context, currentMode, _) {
              final modeName = currentMode ==
                      ThemeMode.dark
                  ? AppLocalizations.t(context, 'dark')
                  : currentMode == ThemeMode.light
                      ? AppLocalizations.t(
                          context, 'light')
                      : AppLocalizations.t(
                          context, 'system_default');
              return Text(
                modeName,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildThemeToggle(context),

          const SizedBox(height: 32),

          // Primary Color Section
          _buildSectionHeader(
            context,
            icon: Icons.palette,
            title: AppLocalizations.t(
                context, 'primary_color'),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.t(
                context, 'choose_a_color'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 16),
          _buildColorPicker(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context,
      {required IconData icon,
      required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color:
              Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChips(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocale.locale,
      builder: (context, currentLocale, _) {
        return Wrap(
          spacing: 12,
          children: [
            _buildLanguageChip(
              context,
              label: 'English',
              locale: const Locale('en'),
              icon: Icons.language,
              isSelected:
                  currentLocale.languageCode == 'en',
            ),
            _buildLanguageChip(
              context,
              label: 'Tiếng Việt',
              locale: const Locale('vi'),
              icon: Icons.translate,
              isSelected:
                  currentLocale.languageCode == 'vi',
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageChip(
    BuildContext context, {
    required String label,
    required Locale locale,
    required IconData icon,
    required bool isSelected,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) {
        AppLocale.save(locale);
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.t(context, 'language')}: $label'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      selectedColor: Theme.of(context)
          .colorScheme
          .primaryContainer,
      checkmarkColor: Theme.of(context)
          .colorScheme
          .onPrimaryContainer,
      backgroundColor:
          Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.mode,
      builder: (context, currentMode, _) {
        final isDarkMode =
            currentMode == ThemeMode.dark;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: SwitchListTile(
            secondary: Icon(
              isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),
            title: Text(
              isDarkMode
                  ? AppLocalizations.t(context, 'dark')
                  : AppLocalizations.t(
                      context, 'light'),
              style: const TextStyle(
                  fontWeight: FontWeight.w500),
            ),
            value: isDarkMode,
            onChanged: (bool value) {
              final newMode = value
                  ? ThemeMode.dark
                  : ThemeMode.light;
              AppTheme.save(newMode);

              // Auto-suggest appropriate color for the theme
              final suggestedColor = value
                  ? AppPrimaryColor.darkThemeDefault
                  : AppPrimaryColor.lightThemeDefault;
              AppPrimaryColor.save(suggestedColor);

              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar();
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.t(context, 'theme')}: ${value ? AppLocalizations.t(context, 'dark') : AppLocalizations.t(context, 'light')}',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: AppPrimaryColor.color,
      builder: (context, currentColor, _) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              AppPrimaryColor.colors.map((color) {
            final isSelected =
                currentColor.toARGB32() ==
                    color.toARGB32();

            return GestureDetector(
              onTap: () {
                AppPrimaryColor.save(color);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.t(
                        context,
                        'primary_color_updated')),
                    duration:
                        const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
