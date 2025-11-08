// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _ttsEnabled = true;
  String _selectedLanguage = 'en';
  Color _primaryColor = AppPrimaryColor.color.value;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isDarkMode = AppTheme.mode.value == ThemeMode.dark;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _ttsEnabled = prefs.getBool('tts_enabled') ?? true;
      _selectedLanguage = AppLocale.locale.value.languageCode;
      _primaryColor = AppPrimaryColor.color.value;
      _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    await AppTheme.save(mode);
    if (!mounted) return;
    setState(() {
      _isDarkMode = value;
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _saveSetting('notifications', value);
  }

  void _toggleTts(bool value) {
    setState(() {
      _ttsEnabled = value;
    });
    _saveSetting('tts_enabled', value);
  }

  Future<void> _changeLanguage(String? value) async {
    if (value == null) return;
    final locale = Locale(value);
    await AppLocale.save(locale);
    if (!mounted) return;
    setState(() {
      _selectedLanguage = value;
    });
  }

  Future<void> _selectPrimaryColor(Color color) async {
    await AppPrimaryColor.save(color);
    if (!mounted) return;
    setState(() {
      _primaryColor = color;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.t(context, 'primary_color_updated')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? [
            const Color(0xFF141726),
            const Color(0xFF151a2c),
            const Color(0xFF10131d)
          ]
        : [
            const Color(0xFFF7F9FF),
            const Color(0xFFFDF7FF),
            const Color(0xFFFFF5F8)
          ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsHeader(primaryColor: _primaryColor),
              const SizedBox(height: 24),
              _SectionLabel(title: AppLocalizations.t(context, 'account')),
              const SizedBox(height: 12),
              _SettingCard(
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.person,
                      title: AppLocalizations.t(context, 'profile'),
                      subtitle: AppLocalizations.t(context, 'profile_subtitle'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile editing coming soon.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _SettingTile(
                      icon: Icons.lock,
                      title: AppLocalizations.t(context, 'security'),
                      subtitle:
                          AppLocalizations.t(context, 'security_subtitle'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Security settings coming soon.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel(title: AppLocalizations.t(context, 'preferences')),
              const SizedBox(height: 12),
              _SettingCard(
                child: Column(
                  children: [
                    _ToggleTile(
                      icon: Icons.dark_mode,
                      title: AppLocalizations.t(context, 'dark_mode'),
                      subtitle:
                          AppLocalizations.t(context, 'dark_mode_subtitle'),
                      value: _isDarkMode,
                      onChanged: (value) {
                        _toggleDarkMode(value);
                      },
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                          _TileIcon(icon: Icons.language, color: _primaryColor),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.t(context, 'language'),
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.t(
                                      context, 'language_subtitle'),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedLanguage,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              DropdownMenuItem(
                                value: 'en',
                                child: Text(
                                    AppLocalizations.t(context, 'english')),
                              ),
                              DropdownMenuItem(
                                value: 'vi',
                                child: Text(
                                    AppLocalizations.t(context, 'vietnamese')),
                              ),
                            ],
                            onChanged: _changeLanguage,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    _ToggleTile(
                      icon: Icons.notifications_active,
                      title: AppLocalizations.t(context, 'notifications'),
                      subtitle:
                          AppLocalizations.t(context, 'notifications_subtitle'),
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                    ),
                    const Divider(height: 1),
                    _ToggleTile(
                      icon: Icons.record_voice_over,
                      title: AppLocalizations.t(context, 'text_to_speech'),
                      subtitle: AppLocalizations.t(context, 'tts_description'),
                      value: _ttsEnabled,
                      onChanged: _toggleTts,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel(
                  title: AppLocalizations.t(context, 'primary_color')),
              const SizedBox(height: 12),
              _SettingCard(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.t(context, 'choose_a_color'),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 14,
                        runSpacing: 12,
                        children: [
                          for (final color in AppPrimaryColor.colors)
                            GestureDetector(
                              onTap: () => _selectPrimaryColor(color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  border: Border.all(
                                    color: color == _primaryColor
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.28),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: color == _primaryColor
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 20)
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _SectionLabel(title: AppLocalizations.t(context, 'support')),
              const SizedBox(height: 12),
              _SettingCard(
                child: Column(
                  children: [
                    _SettingTile(
                      icon: Icons.help_center,
                      title: AppLocalizations.t(context, 'help_support'),
                      subtitle:
                          AppLocalizations.t(context, 'help_support_subtitle'),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Help center coming soon.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _SettingTile(
                      icon: Icons.description,
                      title: AppLocalizations.t(context, 'about'),
                      subtitle: 'Version 1.0.0',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'English Learning App',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© 2025 Your Company',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    if (_isLoggedIn)
                      _SettingTile(
                        icon: Icons.logout,
                        title: AppLocalizations.t(context, 'logout'),
                        subtitle:
                            AppLocalizations.t(context, 'logout_message_short'),
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: Text(AppLocalizations.t(
                                  dialogContext, 'confirm_logout')),
                              content: Text(AppLocalizations.t(
                                  dialogContext, 'logout_message')),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text(AppLocalizations.t(
                                      dialogContext, 'cancel')),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool('is_logged_in', false);
                                    if (!mounted) {
                                      return;
                                    }

                                    Navigator.of(dialogContext).pop();
                                    ScaffoldMessenger.of(dialogContext)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text('Logged out.')),
                                    );
                                    _loadSettings();
                                  },
                                  child: Text(AppLocalizations.t(
                                      dialogContext, 'logout')),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    else
                      _SettingTile(
                        icon: Icons.login,
                        title: AppLocalizations.t(context, 'login'),
                        subtitle: 'Sign in to your account',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.92),
            primaryColor.withValues(alpha: 0.78),
            primaryColor.withValues(alpha: 0.72),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.t(context, 'settings'),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLocalizations.t(context, 'settings_intro'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            _TileIcon(icon: icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          _TileIcon(icon: icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color),
    );
  }
}
