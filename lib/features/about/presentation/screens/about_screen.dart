import 'package:education/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth =
        MediaQuery.of(context).size.width;
    final imageWidth =
        (screenWidth * 0.7).clamp(220.0, 360.0);
    final imageHeight = imageWidth * 1.25;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.t(context, 'about')),
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            isDark ? Colors.grey[900] : Colors.white,
        foregroundColor:
            isDark ? Colors.white : Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: isDark
              ? Colors.grey[900]
              : const Color(0xFFF5F5F5),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // App Info Section (moved to top)
              Column(
                children: [
                  // App Name
                  Text(
                    AppLocalizations.t(
                        context, 'about_app_name'),
                    style: theme
                        .textTheme.headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Version
                  Text(
                    AppLocalizations.t(
                        context, 'about_version'),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color: isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Copyright
                  Text(
                    AppLocalizations.t(
                        context, 'about_copyright'),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(
                      color: isDark
                          ? Colors.grey[300]
                          : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Developer Name (above photo)
              Text(
                AppLocalizations.t(
                    context, 'about_developer'),
                style: theme.textTheme.titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),
              // Developer Photo centred, larger
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(18),
                  child: Image.asset(
                    'assets/icons/Ảnh thẻ 23010811.png',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person,
                          size: 96,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // App Features
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.t(
                          context, 'about_features'),
                      style: theme
                          .textTheme.titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      context,
                      Icons.book,
                      AppLocalizations.t(context,
                          'about_feature_vocabulary'),
                      AppLocalizations.t(context,
                          'about_feature_vocabulary_desc'),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      context,
                      Icons.games,
                      AppLocalizations.t(context,
                          'about_feature_games'),
                      AppLocalizations.t(context,
                          'about_feature_games_desc'),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      context,
                      Icons.trending_up,
                      AppLocalizations.t(context,
                          'about_feature_progress'),
                      AppLocalizations.t(context,
                          'about_feature_progress_desc'),
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      context,
                      Icons.settings,
                      AppLocalizations.t(context,
                          'about_feature_customize'),
                      AppLocalizations.t(context,
                          'about_feature_customize_desc'),
                      isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Footer
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20),
                child: Text(
                  AppLocalizations.t(
                      context, 'about_footer'),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1976D2),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall
                    ?.copyWith(
                  color: isDark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
