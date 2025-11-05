import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import '../../../services/translation_service.dart';
import '../../../services/vocabulary_service.dart';

class FlashCard {
  final String word;
  final String meaning;
  final String example;

  FlashCard({
    required this.word,
    required this.meaning,
    required this.example,
  });
}

// Sample flashcard data
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
    example: 'Despite his success, he remained humble.',
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

class FlashcardGame extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int) onUpdateTrophies;

  const FlashcardGame({
    super.key,
    required this.onBack,
    required this.onUpdateTrophies,
  });

  @override
  State<FlashcardGame> createState() => _FlashcardGameState();
}

class _FlashcardGameState extends State<FlashcardGame> {
  int _currentCardIndex = 0;
  bool _showAnswer = false;
  int _knownCards = 0;
  List<FlashCard> _shuffledFlashCards = [];
  List<FlashCard> _skippedCards = [];
  late ConfettiController _confettiController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _startGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _startGame() async {
    setState(() {
      _isLoading = true;
    });

    final random = Random();

    // 1. Lấy từ đã tra từ VocabularyService
    final vocabItems = await VocabularyService.instance.getVocabularyForGame();

    final cards = <FlashCard>[];

    // 2. Chuyển đổi VocabularyItem thành FlashCard
    for (var item in vocabItems) {
      cards.add(FlashCard(
        word: item.word,
        meaning: item.definition,
        example: item.example,
      ));
    }

    // 3. Nếu không đủ từ, bổ sung từ dữ liệu mẫu
    if (cards.length < 20) {
      final sampleCards = List<FlashCard>.from(flashCards)..shuffle(random);
      final needed = 20 - cards.length;
      cards.addAll(sampleCards.take(needed));
    }

    // 4. Shuffle và lấy 20 từ
    cards.shuffle(random);
    final finalCards = cards.take(20).toList();

    setState(() {
      _shuffledFlashCards = finalCards;
      _currentCardIndex = 0;
      _showAnswer = false;
      _knownCards = 0;
      _skippedCards = [];
      _isLoading = false;
    });
  }

  void _handleNextCard() {
    if (_currentCardIndex < _shuffledFlashCards.length - 1) {
      setState(() {
        _currentCardIndex++;
        _showAnswer = false;
      });
    } else {
      _showCompleteDialog();
    }
  }

  void _handleSkipCard() {
    final currentCard = _shuffledFlashCards[_currentCardIndex];
    if (!_skippedCards.contains(currentCard)) {
      _skippedCards.add(currentCard);
    }
    _handleNextCard();
  }

