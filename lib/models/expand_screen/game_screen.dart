import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlashCard {
  final String word;
  final String meaning;
  final String example;

  FlashCard(
      {required this.word,
      required this.meaning,
      required this.example});
}

class MatchingPair {
  final int id;
  final String word;
  final String meaning;

  MatchingPair(
      {required this.id,
      required this.word,
      required this.meaning});
}

class GuessingWord {
  final String word;
  final String hint;
  final String definition;
  final String difficulty;

  GuessingWord({
    required this.word,
    required this.hint,
    required this.definition,
    required this.difficulty,
  });
}

// Sample data - Danh sách từ vựng đầy đủ
final List<FlashCard> flashCards = [
  FlashCard(
    word: 'Abundant',
    meaning: 'Dồi dào, phong phú',
    example: 'The garden has abundant flowers.',
  ),
  FlashCard(
    word: 'Achieve',
    meaning: 'Đạt được, giành được',
    example: 'She worked hard to achieve her goals.',
  ),
  FlashCard(
    word: 'Brilliant',
    meaning: 'Tài giỏi, xuất sắc',
    example: 'He is a brilliant student.',
  ),
  FlashCard(
    word: 'Curious',
    meaning: 'Tò mò, hiếu kỳ',
    example: 'Children are naturally curious.',
  ),
  FlashCard(
    word: 'Delightful',
    meaning: 'Thú vị, đáng yêu',
    example: 'We had a delightful evening.',
  ),
  FlashCard(
    word: 'Elegant',
    meaning: 'Thanh lịch, tao nhã',
    example: 'She wore an elegant dress.',
  ),
  FlashCard(
    word: 'Fantastic',
    meaning: 'Tuyệt vời, xuất sắc',
    example: 'That was a fantastic performance!',
  ),
  FlashCard(
    word: 'Grateful',
    meaning: 'Biết ơn, cảm kích',
    example: 'I am grateful for your help.',
  ),
  FlashCard(
    word: 'Humble',
    meaning: 'Khiêm tốn, khiêm nhường',
    example:
        'Despite his success, he remained humble.',
  ),
  FlashCard(
    word: 'Impressive',
    meaning: 'Ấn tượng, gây ấn tượng',
    example: 'Your work is very impressive.',
  ),
  FlashCard(
    word: 'Joyful',
    meaning: 'Vui vẻ, hân hoan',
    example: 'It was a joyful celebration.',
  ),
  FlashCard(
    word: 'Knowledge',
    meaning: 'Kiến thức, hiểu biết',
    example: 'Knowledge is power.',
  ),
  FlashCard(
    word: 'Lovely',
    meaning: 'Đáng yêu, dễ thương',
    example: 'What a lovely surprise!',
  ),
  FlashCard(
    word: 'Magnificent',
    meaning: 'Tuyệt đẹp, lộng lẫy',
    example: 'The view from the top was magnificent.',
  ),
  FlashCard(
    word: 'Noble',
    meaning: 'Cao quý, cao thượng',
    example: 'That was a noble gesture.',
  ),
  FlashCard(
    word: 'Optimistic',
    meaning: 'Lạc quan, tích cực',
    example: 'She has an optimistic outlook on life.',
  ),
  FlashCard(
    word: 'Peaceful',
    meaning: 'Yên bình, thanh bình',
    example: 'The countryside is very peaceful.',
  ),
  FlashCard(
    word: 'Remarkable',
    meaning: 'Đáng chú ý, xuất sắc',
    example: 'Her achievements are truly remarkable.',
  ),
  FlashCard(
    word: 'Sincere',
    meaning: 'Chân thành, thành thật',
    example: 'Please accept my sincere apologies.',
  ),
  FlashCard(
    word: 'Talented',
    meaning: 'Tài năng, có năng khiếu',
    example: 'She is a talented musician.',
  ),
];

