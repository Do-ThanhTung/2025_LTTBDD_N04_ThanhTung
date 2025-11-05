import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../models/expand_screen/story_screen.dart';
import '../../../models/expand_screen/game_screen.dart';
import '../../../models/expand_screen/translation_screen.dart';
import 'dictionary_screen.dart';

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

  Future<void> _loadStats() async {
    final prefs =
        await SharedPreferences.getInstance();
    setState(() {
      _searchCount = prefs.getInt('search_count') ?? 0;
      _gamesPlayed = prefs.getInt('games_played') ?? 0;
      _totalTrophies =
          prefs.getInt('total_trophies') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Color>(
        valueListenable: AppPrimaryColor.color,
        builder: (context, primaryColor, _) {
          final isDark =
              Theme.of(context).brightness ==
                  Brightness.dark;

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
                            color:
                                const Color(0xFF2196F3)
                                    .withOpacity(0.3),
                            blurRadius: 20,
                            offset:
                                const Offset(0, 10),
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(
                                20, 20, 20, 60),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.t(
                                  context,
                                  'study_chill'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color:
                                        Colors.black26,
                                    offset:
                                        Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.t(
                                  context,
                                  'learn_more_fun'),
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
                    ),

                    // Feature Cards Grid (2x2)
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
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
                                    title: AppLocalizations.t(
                                        context,
                                        'dictionary'),
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
                                    title: AppLocalizations.t(
                                        context,
                                        'translation'),
                                    icon: Icons
                                        .translate,
                                    gradient:
                                        const LinearGradient(
                                      begin: Alignment
                                          .topRight,
                                      end: Alignment
                                          .bottomLeft,
                                      colors: [
                                        Color(
                                            0xFF64B5F6),
                                        Color(
                                            0xFF42A5F5),
                                        Color(
                                            0xFF2196F3),
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
                                    title: 'Game',
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
                                    heroTag:
                                        'hero_game',
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
                                    title: AppLocalizations.t(
                                        context,
                                        'short_stories'),
                                    icon: Icons
                                        .menu_book,
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
                              decoration:
                                  BoxDecoration(
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
                                        .withAlpha((0.05 *
                                                255)
                                            .round()),
                                    blurRadius: 10,
                                    offset:
                                        const Offset(
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
                                    'Thống kê',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color: isDark
                                          ? Colors
                                              .white
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
                                        'Từ',
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
                                        'Trò chơi',
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
                                        'Cúp',
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
      ),
    );
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
    List<Widget> _buildCircles() {
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
                color: Colors.white.withOpacity(0.12),
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
                color: Colors.white.withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.08),
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
                color: Colors.white.withOpacity(0.13),
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
                color: Colors.white.withOpacity(0.09),
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
                color: Colors.white.withOpacity(0.07),
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
                color: Colors.white.withOpacity(0.11),
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
                color: Colors.white.withOpacity(0.14),
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
                color: Colors.white.withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.08),
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
                color: Colors.white.withOpacity(0.12),
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
                color: Colors.white.withOpacity(0.09),
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
                color: Colors.white.withOpacity(0.13),
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
                color: Colors.white.withOpacity(0.11),
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
                color: Colors.white.withOpacity(0.09),
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
                color: Colors.white.withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.07),
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
                color: Colors.white.withOpacity(0.08),
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
                  ..._buildCircles(),
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
                                    .withOpacity(0.1),
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
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: gradient.colors.last
                    .withOpacity(0.2),
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
                    color:
                        Colors.white.withOpacity(0.15),
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
                    color:
                        Colors.white.withOpacity(0.1),
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
                    color:
                        Colors.white.withOpacity(0.08),
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
                    color:
                        Colors.white.withOpacity(0.12),
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
