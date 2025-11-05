import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/translation_service.dart';
import '../../../services/vocabulary_service.dart';

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

final List<GuessingWord> allGuessingWords = [
  GuessingWord(
    word: 'beautiful',
    hint: 'b _ _ _ _ _ f _ _',
    definition: 'Pleasing the senses or mind aesthetically',
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
    definition: 'Inspiring delight, pleasure, or admiration',
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
    definition: 'Hopeful and confident about the future',
    difficulty: 'hard',
  ),
];

class GuessingGame extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int, {String? gameType}) onUpdateTrophies;

  const GuessingGame({
    super.key,
    required this.onBack,
    required this.onUpdateTrophies,
  });

  @override
  State<GuessingGame> createState() => _GuessingGameState();
}

class _GuessingGameState extends State<GuessingGame> {
  String _userGuess = '';
  bool _showResult = false;
  bool _isCorrect = false;
  int _hintsUsed = 0;
  late GuessingWord _currentWord;
  final _guessController = TextEditingController();
  final Set<int> _revealedPositions = {};
  bool _isLoading = true;
  List<GuessingWord> _availableWords = [];

  @override
  void initState() {
    super.initState();
    _loadAndStartGame();
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  Future<void> _loadAndStartGame() async {
    setState(() {
      _isLoading = true;
    });

    final random = Random();

    // 1. Lấy từ đã tra từ VocabularyService
    final vocabItems = await VocabularyService.instance.getVocabularyForGame();

    final words = <GuessingWord>[];

    // 2. Chuyển đổi VocabularyItem thành GuessingWord
    for (var item in vocabItems) {
      words.add(GuessingWord(
        word: item.word,
        hint: _createHint(item.word),
        definition: item.definition,
        difficulty: 'medium',
      ));
    }

    // 3. Nếu không đủ từ, bổ sung từ dữ liệu mẫu
    if (words.length < 10) {
      final sampleWords = List<GuessingWord>.from(allGuessingWords)
        ..shuffle(random);
      final needed = 10 - words.length;
      words.addAll(sampleWords.take(needed));
    }

    // 4. Shuffle
    words.shuffle(random);

    setState(() {
      _availableWords = words;
      if (_availableWords.isNotEmpty) {
        _currentWord = _availableWords.first;
        _userGuess = '';
        _showResult = false;
        _hintsUsed = 0;
        _revealedPositions.clear();
        _guessController.clear();
      }
      _isLoading = false;
    });
  }

  String _createHint(String word) {
    if (word.isEmpty) return '';
    final letters = word.toLowerCase().split('');
    final result = <String>[];
    for (int i = 0; i < letters.length; i++) {
      if (i == 0 || i == letters.length - 1) {
        result.add(letters[i]);
      } else {
        result.add('_');
      }
    }
    return result.join(' ');
  }

  void _startGame() {
    if (_availableWords.isEmpty) {
      _loadAndStartGame();
      return;
    }
    setState(() {
      final shuffled = List<GuessingWord>.from(_availableWords)..shuffle();
      _currentWord = shuffled.first;
      _userGuess = '';
      _showResult = false;
      _hintsUsed = 0;
      _revealedPositions.clear();
      _guessController.clear();
    });
  }

  void _handleGuessSubmit() {
    final isCorrect =
        _userGuess.trim().toLowerCase() == _currentWord.word.toLowerCase();

    setState(() {
      _isCorrect = isCorrect;
      _showResult = true;
    });

    if (isCorrect) {
      // Tính điểm: bắt đầu từ 10, trừ dần theo gợi ý
      int trophies = 10;
      final wordLength = _currentWord.word.length;

      // Trừ điểm dựa trên % chữ đã hiện
      if (_hintsUsed > 0) {
        final percentRevealed = _revealedPositions.length / wordLength;
        final pointsLost = (percentRevealed * 9).ceil(); // Tối đa trừ 9 điểm
        trophies = max(1, trophies - pointsLost);
      }

      widget.onUpdateTrophies(trophies, gameType: 'guessing');
    }
  }

  void _useHint() {
    if (_hintsUsed >= 3) return;

    setState(() {
      _hintsUsed++;
      final word = _currentWord.word;
      final wordLength = word.length;

      // Tính số chữ cần hiện: 90% sau 3 gợi ý
      final totalToReveal = (wordLength * 0.9).ceil();
      final random = Random();

      // Tính số chữ mới cần hiện cho gợi ý này
      int targetReveal;
      if (_hintsUsed == 1) {
        targetReveal =
            (totalToReveal * (0.30 + random.nextDouble() * 0.10)).ceil();
      } else if (_hintsUsed == 2) {
        targetReveal =
            (totalToReveal * (0.60 + random.nextDouble() * 0.10)).ceil();
      } else {
        targetReveal = totalToReveal;
      }

      // Thêm các vị trí mới (giữ nguyên các vị trí đã hiện)
      final positions = List.generate(wordLength, (i) => i);
      positions.shuffle(random);

      for (var pos in positions) {
        if (_revealedPositions.length >= targetReveal) break;
        _revealedPositions.add(pos);
      }
    });
  }

  String _getHintText() {
    if (_hintsUsed == 0) return _currentWord.hint;

    final word = _currentWord.word;
    return word
        .split('')
        .asMap()
        .entries
        .map((e) => _revealedPositions.contains(e.key) ? e.value : '_')
        .join(' ');
  }

  Future<void> _saveWordToDictionary(String word) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recent_searches') ?? [];

    recentSearches.remove(word);
    recentSearches.insert(0, word);
    if (recentSearches.length > 20) {
      recentSearches = recentSearches.sublist(0, 20);
    }

    await prefs.setStringList('recent_searches', recentSearches);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu "$word" vào từ điển'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _translateDefinition(String text) async {
    try {
      final translatedText = await TranslationService.instance.translateLocal(
        text,
        to: 'vi',
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.translate, color: Color(0xFF26C6DA)),
                SizedBox(width: 8),
                Text('Bản dịch'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tiếng Anh:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(fontSize: 14),
                ),
                if (translatedText != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Tiếng Việt:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    translatedText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF26C6DA),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể dịch. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleComplete() {
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Hiển thị loading khi đang tải dữ liệu
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5BA3E8), Color(0xFF4A8DD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Đang tải từ vựng...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (screenWidth * 0.043).clamp(16.0, 20.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Kiểm tra nếu không có từ nào
    if (_availableWords.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5BA3E8), Color(0xFF4A8DD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: (screenWidth * 0.2).clamp(70.0, 100.0),
                    color: Colors.white,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text(
                    'Bạn chưa tra từ nào trong từ điển.\nHãy tra từ trước khi chơi game!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (screenWidth * 0.043).clamp(16.0, 20.0),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ElevatedButton.icon(
                    onPressed: widget.onBack,
                    icon: Icon(Icons.arrow_back,
                        size: (screenWidth * 0.048).clamp(18.0, 24.0)),
                    label: Text('Quay lại',
                        style: TextStyle(
                            fontSize: (screenWidth * 0.04).clamp(15.0, 19.0))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF5BA3E8),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Responsive sizes for header
    final headerPadding = screenWidth * 0.05;
    final iconSize = (screenWidth * 0.065).clamp(24.0, 32.0);
    final titleFontSize = (screenWidth * 0.048).clamp(18.0, 24.0);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: 50,
              left: headerPadding,
              right: headerPadding,
              bottom: headerPadding,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFF5BA3E8), Color(0xFF4A8DD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  Text(
                    'Đoán từ',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: iconSize),
                ],
              ),
            ),
          ),

          // Game content
          Expanded(
            child: !_showResult
                ? _buildGuessingInput(isDark, screenWidth, screenHeight)
                : _buildGuessingResult(isDark, screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  Widget _buildGuessingInput(
      bool isDark, double screenWidth, double screenHeight) {
    // Responsive sizes
    final contentPadding = screenWidth * 0.05;
    final cardPadding = screenWidth * 0.06;
    final hintFontSize = (screenWidth * 0.065).clamp(24.0, 32.0);
    final definitionFontSize = (screenWidth * 0.038).clamp(15.0, 19.0);
    final inputFontSize = (screenWidth * 0.043).clamp(16.0, 20.0);
    final smallFontSize = (screenWidth * 0.03).clamp(11.0, 14.0);
    final iconSize = (screenWidth * 0.048).clamp(18.0, 24.0);

    return SingleChildScrollView(
      padding: EdgeInsets.all(contentPadding),
      child: Column(
        children: [
          // Hint text
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)]
                    : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF5BA3E8).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _getHintText(),
                  style: TextStyle(
                    fontSize: hintFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: isDark ? Colors.white : const Color(0xFF1565C0),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  _currentWord.definition,
                  style: TextStyle(
                    fontSize: definitionFontSize,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Hints used display
          if (_hintsUsed > 0) ...[
            SizedBox(height: screenHeight * 0.015),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFE3F2FD)
                        .withValues(alpha: isDark ? 0.2 : 1.0),
                    const Color(0xFFBBDEFB)
                        .withValues(alpha: isDark ? 0.2 : 1.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF5BA3E8).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: iconSize,
                    color: const Color(0xFF5BA3E8)
                        .withValues(alpha: isDark ? 0.8 : 1.0),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      _hintsUsed == 1
                          ? 'Đã dùng 1 gợi ý: Hiện 30-40% chữ'
                          : _hintsUsed == 2
                              ? 'Đã dùng 2 gợi ý: Hiện 60-70% chữ'
                              : 'Đã dùng 3 gợi ý: Hiện 90% chữ',
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color:
                            isDark ? Colors.white70 : const Color(0xFF1565C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: screenHeight * 0.03),

          // Input
          TextField(
            controller: _guessController,
            onChanged: (value) => setState(() => _userGuess = value),
            onSubmitted:
                _userGuess.isNotEmpty ? (_) => _handleGuessSubmit() : null,
            style: TextStyle(
              fontSize: inputFontSize,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập đáp án của bạn...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(screenWidth * 0.04),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _hintsUsed >= 3 ? null : _useHint,
                  icon: const Icon(Icons.lightbulb_outline, size: 20),
                  label: Text('Gợi ý (${3 - _hintsUsed})'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: _hintsUsed >= 3
                          ? (isDark ? Colors.white12 : Colors.grey.shade200)
                          : const Color(0xFF5BA3E8),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _userGuess.isEmpty ? null : _handleGuessSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF5BA3E8),
                    disabledBackgroundColor:
                        isDark ? Colors.white12 : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Kiểm tra',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
      bool isDark, double screenWidth, double screenHeight) {
    // Responsive sizes
    final contentPadding = screenWidth * 0.08;
    final cardPadding = screenWidth * 0.08;
    final emojiSize = (screenWidth * 0.15).clamp(50.0, 70.0);
    final titleFontSize = (screenWidth * 0.075).clamp(28.0, 36.0);
    final answerFontSize = (screenWidth * 0.048).clamp(18.0, 24.0);
    final definitionFontSize = (screenWidth * 0.038).clamp(15.0, 19.0);
    final iconSize = (screenWidth * 0.048).clamp(18.0, 24.0);

    return SingleChildScrollView(
      padding: EdgeInsets.all(contentPadding),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isCorrect
                ? [
                    const Color(0xFF4CAF50)
                        .withValues(alpha: isDark ? 0.3 : 0.2),
                    const Color(0xFF45A049)
                        .withValues(alpha: isDark ? 0.3 : 0.2),
                  ]
                : [
                    const Color(0xFFE91E63)
                        .withValues(alpha: isDark ? 0.3 : 0.2),
                    const Color(0xFFD81B60)
                        .withValues(alpha: isDark ? 0.3 : 0.2),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isCorrect
                ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
                : const Color(0xFFE91E63).withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              _isCorrect ? '🎉' : '😅',
              style: TextStyle(fontSize: emojiSize),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              _isCorrect ? 'Chính xác!' : 'Chưa đúng!',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            if (!_isCorrect) ...[
              SizedBox(height: screenHeight * 0.015),
              Text(
                'Đáp án đúng: ${_currentWord.word}',
                style: TextStyle(
                  fontSize: answerFontSize,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
            SizedBox(height: screenHeight * 0.02),
            Text(
              _currentWord.definition,
              style: TextStyle(
                fontSize: definitionFontSize,
                color: isDark ? Colors.white60 : Colors.black45,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),

            // Nút Dịch và Lưu từ
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _translateDefinition(_currentWord.definition),
                    icon: Icon(Icons.translate, size: iconSize),
                    label: Text('Dịch',
                        style: TextStyle(fontSize: definitionFontSize)),
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      side: const BorderSide(
                        color: Color(0xFF26C6DA),
                        width: 2,
                      ),
                      foregroundColor: const Color(0xFF26C6DA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _saveWordToDictionary(_currentWord.word),
                    icon: Icon(Icons.bookmark_add, size: iconSize),
                    label: Text('Lưu từ',
                        style: TextStyle(fontSize: definitionFontSize)),
                    style: OutlinedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      side: BorderSide(
                        color: _isCorrect
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE91E63),
                        width: 2,
                      ),
                      foregroundColor: _isCorrect
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _handleComplete,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFF5BA3E8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Hoàn thành',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