final List<MatchingPair> allMatchingWords = [
  MatchingPair(
      id: 1, word: 'Happy', meaning: 'Vui vẻ'),
  MatchingPair(id: 2, word: 'Sad', meaning: 'Buồn'),
  MatchingPair(
      id: 3, word: 'Angry', meaning: 'Tức giận'),
  MatchingPair(
      id: 4, word: 'Excited', meaning: 'Phấn khích'),
  MatchingPair(
      id: 5, word: 'Tired', meaning: 'Mệt mỏi'),
  MatchingPair(id: 6, word: 'Hungry', meaning: 'Đói'),
  MatchingPair(
      id: 7, word: 'Brave', meaning: 'Dũng cảm'),
  MatchingPair(
      id: 8, word: 'Clever', meaning: 'Thông minh'),
  MatchingPair(
      id: 9, word: 'Friendly', meaning: 'Thân thiện'),
  MatchingPair(
      id: 10, word: 'Gentle', meaning: 'Hiền lành'),
  MatchingPair(
      id: 11, word: 'Honest', meaning: 'Trung thực'),
  MatchingPair(
      id: 12, word: 'Kind', meaning: 'Tốt bụng'),
  MatchingPair(
      id: 13, word: 'Lazy', meaning: 'Lười biếng'),
  MatchingPair(
      id: 14, word: 'Nervous', meaning: 'Lo lắng'),
  MatchingPair(
      id: 15, word: 'Proud', meaning: 'Tự hào'),
  MatchingPair(
      id: 16, word: 'Quiet', meaning: 'Yên tĩnh'),
  MatchingPair(
      id: 17, word: 'Rude', meaning: 'Thô lỗ'),
  MatchingPair(
      id: 18, word: 'Shy', meaning: 'Ngại ngùng'),
];