  void _handleKnowCard() {
    setState(() {
      _knownCards++;
    });
    _handleNextCard();
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

  void _showSelectWordsDialog(List<FlashCard> cards) {
    final selectedWords = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.bookmark_add, color: Colors.purple),
              SizedBox(width: 8),
              Text('Chọn từ cần lưu'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                final isSelected = selectedWords.contains(card.word);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        selectedWords.add(card.word);
                      } else {
                        selectedWords.remove(card.word);
                      }
                    });
                  },
                  title: Text(
                    card.word,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    card.meaning,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  activeColor: Colors.purple,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: selectedWords.isEmpty
                  ? null
                  : () async {
                      for (var word in selectedWords) {
                        await _saveWordToDictionary(word);
                      }
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text('Lưu (${selectedWords.length})'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog() {
    _confettiController.play();

    String message;
    String title;

    if (_knownCards == 20) {
      title = '🎉 Tuyệt vời!';
      message = 'Bạn đã biết tất cả 20/20 từ!\nBạn có muốn tiếp tục không?';
    } else if (_knownCards == 0) {
      title = '💪 Cố gắng lên!';
      message =
          'Bạn phải cố gắng nhiều hơn.\nBạn có muốn tôi lưu lại các từ vừa rồi không?';
    } else {
      title = '👏 Chúc mừng!';
      message =
          'Bạn đã biết $_knownCards/20 từ.\nBạn có muốn lưu lại ${_skippedCards.length} từ bạn bỏ qua không?';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('✅ Đã biết', style: TextStyle(fontSize: 12)),
                      Text(
                        '$_knownCards',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('⏭️ Bỏ qua', style: TextStyle(fontSize: 12)),
                      Text(
                        '${_skippedCards.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_skippedCards.isNotEmpty || _knownCards == 0)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (_knownCards == 0) {
                  _showSelectWordsDialog(_shuffledFlashCards);
                } else {
                  _showSelectWordsDialog(_skippedCards);
                }
              },
              child: Text(_knownCards == 20 ? 'Không' : 'Lưu từ'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onBack();
            },
            child: Text(_knownCards == 20 ? 'Về menu' : 'Bỏ qua'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Hiển thị loading khi đang tải dữ liệu
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9D8EF5), Color(0xFF7B6BE8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Đang tải từ vựng...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
    if (_shuffledFlashCards.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9D8EF5), Color(0xFF7B6BE8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bạn chưa tra từ nào trong từ điển.\nHãy tra từ trước khi chơi game!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Quay lại'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF7B6BE8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
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

    final currentCard = _shuffledFlashCards[_currentCardIndex];
    final progress = (_currentCardIndex + 1) / _shuffledFlashCards.length;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xFF9D8EF5), Color(0xFF7B6BE8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: widget.onBack,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Text(
                            'Thẻ ghi nhớ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_knownCards/${_shuffledFlashCards.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Thẻ ${_currentCardIndex + 1} trong số ${_shuffledFlashCards.length}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Flashcard with rotation
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Tính toán kích thước 1 lần cho cả 2 mặt thẻ
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;

                          // Thẻ co dãn theo cả chiều ngang và cao
                          // Chiều cao: 45-50% màn hình
                          final cardHeight =
                              (screenHeight * 0.45).clamp(250.0, 500.0);

                          // Chiều rộng: 85-90% màn hình (tùy kích thước)
                          final cardWidth =
                              (screenWidth * 0.88).clamp(280.0, 600.0);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _showAnswer = !_showAnswer;
                              });
                            },
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: _showAnswer ? 180 : 0,
                              ),
                              duration: const Duration(milliseconds: 400),
                              builder: (context, value, child) {
                                final angle = value * (3.14159 / 180);
                                final showBack = value > 90;

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(angle),
                                  alignment: Alignment.center,
                                  child: showBack
                                      ? Transform(
                                          transform: Matrix4.identity()
                                            ..rotateY(3.14159),
                                          alignment: Alignment.center,
                                          child: _buildCardBack(
                                            currentCard,
                                            isDark,
                                            cardHeight,
                                            cardWidth,
                                            screenWidth,
                                            screenHeight,
                                          ),
                                        )
                                      : _buildCardFront(
                                          currentCard,
                                          isDark,
                                          cardHeight,
                                          cardWidth,
                                          screenWidth,
                                          screenHeight,
                                        ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _handleSkipCard,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white30
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                'Bỏ qua',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _saveWordToDictionary(currentCard.word),
                              icon: const Icon(Icons.bookmark_add, size: 20),
                              label: const Text('Lưu'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(
                                  color: Color(0xFF9D8EF5),
                                  width: 2,
                                ),
                                foregroundColor: const Color(0xFF9D8EF5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _showAnswer ? _handleKnowCard : null,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: const Color(0xFF4CAF50),
                                disabledBackgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tôi biết từ này',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14159 / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [
                Colors.purple,
                Colors.pink,
                Colors.orange,
                Colors.blue,
                Colors.green,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(
    FlashCard card,
    bool isDark,
    double cardHeight,
    double cardWidth,
    double screenWidth,
    double screenHeight,
  ) {
    // Kích thước icon và font responsive
    final iconSize = (screenWidth * 0.15).clamp(48.0, 72.0);
    final wordFontSize = (screenWidth * 0.08).clamp(28.0, 42.0);
    final hintFontSize = (screenWidth * 0.035).clamp(14.0, 18.0);

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.symmetric(
        horizontal: cardWidth * 0.08,
        vertical: cardHeight * 0.06,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)]
              : [Colors.white, const Color(0xFFF8F5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D8EF5).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D8EF5), Color(0xFF7B6BE8)],
              ),
              borderRadius: BorderRadius.circular(iconSize / 2),
            ),
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: iconSize * 0.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Flexible(
            child: Text(
              card.word,
              style: TextStyle(
                fontSize: wordFontSize,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'Nhấn để xem nghĩa',
            style: TextStyle(
              fontSize: hintFontSize,
              color: const Color(0xFF9D8EF5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(
    FlashCard card,
    bool isDark,
    double cardHeight,
    double cardWidth,
    double screenWidth,
    double screenHeight,
  ) {
    // Kích thước font responsive
    final emojiSize = (screenWidth * 0.12).clamp(40.0, 56.0);
    final meaningFontSize = (screenWidth * 0.065).clamp(22.0, 32.0);
    final exampleFontSize = (screenWidth * 0.032).clamp(13.0, 16.0);

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.symmetric(
        horizontal: cardWidth * 0.08,
        vertical: cardHeight * 0.06,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2D2D2D), const Color(0xFF1A1A1A)]
              : [Colors.white, const Color(0xFFF8F5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D8EF5).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '✨',
            style: TextStyle(fontSize: emojiSize),
          ),
          SizedBox(height: screenHeight * 0.015),
          Flexible(
            child: Text(
              card.meaning,
              style: TextStyle(
                fontSize: meaningFontSize,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.035),
              constraints: BoxConstraints(
                maxHeight: cardHeight * 0.35,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFF3E0)
                        .withValues(alpha: isDark ? 0.2 : 1.0),
                    const Color(0xFFFFE0B2)
                        .withValues(alpha: isDark ? 0.2 : 1.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(
                  '"${card.example}"',
                  style: TextStyle(
                    fontSize: exampleFontSize,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.9)
                        : const Color(0xFF5D4037),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
