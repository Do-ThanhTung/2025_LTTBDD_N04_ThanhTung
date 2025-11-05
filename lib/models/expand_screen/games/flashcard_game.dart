import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:translator_plus/translator_plus.dart';
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

// Sample flashcard data - with English definitions
final List<FlashCard> flashCards = [
  FlashCard(
    word: 'Abundant',
    meaning:
        'Existing or available in large quantities; plentiful',
    example: 'The garden has abundant flowers.',
  ),
  FlashCard(
    word: 'Achieve',
    meaning:
        'To successfully reach a desired objective or result',
    example: 'She worked hard to achieve her goals.',
  ),
  FlashCard(
    word: 'Brilliant',
    meaning:
        'Exceptionally clever or talented; very bright',
    example: 'He is a brilliant student.',
  ),
  FlashCard(
    word: 'Curious',
    meaning:
        'Eager to know or learn something; inquisitive',
    example: 'Children are naturally curious.',
  ),
  FlashCard(
    word: 'Delightful',
    meaning:
        'Causing delight; charming and very pleasant',
    example: 'We had a delightful evening.',
  ),
  FlashCard(
    word: 'Elegant',
    meaning:
        'Graceful and stylish in appearance or manner',
    example: 'She wore an elegant dress.',
  ),
  FlashCard(
    word: 'Fantastic',
    meaning:
        'Extraordinarily good or attractive; excellent',
    example: 'That was a fantastic performance!',
  ),
  FlashCard(
    word: 'Grateful',
    meaning:
        'Feeling or showing appreciation for kindness',
    example: 'I am grateful for your help.',
  ),
  FlashCard(
    word: 'Humble',
    meaning:
        'Having or showing a modest estimate of one\'s importance',
    example:
        'Despite his success, he remained humble.',
  ),
  FlashCard(
    word: 'Impressive',
    meaning:
        'Evoking admiration through size, quality, or skill',
    example: 'Your work is very impressive.',
  ),
  FlashCard(
    word: 'Joyful',
    meaning:
        'Feeling, expressing, or causing great pleasure and happiness',
    example: 'It was a joyful celebration.',
  ),
  FlashCard(
    word: 'Knowledge',
    meaning:
        'Facts, information, and skills acquired through experience or education',
    example: 'Knowledge is power.',
  ),
  FlashCard(
    word: 'Lovely',
    meaning:
        'Exquisitely beautiful; very pleasant or enjoyable',
    example: 'What a lovely surprise!',
  ),
  FlashCard(
    word: 'Magnificent',
    meaning:
        'Extremely beautiful, elaborate, or impressive',
    example: 'The view from the top was magnificent.',
  ),
  FlashCard(
    word: 'Noble',
    meaning:
        'Having or showing fine personal qualities or high moral principles',
    example: 'That was a noble gesture.',
  ),
  FlashCard(
    word: 'Optimistic',
    meaning: 'Hopeful and confident about the future',
    example: 'She has an optimistic outlook on life.',
  ),
  FlashCard(
    word: 'Peaceful',
    meaning:
        'Free from disturbance; tranquil and calm',
    example: 'The countryside is very peaceful.',
  ),
  FlashCard(
    word: 'Remarkable',
    meaning:
        'Worthy of attention; striking and extraordinary',
    example: 'Her achievements are truly remarkable.',
  ),
  FlashCard(
    word: 'Sincere',
    meaning:
        'Free from pretense or deceit; genuine and honest',
    example: 'Please accept my sincere apologies.',
  ),
  FlashCard(
    word: 'Talented',
    meaning:
        'Having a natural aptitude or skill for something',
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
  State<FlashcardGame> createState() =>
      _FlashcardGameState();
}

class _FlashcardGameState
    extends State<FlashcardGame> {
  int _currentCardIndex = 0;
  bool _showAnswer = false;
  int _knownCards = 0;
  List<FlashCard> _shuffledFlashCards = [];
  List<FlashCard> _skippedCards = [];
  late ConfettiController _confettiController;
  bool _isLoading = true;
  final Map<String, String> _translationCache = {};
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    // make confetti longer so it is visible with the new dialog
    _confettiController = ConfettiController(
        duration: const Duration(seconds: 4));
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
    final vocabItems = await VocabularyService.instance
        .getVocabularyForGame();

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
      final sampleCards =
          List<FlashCard>.from(flashCards)
            ..shuffle(random);
      final needed = 20 - cards.length;
      cards.addAll(sampleCards.take(needed));
    }

    // 4. Shuffle và lấy 20 từ
    cards.shuffle(random);
    final finalCards = cards.take(20).toList();

    if (!mounted) return;

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
    if (_currentCardIndex <
        _shuffledFlashCards.length - 1) {
      setState(() {
        _currentCardIndex++;
        _showAnswer = false;
      });
    } else {
      _showCompleteDialog();
    }
  }

  void _handleSkipCard() {
    final currentCard =
        _shuffledFlashCards[_currentCardIndex];
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

  Future<void> _saveWordToDictionary(
      String word) async {
    final prefs =
        await SharedPreferences.getInstance();
    List<String> recentSearches =
        prefs.getStringList('recent_searches') ?? [];

    recentSearches.remove(word);
    recentSearches.insert(0, word);
    if (recentSearches.length > 20) {
      recentSearches = recentSearches.sublist(0, 20);
    }

    await prefs.setStringList(
        'recent_searches', recentSearches);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã lưu "$word" vào từ điển'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _translateTextInline(
      String text) async {
    if (text.trim().isEmpty) return;
    if (_translationCache.containsKey(text))
      return; // already translated

    setState(() => _isTranslating = true);

    try {
      // Use Google Translator API
      final translator = GoogleTranslator();
      final translation = await translator
          .translate(text, from: 'en', to: 'vi');

      if (!mounted) return;

      if (translation.text.isNotEmpty) {
        setState(() => _translationCache[text] =
            translation.text);
      } else {
        // Hiển thị thông báo nếu không dịch được
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Không thể dịch văn bản này'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Translation error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Lỗi khi dịch: ${e.toString()}'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted)
        setState(() => _isTranslating = false);
    }
  }

  void _showSelectWordsDialog(List<FlashCard> cards) {
    final selectedWords = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) =>
            AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.bookmark_add,
                  color: Colors.purple),
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
                final isSelected =
                    selectedWords.contains(card.word);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        selectedWords.add(card.word);
                      } else {
                        selectedWords
                            .remove(card.word);
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
                      final navigator =
                          Navigator.of(context);
                      for (var word in selectedWords) {
                        await _saveWordToDictionary(
                            word);
                      }
                      if (!mounted) return;
                      navigator.pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                disabledBackgroundColor:
                    Colors.grey[300],
              ),
              child: Text(
                  'Lưu (${selectedWords.length})'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompleteDialog() {
    // Play confetti then show a custom, more prominent dialog.
    _confettiController.play();

    final titleText = _knownCards == 20
        ? 'Tuyệt vời!'
        : (_knownCards == 0
            ? 'Cố gắng lên!'
            : 'Chúc mừng!');

    final subtitle = _knownCards == 20
        ? 'Bạn đã biết tất cả ${_shuffledFlashCards.length}/${_shuffledFlashCards.length} từ!'
        : (_knownCards == 0
            ? 'Bạn phải cố gắng nhiều hơn.'
            : 'Bạn đã biết $_knownCards/${_shuffledFlashCards.length} từ.');

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Kết quả',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration:
          const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        final screenWidth =
            MediaQuery.of(context).size.width;
        final screenHeight =
            MediaQuery.of(context).size.height;

        return ScaleTransition(
          scale: CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: screenWidth * 0.88,
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.7,
                    maxWidth: 500,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.03,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF8B7EE8),
                        const Color(0xFF9D8EF5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B6BE8)
                            .withOpacity(0.4),
                        blurRadius: 32,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          titleText,
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.065,
                            fontWeight:
                                FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.012),

                        // Subtitle
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(0.85),
                            fontSize:
                                screenWidth * 0.038,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.03),

                        // Stats container
                        Container(
                          padding:
                              EdgeInsets.symmetric(
                            vertical:
                                screenHeight * 0.022,
                            horizontal:
                                screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(
                                    20),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceEvenly,
                            children: [
                              // Known cards
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '✅ Đã biết',
                                      style: TextStyle(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                                0.9),
                                        fontSize:
                                            screenWidth *
                                                0.035,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            screenHeight *
                                                0.01),
                                    Container(
                                      padding: EdgeInsets
                                          .symmetric(
                                        horizontal:
                                            screenWidth *
                                                0.05,
                                        vertical:
                                            screenHeight *
                                                0.01,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: const Color(
                                            0xFF4CAF50),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                                    0xFF4CAF50)
                                                .withOpacity(
                                                    0.4),
                                            blurRadius:
                                                12,
                                            offset:
                                                const Offset(
                                                    0,
                                                    4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '$_knownCards',
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize:
                                              screenWidth *
                                                  0.065,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Divider
                              Container(
                                width: 1.5,
                                height: screenHeight *
                                    0.07,
                                color: Colors.white
                                    .withOpacity(0.3),
                              ),

                              // Skipped cards
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '⏭️ Bỏ qua',
                                      style: TextStyle(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                                0.9),
                                        fontSize:
                                            screenWidth *
                                                0.035,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            screenHeight *
                                                0.01),
                                    Container(
                                      padding: EdgeInsets
                                          .symmetric(
                                        horizontal:
                                            screenWidth *
                                                0.05,
                                        vertical:
                                            screenHeight *
                                                0.01,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        color: const Color(
                                            0xFFFF9800),
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                                    0xFFFF9800)
                                                .withOpacity(
                                                    0.4),
                                            blurRadius:
                                                12,
                                            offset:
                                                const Offset(
                                                    0,
                                                    4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '${_skippedCards.length}',
                                        style:
                                            TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize:
                                              screenWidth *
                                                  0.065,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.03),

                        // Action buttons
                        Row(
                          children: [
                            // Save words button
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop();
                                  if (_knownCards ==
                                      0) {
                                    _showSelectWordsDialog(
                                        _shuffledFlashCards);
                                  } else {
                                    _showSelectWordsDialog(
                                        _skippedCards);
                                  }
                                },
                                style: OutlinedButton
                                    .styleFrom(
                                  foregroundColor:
                                      Colors.white,
                                  side: BorderSide(
                                    color: Colors.white
                                        .withOpacity(
                                            0.6),
                                    width: 2,
                                  ),
                                  padding: EdgeInsets
                                      .symmetric(
                                    vertical:
                                        screenHeight *
                                            0.018,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16),
                                  ),
                                ),
                                child: Text(
                                  'Lưu từ',
                                  style: TextStyle(
                                    fontSize:
                                        screenWidth *
                                            0.04,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: screenWidth *
                                    0.03),

                            // Replay button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop();
                                  _startGame();
                                },
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                      Colors.white,
                                  foregroundColor:
                                      const Color(
                                          0xFF8B7EE8),
                                  padding: EdgeInsets
                                      .symmetric(
                                    vertical:
                                        screenHeight *
                                            0.018,
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors
                                      .black
                                      .withOpacity(
                                          0.3),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                16),
                                  ),
                                ),
                                child: Text(
                                  'Chơi lại',
                                  style: TextStyle(
                                    fontSize:
                                        screenWidth *
                                            0.04,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height:
                                screenHeight * 0.015),

                        // Back to menu button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop();
                            widget.onBack();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors
                                .white
                                .withOpacity(0.85),
                            padding:
                                EdgeInsets.symmetric(
                              vertical:
                                  screenHeight * 0.012,
                            ),
                          ),
                          child: Text(
                            'Bỏ qua',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.038,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    // Hiển thị loading khi đang tải dữ liệu
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9D8EF5),
                Color(0xFF7B6BE8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: Colors.white),
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
              colors: [
                Color(0xFF9D8EF5),
                Color(0xFF7B6BE8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
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
                      foregroundColor:
                          const Color(0xFF7B6BE8),
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
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

    final currentCard =
        _shuffledFlashCards[_currentCardIndex];
    final progress = (_currentCardIndex + 1) /
        _shuffledFlashCards.length;

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
                            MainAxisAlignment
                                .spaceBetween,
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
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(
                                      alpha: 0.2),
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(
                                    width: 4),
                                Text(
                                  '$_knownCards/${_shuffledFlashCards.length}',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontWeight:
                                        FontWeight
                                            .bold,
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
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      LayoutBuilder(
                        builder:
                            (context, constraints) {
                          // Tính toán kích thước 1 lần cho cả 2 mặt thẻ
                          final screenWidth =
                              MediaQuery.of(context)
                                  .size
                                  .width;
                          final screenHeight =
                              MediaQuery.of(context)
                                  .size
                                  .height;

                          // Thẻ co dãn theo cả chiều ngang và cao
                          // Chiều cao: 45-50% màn hình
                          final cardHeight =
                              (screenHeight * 0.45)
                                  .clamp(250.0, 500.0);

                          // Chiều rộng: 85-90% màn hình (tùy kích thước)
                          final cardWidth =
                              (screenWidth * 0.88)
                                  .clamp(280.0, 600.0);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _showAnswer =
                                    !_showAnswer;
                              });
                            },
                            child:
                                TweenAnimationBuilder<
                                    double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: _showAnswer
                                    ? 180
                                    : 0,
                              ),
                              duration: const Duration(
                                  milliseconds: 400),
                              builder: (context, value,
                                  child) {
                                final angle = value *
                                    (3.14159 / 180);
                                final showBack =
                                    value > 90;

                                return Transform(
                                  transform: Matrix4
                                      .identity()
                                    ..setEntry(
                                        3, 2, 0.001)
                                    ..rotateY(angle),
                                  alignment:
                                      Alignment.center,
                                  child: showBack
                                      ? Transform(
                                          transform: Matrix4
                                              .identity()
                                            ..rotateY(
                                                3.14159),
                                          alignment:
                                              Alignment
                                                  .center,
                                          child:
                                              _buildCardBack(
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
                              onPressed:
                                  _handleSkipCard,
                              style: OutlinedButton
                                  .styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                        vertical: 16),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white30
                                      : Colors.grey
                                          .shade300,
                                  width: 2,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                ),
                              ),
                              child: Text(
                                'Bỏ qua',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _saveWordToDictionary(
                                      currentCard
                                          .word),
                              icon: const Icon(
                                  Icons.bookmark_add,
                                  size: 20),
                              label: const Text('Lưu'),
                              style: OutlinedButton
                                  .styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                        vertical: 16),
                                side: const BorderSide(
                                  color: Color(
                                      0xFF9D8EF5),
                                  width: 2,
                                ),
                                foregroundColor:
                                    const Color(
                                        0xFF9D8EF5),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _showAnswer
                                  ? _handleKnowCard
                                  : null,
                              style: ElevatedButton
                                  .styleFrom(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                        vertical: 16),
                                backgroundColor:
                                    const Color(
                                        0xFF4CAF50),
                                disabledBackgroundColor:
                                    Colors
                                        .grey.shade300,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                ),
                                elevation: 0,
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Icon(
                                      Icons
                                          .check_circle,
                                      size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Tôi biết từ này',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .bold,
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

          // Confetti overlay - spread several sources across the top so
          // particles always originate from above the screen and fall down.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 0,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ConfettiWidget(
                        confettiController:
                            _confettiController,
                        blastDirection: pi / 2 +
                            0.25, // slightly to the right
                        emissionFrequency: 0.18,
                        numberOfParticles: 12,
                        maxBlastForce: 20,
                        minBlastForce: 8,
                        gravity: 0.35,
                        blastDirectionality:
                            BlastDirectionality
                                .explosive,
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
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController:
                            _confettiController,
                        blastDirection:
                            pi / 2, // straight down
                        emissionFrequency: 0.20,
                        numberOfParticles: 14,
                        maxBlastForce: 24,
                        minBlastForce: 10,
                        gravity: 0.32,
                        blastDirectionality:
                            BlastDirectionality
                                .explosive,
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
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ConfettiWidget(
                        confettiController:
                            _confettiController,
                        blastDirection: pi / 2 -
                            0.25, // slightly to the left
                        emissionFrequency: 0.18,
                        numberOfParticles: 12,
                        maxBlastForce: 20,
                        minBlastForce: 8,
                        gravity: 0.35,
                        blastDirectionality:
                            BlastDirectionality
                                .explosive,
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
                  ),
                ],
              ),
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
    // Kích thước font responsive
    final wordFontSize =
        (screenWidth * 0.08).clamp(28.0, 42.0);

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
              ? [
                  const Color(0xFF2D2D2D),
                  const Color(0xFF1A1A1A)
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F5FF)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D8EF5)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Text(
          card.word,
          style: TextStyle(
            fontSize: wordFontSize,
            fontWeight: FontWeight.bold,
            color:
                isDark ? Colors.white : Colors.black87,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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
    final meaningFontSize =
        (screenWidth * 0.065).clamp(22.0, 32.0);
    final exampleFontSize =
        (screenWidth * 0.032).clamp(13.0, 16.0);
    final buttonSize =
        (screenWidth * 0.028).clamp(12.0, 16.0);

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
              ? [
                  const Color(0xFF2D2D2D),
                  const Color(0xFF1A1A1A)
                ]
              : [
                  Colors.white,
                  const Color(0xFFF8F5FF)
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9D8EF5)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Translate button in top left corner (icon only)
          Positioned(
            top: 0,
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isTranslating
                    ? null
                    : () => _translateTextInline(
                        card.meaning),
                borderRadius:
                    BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(
                      screenWidth * 0.025),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF26C6DA)
                            .withOpacity(0.2),
                        const Color(0xFF26C6DA)
                            .withOpacity(0.1),
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF26C6DA)
                          .withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF26C6DA)
                            .withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _isTranslating
                      ? SizedBox(
                          width: buttonSize * 1.2,
                          height: buttonSize * 1.2,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              const Color(0xFF26C6DA),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.translate_rounded,
                          size: buttonSize * 1.2,
                          color:
                              const Color(0xFF26C6DA),
                        ),
                ),
              ),
            ),
          ),
          // Main content centered - English definition or Vietnamese translation
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              // Definition box (English or Vietnamese based on translation state)
              Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: cardWidth * 0.08,
                      vertical: cardHeight * 0.04,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Show Vietnamese translation if available, otherwise English
                        Text(
                          _translationCache
                                  .containsKey(
                                      card.meaning)
                              ? _translationCache[
                                  card.meaning]!
                              : card.meaning,
                          style: TextStyle(
                            fontSize: meaningFontSize,
                            fontWeight:
                                FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : Colors.black87,
                            height: 1.6,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Language indicator when translated
                        if (_translationCache
                            .containsKey(
                                card.meaning)) ...[
                          SizedBox(
                              height: screenHeight *
                                  0.015),
                          Container(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth * 0.03,
                              vertical:
                                  screenHeight * 0.006,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(
                                          0xFF26C6DA)
                                      .withOpacity(
                                          0.2),
                                  const Color(
                                          0xFF26C6DA)
                                      .withOpacity(
                                          0.15),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                              border: Border.all(
                                color: const Color(
                                        0xFF26C6DA)
                                    .withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons
                                      .check_circle_rounded,
                                  size:
                                      exampleFontSize *
                                          0.9,
                                  color: const Color(
                                      0xFF26C6DA),
                                ),
                                SizedBox(
                                    width:
                                        screenWidth *
                                            0.01),
                                Text(
                                  'Đã dịch sang Tiếng Việt',
                                  style: TextStyle(
                                    fontSize:
                                        exampleFontSize *
                                            0.85,
                                    color: const Color(
                                        0xFF26C6DA),
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              // Example section
              if (card.example.isNotEmpty)
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                        horizontal: cardWidth * 0.08),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                      vertical: screenHeight * 0.018,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFF3E0)
                              .withValues(
                                  alpha: isDark
                                      ? 0.3
                                      : 1.0),
                          const Color(0xFFFFE0B2)
                              .withValues(
                                  alpha: isDark
                                      ? 0.25
                                      : 1.0),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFB74D)
                            .withValues(
                                alpha: isDark
                                    ? 0.35
                                    : 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        '"${card.example}"',
                        style: TextStyle(
                          fontSize:
                              exampleFontSize * 1.05,
                          fontStyle: FontStyle.italic,
                          color: isDark
                              ? Colors.white
                                  .withValues(
                                      alpha: 0.9)
                              : const Color(
                                  0xFF5D4037),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
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
}