final List<GuessingWord> allGuessingWords = [
  GuessingWord(
    word: 'beautiful',
    hint: 'b _ _ _ _ _ f _ _',
    definition:
        'Pleasing the senses or mind aesthetically',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'happy',
    hint: 'h _ _ p _',
    definition: 'Feeling or showing pleasure',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'curious',
    hint: 'c _ _ i _ _ s',
    definition: 'Eager to learn or know something',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'abundant',
    hint: 'a _ _ _ d _ _ t',
    definition: 'Existing in large quantities',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'delightful',
    hint: 'd _ _ i _ _ t _ _ _',
    definition: 'Causing delight; charming',
    difficulty: 'hard',
  ),
  GuessingWord(
    word: 'wonderful',
    hint: 'w _ _ d _ _ f _ _',
    definition:
        'Inspiring delight, pleasure, or admiration',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'amazing',
    hint: 'a _ _ z _ _ g',
    definition: 'Causing great surprise or wonder',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'brilliant',
    hint: 'b _ _ l l _ _ _ t',
    definition: 'Exceptionally clever or talented',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'excellent',
    hint: 'e _ _ e l _ _ _ t',
    definition: 'Extremely good; outstanding',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'magnificent',
    hint: 'm _ _ n _ _ i _ _ _ t',
    definition: 'Impressively beautiful or great',
    difficulty: 'hard',
  ),
  GuessingWord(
    word: 'extraordinary',
    hint: 'e _ _ r _ _ r d _ _ _ _ y',
    definition: 'Very unusual or remarkable',
    difficulty: 'hard',
  ),
  GuessingWord(
    word: 'fantastic',
    hint: 'f _ _ t _ _ t _ c',
    definition: 'Extraordinarily good or attractive',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'grateful',
    hint: 'g _ _ t _ f _ _',
    definition: 'Feeling or showing appreciation',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'peaceful',
    hint: 'p _ _ c _ f _ _',
    definition: 'Free from disturbance; tranquil',
    difficulty: 'easy',
  ),
  GuessingWord(
    word: 'sincere',
    hint: 's _ _ c _ r _',
    definition: 'Free from pretense or deceit',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'talented',
    hint: 't _ _ e _ t _ d',
    definition: 'Having a natural aptitude or skill',
    difficulty: 'medium',
  ),
  GuessingWord(
    word: 'remarkable',
    hint: 'r _ _ a r _ _ _ l _',
    definition: 'Worthy of attention; extraordinary',
    difficulty: 'hard',
  ),
  GuessingWord(
    word: 'optimistic',
    hint: 'o _ _ i _ _ s t _ c',
    definition:
        'Hopeful and confident about the future',
    difficulty: 'hard',
  ),
];

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() =>
      _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String _gameType = 'menu';
  int _totalTrophies = 0; // Total trophies accumulated
  int _matchingTrophies =
      0; // Trophies from matching game
  int _guessingTrophies =
      0; // Trophies from guessing game

  // Flashcard state
  int _currentCardIndex = 0;
  bool _showAnswer = false;
  int _score = 0;
  List<FlashCard> _shuffledFlashCards = [];

  // Matching game state
  int? _selectedEnglishId;
  List<int> _matchedPairs = [];
  List<MatchingPair> _shuffledEnglishWords = [];
  List<MatchingPair> _shuffledMeanings = [];
  int? _wrongEnglishId;
  int? _wrongVietnameseId;

  // Word guessing state
  int _currentWordIndex = 0;
  String _userGuess = '';
  bool _showResult = false;
  bool _isCorrect = false;
  int _hintsUsed = 0;
  List<GuessingWord> _shuffledGuessingWords = [];
  final _guessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrophies();
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  Future<void> _loadTrophies() async {
    final prefs =
        await SharedPreferences.getInstance();
    setState(() {
      _totalTrophies =
          prefs.getInt('total_trophies') ?? 0;
      _matchingTrophies =
          prefs.getInt('matching_trophies') ?? 0;
      _guessingTrophies =
          prefs.getInt('guessing_trophies') ?? 0;
    });
  }

  Future<void> _saveTrophies() async {
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setInt(
        'total_trophies', _totalTrophies);
    await prefs.setInt(
        'matching_trophies', _matchingTrophies);
    await prefs.setInt(
        'guessing_trophies', _guessingTrophies);
  }

  Future<void> _incrementGamesPlayed() async {
    final prefs =
        await SharedPreferences.getInstance();
    int currentCount =
        prefs.getInt('games_played') ?? 0;
    await prefs.setInt(
        'games_played', currentCount + 1);
  }

  void _updateTrophies(int change,
      {String? gameType}) {
    setState(() {
      _totalTrophies += change;
      if (_totalTrophies < 0)
        _totalTrophies = 0; // Không cho phép âm

      // Cập nhật cúp riêng cho từng trò chơi
      if (gameType == 'matching') {
        _matchingTrophies += change;
        if (_matchingTrophies < 0)
          _matchingTrophies = 0;
      } else if (gameType == 'guessing') {
        _guessingTrophies += change;
        if (_guessingTrophies < 0)
          _guessingTrophies = 0;
      }
    });
    _saveTrophies();
  }

  void _startFlashcards() {
    setState(() {
      _gameType = 'flashcard';
      // Chọn ngẫu nhiên 20 thẻ từ danh sách
      final shuffledAll =
          List<FlashCard>.from(flashCards)..shuffle();
      _shuffledFlashCards =
          shuffledAll.take(20).toList();
      _currentCardIndex = 0;
      _showAnswer = false;
      _score = 0;
    });
  }

  void _startMatching() {
    setState(() {
      _gameType = 'matching';
      _score = 0;
      _selectedEnglishId = null;
      _matchedPairs = [];
      _wrongEnglishId = null;
      _wrongVietnameseId = null;
      // Chọn ngẫu nhiên 6 cặp từ danh sách đầy đủ
      final shuffledAll =
          List<MatchingPair>.from(allMatchingWords)
            ..shuffle();
      final selectedPairs =
          shuffledAll.take(6).toList();
      // Xáo trộn cột Tiếng Anh
      _shuffledEnglishWords =
          List<MatchingPair>.from(selectedPairs)
            ..shuffle();
      // Xáo trộn cột Tiếng Việt riêng biệt
      _shuffledMeanings =
          List<MatchingPair>.from(selectedPairs)
            ..shuffle();
    });
  }

  void _startGuessing() {
    setState(() {
      _gameType = 'guessing';
      // Chọn ngẫu nhiên 5 từ để đoán
      final shuffledAll =
          List<GuessingWord>.from(allGuessingWords)
            ..shuffle();
      _shuffledGuessingWords =
          shuffledAll.take(5).toList();
      _currentWordIndex = 0;
      _userGuess = '';
      _showResult = false;
      _score = 0;
      _hintsUsed = 0;
      _guessController.clear();
    });
  }

  void _handleNextCard() {
    if (_currentCardIndex <
        _shuffledFlashCards.length - 1) {
      setState(() {
        _currentCardIndex++;
        _showAnswer = false;
      });
    } else {
      // Flashcard game hoàn thành
      _incrementGamesPlayed();
      setState(() => _gameType = 'menu');
    }
  }

  void _handleKnowCard() {
    setState(() => _score++);
    _handleNextCard();
  }

  void _handleWordClick(
      int wordId, bool isEnglishSide) {
    if (_matchedPairs.contains(wordId)) return;

    setState(() {
      if (isEnglishSide) {
        // Clicking English side
        if (_selectedEnglishId == wordId) {
          // Deselect if clicking same word
          _selectedEnglishId = null;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;
        } else {
          // Select new English word
          _selectedEnglishId = wordId;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;
        }
      } else {
        // Clicking Vietnamese side - must have English selected first
        if (_selectedEnglishId == null) {
          // No English word selected yet - show error briefly
          _wrongVietnameseId = wordId;
          Future.delayed(
              const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(
                  () => _wrongVietnameseId = null);
            }
          });
          return;
        }

        // Check if match is correct
        if (_selectedEnglishId == wordId) {
          // Correct match!
          _matchedPairs.add(wordId);
          _score++;
          _updateTrophies(1,
              gameType:
                  'matching'); // +1 trophy for correct match
          _selectedEnglishId = null;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;

          // Kiểm tra nếu hoàn thành tất cả
          if (_matchedPairs.length ==
              _shuffledEnglishWords.length) {
            _incrementGamesPlayed();
          }
        } else {
          // Wrong match
          if (_score > 0) _score--;
          _updateTrophies(-1,
              gameType:
                  'matching'); // -1 trophy for wrong match
          _wrongEnglishId = _selectedEnglishId;
          _wrongVietnameseId = wordId;

          // Reset after delay
          Future.delayed(
              const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _selectedEnglishId = null;
                _wrongEnglishId = null;
                _wrongVietnameseId = null;
              });
            }
          });
        }
      }
    });
  }

  void _handleGuessSubmit() {
    final currentWord =
        _shuffledGuessingWords[_currentWordIndex];
    final correct = _userGuess.toLowerCase().trim() ==
        currentWord.word.toLowerCase();

    setState(() {
      _isCorrect = correct;
      _showResult = true;

      if (correct) {
        final points = currentWord.difficulty == 'easy'
            ? 10
            : currentWord.difficulty == 'medium'
                ? 15
                : 20;
        final penalty = _hintsUsed * 2;
        final earnedPoints = max(points - penalty, 5);
        _score += earnedPoints;

        // Add trophies based on difficulty and hints used
        int trophies = currentWord.difficulty == 'easy'
            ? 1
            : currentWord.difficulty == 'medium'
                ? 2
                : 3;
        if (_hintsUsed > 0)
          trophies = max(1, trophies - _hintsUsed);
        _updateTrophies(trophies,
            gameType: 'guessing');
      }
    });
  }

  void _handleNextWord() {
    if (_currentWordIndex <
        _shuffledGuessingWords.length - 1) {
      setState(() {
        _currentWordIndex++;
        _userGuess = '';
        _showResult = false;
        _hintsUsed = 0;
        _guessController.clear();
      });
    } else {
      // Guessing game hoàn thành
      _incrementGamesPlayed();
      setState(() => _gameType = 'menu');
    }
  }

  void _useHint() {
    if (_hintsUsed < 3) {
      // Tăng từ 2 lên 3 hints
      setState(() => _hintsUsed++);
    }
  }

  String _getHintText() {
    final currentWord =
        _shuffledGuessingWords[_currentWordIndex];
    if (_hintsUsed == 0) return currentWord.hint;
    if (_hintsUsed == 1) {
      // Hint 1: Show first and last letters
      final word = currentWord.word;
      return '${word[0]} ${'_ ' * (word.length - 2)}${word[word.length - 1]}';
    }
    if (_hintsUsed == 2) {
      // Hint 2: Show half of the word
      final word = currentWord.word;
      final revealed = (word.length / 2).ceil();
      return word
          .split('')
          .asMap()
          .entries
          .map((e) => e.key < revealed ? e.value : '_')
          .join(' ');
    }
    // Hint 3: Show all but 2 letters
    final word = currentWord.word;
    final hidden = min(2, word.length - 1);
    return word
        .split('')
        .asMap()
        .entries
        .map((e) => e.key < word.length - hidden
            ? e.value
            : '_')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder:
          (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0)
                .animate(
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
          child: _buildFlashcardGame(),
        );
      case 'matching':
        return KeyedSubtree(
          key: const ValueKey('matching'),
          child: _buildMatchingGame(),
        );
      case 'guessing':
        return KeyedSubtree(
          key: const ValueKey('guessing'),
          child: _buildGuessingGame(),
        );
      default:
        return KeyedSubtree(
          key: const ValueKey('menu'),
          child: _buildGameMenu(),
        );
    }
  }

  Widget _buildGameMenu() {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF1a1a2e)
          : const Color(0xFFFCE4EC),
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
                  bottom: 24),
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pop(context),
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                                    8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                                  .withAlpha(
                                      (0.2 * 255)
                                          .round()),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Trò chơi học tập',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Trophy Display
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber
                            .withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.amber,
                            width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '$_totalTrophies',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
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
                    title: 'Thẻ ghi nhớ',
                    subtitle:
                        'Kiểm tra vốn từ vựng với thẻ ghi nhớ tương tác',
                    badge: '20 thẻ',
                    icon: Icons.star_outline,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9D8EF5),
                        Color(0xFF7B6BE8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_flashcard',
                    onTap: () {
                      _startFlashcards();
                      // Không cần setState vì _startFlashcards đã gọi
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    title: 'Ghép đôi',
                    subtitle:
                        'Ghép từ tiếng Anh với nghĩa tiếng Việt',
                    badge: '$_matchingTrophies 🏆',
                    icon: Icons.emoji_events_outlined,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF5EC9B4),
                        Color(0xFF4BB9A5)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_matching',
                    onTap: () {
                      _startMatching();
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    title: 'Đoán từ',
                    subtitle:
                        'Đoán từ dựa trên gợi ý và định nghĩa',
                    badge: '$_guessingTrophies 🏆',
                    icon: Icons.lightbulb_outline,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF5BA3E8),
                        Color(0xFF4A8DD4)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    heroTag: 'game_guessing',
                    onTap: () {
                      _startGuessing();
                    },
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
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800
                  .withAlpha((0.6 * 255).round())
              : Colors.white
                  .withAlpha((0.9 * 255).round()),
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
              color: (gradient)
                  .colors
                  .last
                  .withAlpha((0.15 * 255).round()),
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
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius:
                    BorderRadius.circular(12),
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

  Widget _buildFlashcardGame() {
    final currentCard =
        _shuffledFlashCards[_currentCardIndex];
    final progress = ((_currentCardIndex + 1) /
        _shuffledFlashCards.length);
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9D8EF5),
                  Color(0xFF7B6BE8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(
                            () => _gameType = 'menu'),
                        child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28),
                      ),
                      const Text(
                        'Thẻ ghi nhớ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: 18),
                            const SizedBox(width: 4),
                            Text(
                                '$_score/${_shuffledFlashCards.length}',
                                style: const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white
                        .withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(Colors.white),
                    minHeight: 6,
                    borderRadius:
                        BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thẻ ${_currentCardIndex + 1} trong số ${_shuffledFlashCards.length}',
                    style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: 0.8),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() =>
                        _showAnswer = !_showAnswer),
                    child: Container(
                      height: 320,
                      padding:
                          const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(
                                      0xFF2D2D2D),
                                  const Color(
                                      0xFF1A1A1A)
                                ]
                              : [
                                  Colors.white,
                                  const Color(
                                      0xFFF8F5FF)
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF9D8EF5)
                                    .withValues(
                                        alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: !_showAnswer
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration:
                                        BoxDecoration(
                                      gradient:
                                          const LinearGradient(
                                        colors: [
                                          Color(
                                              0xFF9D8EF5),
                                          Color(
                                              0xFF7B6BE8)
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  32),
                                    ),
                                    child: const Icon(
                                        Icons.star,
                                        color: Colors
                                            .white,
                                        size: 32),
                                  ),
                                  const SizedBox(
                                      height: 24),
                                  Text(
                                    currentCard.word,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color: isDark
                                          ? Colors
                                              .white
                                          : Colors
                                              .black87,
                                    ),
                                    textAlign:
                                        TextAlign
                                            .center,
                                  ),
                                  const SizedBox(
                                      height: 16),
                                  Text(
                                    'Nhấn để xem nghĩa',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(
                                          0xFF9D8EF5),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  const Text('✨',
                                      style: TextStyle(
                                          fontSize:
                                              48)),
                                  const SizedBox(
                                      height: 16),
                                  Text(
                                    currentCard
                                        .meaning,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color: isDark
                                          ? Colors
                                              .white
                                          : Colors
                                              .black87,
                                    ),
                                    textAlign:
                                        TextAlign
                                            .center,
                                  ),
                                  const SizedBox(
                                      height: 16),
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(16),
                                    decoration:
                                        BoxDecoration(
                                      gradient:
                                          LinearGradient(
                                        colors: [
                                          const Color(
                                                  0xFFFFF3E0)
                                              .withValues(
                                                  alpha: isDark
                                                      ? 0.2
                                                      : 1.0),
                                          const Color(
                                                  0xFFFFE0B2)
                                              .withValues(
                                                  alpha: isDark
                                                      ? 0.2
                                                      : 1.0),
                                        ],
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  12),
                                    ),
                                    child: Text(
                                      '"${currentCard.example}"',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontStyle:
                                            FontStyle
                                                .italic,
                                        color: isDark
                                            ? Colors
                                                .white70
                                            : Colors
                                                .black54,
                                      ),
                                      textAlign:
                                          TextAlign
                                              .center,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handleNextCard,
                          style:
                              OutlinedButton.styleFrom(
                            padding: const EdgeInsets
                                .symmetric(
                                vertical: 16),
                            side: BorderSide(
                                color: isDark
                                    ? Colors.white30
                                    : Colors
                                        .grey.shade300,
                                width: 2),
                            shape:
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16)),
                          ),
                          child: Text('Bỏ qua',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white
                                      : Colors
                                          .black87)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _showAnswer
                              ? _handleKnowCard
                              : null,
                          style:
                              ElevatedButton.styleFrom(
                            padding: const EdgeInsets
                                .symmetric(
                                vertical: 16),
                            backgroundColor:
                                const Color(
                                    0xFF4CAF50),
                            disabledBackgroundColor:
                                Colors.grey.shade300,
                            shape:
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16)),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: const [
                              Icon(Icons.check_circle,
                                  size: 20),
                              SizedBox(width: 8),
                              Text('Tôi biết từ này',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingGame() {
    final isComplete = _matchedPairs.length ==
        _shuffledEnglishWords.length;
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5EC9B4),
                  Color(0xFF4BB9A5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(
                        () => _gameType = 'menu'),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),
                  const Text(
                    'Ghép đôi',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.amber,
                            size: 18),
                        const SizedBox(width: 4),
                        Text('$_score',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Game content
          Expanded(
            child: isComplete
                ? _buildMatchingComplete()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Ghép từ tiếng Anh với nghĩa tiếng Việt ✨',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Stack(
                            children: [
                              // Main content with word buttons
                              Row(
                                children: [
                                  // English words
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical:
                                                  12),
                                          decoration:
                                              BoxDecoration(
                                            gradient:
                                                const LinearGradient(
                                              colors: [
                                                Color(
                                                    0xFF5BA3E8),
                                                Color(
                                                    0xFF4A8DD4)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    16),
                                          ),
                                          child:
                                              const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            children: [
                                              Text(
                                                  '🇬🇧',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                  width:
                                                      8),
                                              Text(
                                                  'English',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                12),
                                        Expanded(
                                          child: ListView
                                              .builder(
                                            itemCount:
                                                _shuffledEnglishWords
                                                    .length,
                                            itemBuilder:
                                                (context,
                                                    index) {
                                              final item =
                                                  _shuffledEnglishWords[
                                                      index];
                                              final isMatched =
                                                  _matchedPairs
                                                      .contains(item.id);
                                              final isSelected =
                                                  _selectedEnglishId ==
                                                      item.id;
                                              final isWrong =
                                                  _wrongEnglishId ==
                                                      item.id;

                                              return Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    bottom: 8),
                                                child:
                                                    _buildMatchButton(
                                                  text:
                                                      item.word,
                                                  isMatched:
                                                      isMatched,
                                                  isSelected:
                                                      isSelected,
                                                  isWrong:
                                                      isWrong,
                                                  onTap: () => _handleWordClick(
                                                      item.id,
                                                      true),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF5BA3E8),
                                                      Color(0xFF4A8DD4)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  // Vietnamese meanings
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical:
                                                  12),
                                          decoration:
                                              BoxDecoration(
                                            gradient:
                                                const LinearGradient(
                                              colors: [
                                                Color(
                                                    0xFF9D8EF5),
                                                Color(
                                                    0xFF7B6BE8)
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    16),
                                          ),
                                          child:
                                              const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                            children: [
                                              Text(
                                                  '🇻🇳',
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                  width:
                                                      8),
                                              Text(
                                                  'Tiếng Việt',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                12),
                                        Expanded(
                                          child: ListView
                                              .builder(
                                            itemCount:
                                                _shuffledMeanings
                                                    .length,
                                            itemBuilder:
                                                (context,
                                                    index) {
                                              final item =
                                                  _shuffledMeanings[
                                                      index];
                                              final isMatched =
                                                  _matchedPairs
                                                      .contains(item.id);
                                              final isSelected =
                                                  false;
                                              final isWrong =
                                                  _wrongVietnameseId ==
                                                      item.id;

                                              return Padding(
                                                padding: const EdgeInsets
                                                    .only(
                                                    bottom: 8),
                                                child:
                                                    _buildMatchButton(
                                                  text:
                                                      item.meaning,
                                                  isMatched:
                                                      isMatched,
                                                  isSelected:
                                                      isSelected,
                                                  isWrong:
                                                      isWrong,
                                                  onTap: () => _handleWordClick(
                                                      item.id,
                                                      false),
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF9D8EF5),
                                                      Color(0xFF7B6BE8)
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
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
        ],
      ),
    );
  }

  Widget _buildMatchButton({
    required String text,
    required bool isMatched,
    required bool isSelected,
    required bool isWrong,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return GestureDetector(
      onTap: isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isMatched
              ? const LinearGradient(colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF45A049)
                ])
              : isWrong
                  ? const LinearGradient(colors: [
                      Color(0xFFE91E63),
                      Color(0xFFD81B60)
                    ])
                  : isSelected
                      ? gradient
                      : null,
          color: !isMatched && !isSelected && !isWrong
              ? (isDark
                  ? const Color(0xFF2D2D2D)
                  : Colors.white)
              : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMatched
                ? Colors.transparent
                : isWrong
                    ? Colors.transparent
                    : isSelected
                        ? Colors.transparent
                        : (isDark
                            ? Colors.white24
                            : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: isSelected || isMatched || isWrong
              ? [
                  BoxShadow(
                    color: (isMatched
                            ? Colors.green
                            : isWrong
                                ? Colors.red
                                : (gradient
                                        as LinearGradient)
                                    .colors
                                    .first)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight:
                isSelected || isMatched || isWrong
                    ? FontWeight.bold
                    : FontWeight.w500,
            color: isMatched || isSelected || isWrong
                ? Colors.white
                : (isDark
                    ? Colors.white
                    : Colors.black87),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMatchingComplete() {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFC107),
                    Color(0xFFFF9800)
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events,
                  color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              '🎉 Chúc mừng!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bạn đã ghép đúng tất cả!',
              style: TextStyle(
                fontSize: 18,
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5EC9B4),
                    Color(0xFF4BB9A5)
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5EC9B4)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                '$_score điểm',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startMatching,
              icon: const Icon(Icons.refresh),
              label: const Text('Chơi lại',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                backgroundColor:
                    const Color(0xFF5EC9B4),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuessingGame() {
    final currentWord =
        _shuffledGuessingWords[_currentWordIndex];
    final progress = ((_currentWordIndex + 1) /
        _shuffledGuessingWords.length);
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF5BA3E8),
                  Color(0xFF4A8DD4)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => setState(
                            () => _gameType = 'menu'),
                        child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28),
                      ),
                      const Text(
                        'Đoán từ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: 18),
                            const SizedBox(width: 4),
                            Text('$_score',
                                style: const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white
                        .withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(Colors.white),
                    minHeight: 6,
                    borderRadius:
                        BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Từ ${_currentWordIndex + 1} trong số ${_shuffledGuessingWords.length}',
                    style: TextStyle(
                        color: Colors.white
                            .withValues(alpha: 0.8),
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Game content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: !_showResult
                  ? _buildGuessingInput(
                      currentWord, isDark)
                  : _buildGuessingResult(
                      currentWord, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuessingInput(
      GuessingWord currentWord, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2D2D2D)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đoán từ này',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentWord.difficulty ==
                          'easy'
                      ? const Color(0xFF4CAF50)
                      : currentWord.difficulty ==
                              'medium'
                          ? const Color(0xFFFFC107)
                          : const Color(0xFFE91E63),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  currentWord.difficulty == 'easy'
                      ? 'Dễ'
                      : currentWord.difficulty ==
                              'medium'
                          ? 'Trung bình'
                          : 'Khó',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Hint
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5BA3E8)
                      .withValues(alpha: 0.1),
                  const Color(0xFF4A8DD4)
                      .withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _getHintText(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '(${currentWord.word.length} chữ cái)',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white54
                        : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Definition
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0)
                  .withValues(
                      alpha: isDark ? 0.1 : 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    size: 20,
                    color: Color(0xFFFF9800)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Định nghĩa:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white70
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentWord.definition,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.white70
                              : Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Hints used display
          if (_hintsUsed > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE3F2FD).withValues(
                        alpha: isDark ? 0.2 : 1.0),
                    const Color(0xFFBBDEFB).withValues(
                        alpha: isDark ? 0.2 : 1.0),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF5BA3E8)
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 20,
                    color: const Color(0xFF5BA3E8)
                        .withValues(
                            alpha: isDark ? 0.8 : 1.0),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _hintsUsed == 1
                          ? 'Đã dùng 1 gợi ý: Chữ đầu và chữ cuối (-2 điểm)'
                          : 'Đã dùng 2 gợi ý: Hiển thị nửa từ (-4 điểm)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF1565C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Input
          TextField(
            controller: _guessController,
            onChanged: (value) =>
                setState(() => _userGuess = value),
            onSubmitted: _userGuess.isNotEmpty
                ? (_) => _handleGuessSubmit()
                : null,
            style: TextStyle(
                fontSize: 18,
                color: isDark
                    ? Colors.white
                    : Colors.black87),
            decoration: InputDecoration(
              hintText: 'Nhập đáp án của bạn...',
              hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white38
                      : Colors.black38),
              filled: true,
              fillColor: isDark
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _hintsUsed >= 2
                      ? null
                      : _useHint,
                  icon: const Icon(
                      Icons.lightbulb_outline,
                      size: 20),
                  label: Text(
                      'Gợi ý (${2 - _hintsUsed})'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                            vertical: 14),
                    side: BorderSide(
                      color: _hintsUsed >= 2
                          ? (isDark
                              ? Colors.white12
                              : Colors.grey.shade200)
                          : const Color(0xFF5BA3E8),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _userGuess.isEmpty
                      ? null
                      : _handleGuessSubmit,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                            vertical: 14),
                    backgroundColor:
                        const Color(0xFF5BA3E8),
                    disabledBackgroundColor: isDark
                        ? Colors.white12
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kiểm tra',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuessingResult(
      GuessingWord currentWord, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isCorrect
              ? [
                  const Color(0xFF4CAF50).withValues(
                      alpha: isDark ? 0.3 : 0.2),
                  const Color(0xFF45A049).withValues(
                      alpha: isDark ? 0.3 : 0.2),
                ]
              : [
                  const Color(0xFFE91E63).withValues(
                      alpha: isDark ? 0.3 : 0.2),
                  const Color(0xFFD81B60).withValues(
                      alpha: isDark ? 0.3 : 0.2),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isCorrect
              ? const Color(0xFF4CAF50)
                  .withValues(alpha: 0.3)
              : const Color(0xFFE91E63)
                  .withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(_isCorrect ? '🎉' : '😅',
              style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            _isCorrect ? 'Chính xác!' : 'Chưa đúng!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          if (!_isCorrect) ...[
            const SizedBox(height: 12),
            Text(
              'Đáp án đúng: ${currentWord.word}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            currentWord.definition,
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? Colors.white60
                  : Colors.black45,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _handleNextWord,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 16),
              backgroundColor: const Color(0xFF5BA3E8),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text(
              _currentWordIndex <
                      _shuffledGuessingWords.length - 1
                  ? 'Tiếp tục'
                  : 'Hoàn thành',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
