import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false; // ignore: unused_field

  @override
  void initState() {
    super.initState();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppPrimaryColor.color.value;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'English Learning',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/icon-learning.png',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),

              // Benefits
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.t(context, 'account_benefits'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBenefit(
                      theme,
                      AppLocalizations.t(context, 'benefit_history'),
                    ),
                    const SizedBox(height: 8),
                    _buildBenefit(
                      theme,
                      AppLocalizations.t(context, 'benefit_features'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Social Login Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildSocialButton(
                      'Zalo',
                      'assets/icons/icons-zalo.png',
                      primaryColor,
                      () => _handleSocialLogin('zalo'),
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      'Google',
                      'assets/icons/icons-google.png',
                      primaryColor,
                      () => _handleSocialLogin('google'),
                    ),
                    const SizedBox(height: 12),
                    _buildSocialButton(
                      'Facebook',
                      'assets/icons/icons-facebook.png',
                      primaryColor,
                      () => _handleSocialLogin('facebook'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Terms and Privacy
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppLocalizations.t(context, 'terms_intro'),
                      style: theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: AppLocalizations.t(context, 'terms_link'),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.t(context, 'privacy_link'),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Help Link
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Help & Support coming soon')),
                    );
                  },
                  child: Text(
                    AppLocalizations.t(context, 'help_support'),
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit(ThemeData theme, String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String label,
    String iconPath,
    Color primaryColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.t(context, 'login_with') + label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    String providerName = provider;
    if (provider == 'zalo') {
      providerName = 'Zalo';
    } else if (provider == 'google') {
      providerName = 'Google';
    } else if (provider == 'facebook') {
      providerName = 'Facebook';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Xác nhận đăng nhập',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Bạn có chắc muốn đăng nhập bằng $providerName?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.t(context, 'cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _loginWithProvider(providerName);
            },
            child: Text(AppLocalizations.t(context, 'login')),
          ),
        ],
      ),
    );
  }

  Future<void> _loginWithProvider(String provider) async {
    // Show loading
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      // Generate fake user email from provider
      final email = 'user.${provider.toLowerCase()}@example.com';

      await prefs.setString('user_email', email);
      await prefs.setString('user_id', provider.toLowerCase());
      await prefs.setBool('is_logged_in', true);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.t(context, 'login_success')),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home after a short delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
