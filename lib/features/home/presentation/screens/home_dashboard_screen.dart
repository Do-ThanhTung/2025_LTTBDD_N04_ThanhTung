import 'dart:math' as math;

import 'package:education/app/config/app_primary_color.dart';
import 'package:education/core/localization/app_localizations.dart';
import 'package:education/features/dictionary/presentation/screens/dictionary_screen.dart';
import 'package:education/features/expand/presentation/screens/game_screen.dart';
import 'package:education/features/expand/presentation/screens/story_screen.dart';
import 'package:education/features/expand/presentation/screens/translation_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _searchCount = 0;
  int _gamesPlayed = 0;
  int _totalTrophies = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs =
        await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getBool('is_logged_in') ?? false;

    setState(() {
      if (isLoggedIn) {
        final provider =
            prefs.getString('login_provider') ??
                'default';
        _searchCount =
            prefs.getInt('${provider}_search_count') ??
                0;
        _gamesPlayed =
            prefs.getInt('${provider}_games_played') ??
                0;
        _totalTrophies = prefs.getInt(
                '${provider}_total_trophies') ??
            0;
      } else {
        _searchCount = 0;
        _gamesPlayed = 0;
        _totalTrophies = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: AppPrimaryColor.color,
      builder: (context, primaryColor, _) {
        final isDark = Theme.of(context).brightness ==
            Brightness.dark;
        String t(String key) =>
            AppLocalizations.t(context, key);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1a1a2e),
                      const Color(0xFF16213e),
                      const Color(0xFF0f1419),
                    ]
                  : [
                      const Color(0xFFF8F7FF),
                      const Color(0xFFFCF8FF),
                      const Color(0xFFFFF5F8),
                    ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Header with gradient background
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF64B5F6),
                          const Color(0xFF42A5F5),
                          const Color(0xFF2196F3),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius:
                          const BorderRadius.only(
                        bottomLeft:
                            Radius.circular(32),
                        bottomRight:
                            Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                                  0xFF2196F3)
                              .withAlpha(
                                  (0.3 * 255).round()),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Bong bóng sáng ngẫu nhiên
                        ..._buildRandomBubbles(),
                        // Nội dung chính
                        Padding(
                          padding: const EdgeInsets
                              .fromLTRB(
                              20, 20, 20, 60),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                t('study_chill'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .black26,
                                      offset:
                                          Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  height: 4),
                              Text(
                                t('learn_more_fun'),
                                style: TextStyle(
                                  color: Colors.white
                                      .withAlpha(
                                          (0.95 * 255)
                                              .round()),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Feature Cards Grid (2x2)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        20, 0, 20, 20),
                    child: Transform.translate(
                      offset: const Offset(0, -40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:
                                    _buildFeatureCard(
                                  context,
                                  title:
                                      t('dictionary'),
                                  icon: Icons.search,
                                  gradient:
                                      const LinearGradient(
                                    begin: Alignment
                                        .topLeft,
                                    end: Alignment
                                        .bottomRight,
                                    colors: [
                                      Color(
                                          0xFFB39DDB),
                                      Color(
                                          0xFF9575CD),
                                      Color(
                                          0xFF7E57C2),
                                    ],
                                    stops: [
                                      0.0,
                                      0.5,
                                      1.0
                                    ],
                                  ),
                                  circleCount: 3,
                                  heroTag:
                                      'hero_dictionary',
                                  onTap: () {
                                    Navigator.of(
                                            context)
                                        .push(
                                          PageRouteBuilder(
                                            pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) =>
                                                const DictionaryScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity:
                                                    animation,
                                                child:
                                                    child,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                          ),
                                        )
                                        .then((_) =>
                                            _loadStats()); // Reload stats khi quay lại
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width: 12),
                              Expanded(
                                child:
                                    _buildFeatureCard(
                                  context,
                                  title:
                                      t('translation'),
                                  icon:
                                      Icons.translate,
                                  gradient:
                                      const LinearGradient(
                                    begin: Alignment
                                        .topRight,
                                    end: Alignment
                                        .bottomLeft,
                                    colors: [
                                      Color(
                                          0xFF26C6DA),
                                      Color(
                                          0xFF00ACC1),
                                      Color(
                                          0xFF00897B),
                                    ],
                                    stops: [
                                      0.0,
                                      0.5,
                                      1.0
                                    ],
                                  ),
                                  circleCount: 4,
                                  heroTag:
                                      'hero_translation',
                                  onTap: () {
                                    Navigator.of(
                                            context)
                                        .push(
                                          PageRouteBuilder(
                                            pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) =>
                                                const TranslationScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity:
                                                    animation,
                                                child:
                                                    child,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                          ),
                                        )
                                        .then((_) =>
                                            _loadStats()); // Reload stats khi quay lại
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child:
                                    _buildFeatureCard(
                                  context,
                                  title: t('game'),
                                  icon: Icons
                                      .videogame_asset,
                                  gradient:
                                      const LinearGradient(
                                    begin: Alignment
                                        .bottomLeft,
                                    end: Alignment
                                        .topRight,
                                    colors: [
                                      Color(
                                          0xFFF06292),
                                      Color(
                                          0xFFEC407A),
                                      Color(
                                          0xFFE91E63),
                                    ],
                                    stops: [
                                      0.0,
                                      0.5,
                                      1.0
                                    ],
                                  ),
                                  circleCount: 5,
                                  heroTag: 'hero_game',
                                  onTap: () {
                                    Navigator.of(
                                            context)
                                        .push(
                                          PageRouteBuilder(
                                            pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) =>
                                                const GameScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity:
                                                    animation,
                                                child:
                                                    child,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                          ),
                                        )
                                        .then((_) =>
                                            _loadStats()); // Reload stats khi quay lại
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width: 12),
                              Expanded(
                                child:
                                    _buildFeatureCard(
                                  context,
                                  title: t(
                                      'short_stories'),
                                  icon:
                                      Icons.menu_book,
                                  gradient:
                                      const LinearGradient(
                                    begin: Alignment
                                        .bottomRight,
                                    end: Alignment
                                        .topLeft,
                                    colors: [
                                      Color(
                                          0xFF4DD0E1),
                                      Color(
                                          0xFF26C6DA),
                                      Color(
                                          0xFF00BCD4),
                                    ],
                                    stops: [
                                      0.0,
                                      0.5,
                                      1.0
                                    ],
                                  ),
                                  circleCount: 6,
                                  heroTag:
                                      'hero_story',
                                  onTap: () {
                                    Navigator.of(
                                            context)
                                        .push(
                                          PageRouteBuilder(
                                            pageBuilder: (context,
                                                    animation,
                                                    secondaryAnimation) =>
                                                const StoryScreen(),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              return FadeTransition(
                                                opacity:
                                                    animation,
                                                child:
                                                    child,
                                              );
                                            },
                                            transitionDuration:
                                                const Duration(
                                                    milliseconds: 500),
                                          ),
                                        )
                                        .then((_) =>
                                            _loadStats()); // Reload stats khi quay lại
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Quick Stats
                          Container(
                            padding:
                                const EdgeInsets.all(
                                    20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors
                                      .grey.shade800
                                      .withAlpha(
                                          (0.7 * 255)
                                              .round())
                                  : Colors.white
                                      .withAlpha((0.8 *
                                              255)
                                          .round()),
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha(
                                          (0.05 * 255)
                                              .round()),
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  t('home_stats_title'),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey
                                            .shade800,
                                  ),
                                ),
                                const SizedBox(
                                    height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceAround,
                                  children: [
                                    _buildStatItem(
                                      context,
                                      '$_searchCount',
                                      t('home_stats_words'),
                                      const LinearGradient(
                                        begin: Alignment
                                            .topLeft,
                                        end: Alignment
                                            .bottomRight,
                                        colors: [
                                          Color(
                                              0xFFB39DDB),
                                          Color(
                                              0xFF9575CD),
                                          Color(
                                              0xFF7E57C2),
                                        ],
                                      ),
                                    ),
                                    _buildStatItem(
                                      context,
                                      '$_gamesPlayed',
                                      t('home_stats_games'),
                                      const LinearGradient(
                                        begin: Alignment
                                            .topLeft,
                                        end: Alignment
                                            .bottomRight,
                                        colors: [
                                          Color(
                                              0xFFF06292),
                                          Color(
                                              0xFFEC407A),
                                          Color(
                                              0xFFE91E63),
                                        ],
                                      ),
                                    ),
                                    _buildStatItem(
                                      context,
                                      '$_totalTrophies',
                                      t('home_stats_trophies'),
                                      const LinearGradient(
                                        begin: Alignment
                                            .topLeft,
                                        end: Alignment
                                            .bottomRight,
                                        colors: [
                                          Color(
                                              0xFFFFD54F),
                                          Color(
                                              0xFFFFCA28),
                                          Color(
                                              0xFFFFC107),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Thêm khoảng trống ở cuối để luôn có thể scroll
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Tạo bong bóng ngẫu nhiên cho header
  List<Widget> _buildRandomBubbles() {
    final random = math.Random();
    final bubbleCount =
        3 + random.nextInt(4); // 3-6 bong bóng

    return List.generate(bubbleCount, (index) {
      final size = 40.0 +
          random.nextDouble() *
              100; // Kích thước 40-140
      final leftPercent =
          random.nextDouble(); // 0.0 - 1.0
      final topPercent =
          random.nextDouble(); // 0.0 - 1.0
      final opacity = 0.05 +
          random.nextDouble() *
              0.10; // Độ trong suốt 0.05-0.15 (nhẹ hơn)

      return Positioned.fill(
        child: Align(
          alignment: Alignment(
            -1 +
                (leftPercent *
                    2), // -1 đến 1 (trái sang phải)
            -1 +
                (topPercent *
                    2), // -1 đến 1 (trên xuống dưới)
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
                  .withAlpha((opacity * 255).round()),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Gradient gradient,
    required int circleCount,
    required VoidCallback onTap,
    String? heroTag,
  }) {
    // Tạo vòng tròn với số lượng và vị trí khác nhau cho mỗi card
    List<Widget> buildCircles() {
      if (circleCount == 3) {
        // Dictionary - 3 vòng tròn
        return [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.12 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: -25,
            left: -25,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.1 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -15,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.08 * 255).round()),
              ),
            ),
          ),
        ];
      } else if (circleCount == 4) {
        // Translation - 4 vòng tròn
        return [
          Positioned(
            top: -35,
            left: -35,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.13 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.09 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: -10,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.07 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: -8,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.11 * 255).round()),
              ),
            ),
          ),
        ];
      } else if (circleCount == 5) {
        // Game - 5 vòng tròn
        return [
          Positioned(
            top: -28,
            right: -28,
            child: Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.14 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.1 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: -12,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.08 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            right: -10,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.12 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.09 * 255).round()),
              ),
            ),
          ),
        ];
      } else {
        // Short Stories - 6 vòng tròn
        return [
          Positioned(
            bottom: -35,
            right: -35,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.13 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: -25,
            left: -25,
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.11 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: -12,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.09 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -10,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.1 * 255).round()),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.07 * 255).round()),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white
                    .withAlpha((0.08 * 255).round()),
              ),
            ),
          ),
        ];
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag ?? 'feature_$title',
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(
                        (0.1 * 255).round()),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Vòng tròn điểm nhấn
                  ...buildCircles(),
                  // Nội dung chính
                  Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withAlpha((0.3 * 255)
                                    .round()),
                            borderRadius:
                                BorderRadius.circular(
                                    16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withAlpha(
                                        (0.1 * 255)
                                            .round()),
                                blurRadius: 8,
                                offset:
                                    const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Gradient gradient,
  ) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first
                    .withAlpha((0.3 * 255).round()),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: gradient.colors.last
                    .withAlpha((0.2 * 255).round()),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Vòng tròn trang trí phía sau - kích thước ngẫu nhiên
              Positioned(
                top: -12,
                right: -12,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(
                        (0.15 * 255).round()),
                  ),
                ),
              ),
              Positioned(
                bottom: -8,
                left: -8,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(
                        (0.1 * 255).round()),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: -5,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(
                        (0.08 * 255).round()),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: -3,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withAlpha(
                        (0.12 * 255).round()),
                  ),
                ),
              ),
              // Số liệu chính
              Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.grey.shade300
                : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
