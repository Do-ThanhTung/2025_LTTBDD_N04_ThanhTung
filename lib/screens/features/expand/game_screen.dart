import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';
import 'games/flashcard_game.dart';
import 'games/guessing_game.dart';
import 'games/matching_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _gameType = 'menu';
  int _totalTrophies = 0;
  int _matchingTrophies = 0;
  int _guessingTrophies = 0;

  String _t(String key) => AppLocalizations.t(context, key);
  String _tr(String key, {Map<String, String>? params}) =>
      AppLocalizations.tr(context, key, params: params);

  @override
  void initState() {
    super.initState();
    _loadTrophies();
  }

  Future<void> _loadTrophies() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _matchingTrophies = prefs.getInt('matching_trophies') ?? 0;
      _guessingTrophies = prefs.getInt('guessing_trophies') ?? 0;
      _totalTrophies = _matchingTrophies + _guessingTrophies;
    });
  }

  Future<void> _saveTrophies() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('matching_trophies', _matchingTrophies);
    await prefs.setInt('guessing_trophies', _guessingTrophies);
  }

  void _updateTrophies(String gameType, int trophies) {
    setState(() {
      if (gameType == 'matching') {
        _matchingTrophies += trophies;
      } else if (gameType == 'guessing') {
        _guessingTrophies += trophies;
      }
      _totalTrophies = _matchingTrophies + _guessingTrophies;
    });
    _saveTrophies();
  }

  void _startFlashcards() {
    setState(() {
      _gameType = 'flashcard';
    });
  }

  void _startMatching() {
    setState(() {
      _gameType = 'matching';
    });
  }

  void _startGuessing() {
    setState(() {
      _gameType = 'guessing';
    });
  }

  void _backToMenu() {
    setState(() {
      _gameType = 'menu';
    });
    _loadTrophies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
      child: _buildCurrentGame(),
    );
  }

  Widget _buildCurrentGame() {
    switch (_gameType) {
      case 'flashcard':
        return KeyedSubtree(
          key: const ValueKey('flashcard'),
          child: FlashcardGame(
            onBack: _backToMenu,
            onUpdateTrophies: (trophies) =>
                {}, // Flashcard game doesn't award trophies
          ),
        );
      case 'matching':
        return KeyedSubtree(
          key: const ValueKey('matching'),
          child: MatchingGame(
            onBack: _backToMenu,
            onUpdateTrophies: (trophies, {String? gameType}) =>
                _updateTrophies('matching', trophies),
          ),
        );
      case 'guessing':
        return KeyedSubtree(
          key: const ValueKey('guessing'),
          child: GuessingGame(
            onBack: _backToMenu,
            onUpdateTrophies: (trophies, {String? gameType}) =>
                _updateTrophies('guessing', trophies),
          ),
        );
      default:
        return KeyedSubtree(
          key: const ValueKey('menu'),
          child: _buildGameMenu(),
        );
    }
  }

  Widget _buildGameMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1a1a2e) : const Color(0xFFFCE4EC),
      body: Hero(
        tag: 'hero_game',
        child: Column(
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEC407A),
                    Color(0xFFE91E63),
                    Color(0xFFD81B60),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Colors.white.withAlpha((0.2 * 255).round()),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _t('games_title'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Trophy Display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_totalTrophies',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Game cards
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildGameCard(
                    title: _t('flashcard_menu_title'),
                    subtitle: _t('flashcard_menu_description'),
                    badge: _t('flashcard_menu_badge'),
                    icon: Icons.star_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D8EF5), Color(0xFF7B6BE8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_flashcard',
                    onTap: _startFlashcards,
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    title: _t('matching_menu_title'),
                    subtitle: _t('matching_menu_description'),
                    badge: _tr('game_trophies_badge',
                        params: {'count': '$_matchingTrophies'}),
                    icon: Icons.emoji_events_outlined,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5EC9B4), Color(0xFF4BB9A5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_matching',
                    onTap: _startMatching,
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    title: _t('guessing_menu_title'),
                    subtitle: _t('guessing_menu_description'),
                    badge: _tr('game_trophies_badge',
                        params: {'count': '$_guessingTrophies'}),
                    icon: Icons.lightbulb_outline,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5BA3E8), Color(0xFF4A8DD4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_guessing',
                    onTap: _startGuessing,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required String badge,
    required IconData icon,
    required Gradient gradient,
    required String heroTag,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800.withAlpha((0.6 * 255).round())
              : Colors.white.withAlpha((0.9 * 255).round()),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (gradient as LinearGradient)
                .colors
                .first
                .withAlpha((0.3 * 255).round()),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.last.withAlpha((0.15 * 255).round()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
