import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/vocabulary_service.dart';

class MatchingPair {
  final int id;
  final String word;
  final String meaning;

  MatchingPair({
    required this.id,
    required this.word,
    required this.meaning,
  });
}

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

class MatchingGame extends StatefulWidget {
  final VoidCallback onBack;
  final Function(int, {String? gameType})
      onUpdateTrophies;

  const MatchingGame({
    super.key,
    required this.onBack,
    required this.onUpdateTrophies,
  });

  @override
  State<MatchingGame> createState() =>
      _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  int _score = 0;
  int? _selectedEnglishId;
  List<int> _matchedPairs = [];
  List<MatchingPair> _shuffledEnglishWords = [];
  List<MatchingPair> _shuffledMeanings = [];
  int? _wrongEnglishId;
  int? _wrongVietnameseId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  Future<void> _startGame() async {
    setState(() {
      _isLoading = true;
      _score = 0;
      _selectedEnglishId = null;
      _matchedPairs = [];
      _wrongEnglishId = null;
      _wrongVietnameseId = null;
    });

    final random = Random();

    // 1. Lấy từ đã tra từ VocabularyService
    final vocabItems = await VocabularyService.instance
        .getVocabularyForGame();

    final pairs = <MatchingPair>[];

    // 2. Chuyển đổi VocabularyItem thành MatchingPair
    for (int i = 0; i < vocabItems.length; i++) {
      pairs.add(MatchingPair(
        id: i + 1,
        word: vocabItems[i].word,
        meaning: vocabItems[i].definition,
      ));
    }

    // 3. Nếu không đủ từ, bổ sung từ dữ liệu mẫu
    if (pairs.length < 6) {
      final samplePairs =
          List<MatchingPair>.from(allMatchingWords)
            ..shuffle(random);
      final needed = 6 - pairs.length;
      int nextId = pairs.length + 1;
      for (var sample in samplePairs.take(needed)) {
        pairs.add(MatchingPair(
          id: nextId++,
          word: sample.word,
          meaning: sample.meaning,
        ));
      }
    }

    // 4. Shuffle và lấy 6 cặp
    pairs.shuffle(random);
    final selectedPairs = pairs.take(6).toList();

    setState(() {
      _shuffledEnglishWords =
          List<MatchingPair>.from(selectedPairs)
            ..shuffle(random);
      _shuffledMeanings =
          List<MatchingPair>.from(selectedPairs)
            ..shuffle(random);
      _isLoading = false;
    });
  }

  void _handleWordClick(
      int wordId, bool isEnglishSide) {
    if (_matchedPairs.contains(wordId)) return;

    setState(() {
      if (isEnglishSide) {
        if (_selectedEnglishId == wordId) {
          _selectedEnglishId = null;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;
        } else {
          _selectedEnglishId = wordId;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;
        }
      } else {
        if (_selectedEnglishId == null) {
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

        if (_selectedEnglishId == wordId) {
          _matchedPairs.add(wordId);
          _score++;
          widget.onUpdateTrophies(1,
              gameType: 'matching');
          _selectedEnglishId = null;
          _wrongEnglishId = null;
          _wrongVietnameseId = null;

          if (_matchedPairs.length ==
              _shuffledEnglishWords.length) {
            Future.delayed(
                const Duration(milliseconds: 500), () {
              if (mounted) {
                _showCompleteDialog();
              }
            });
          }
        } else {
          _wrongEnglishId = _selectedEnglishId;
          _wrongVietnameseId = wordId;
          Future.delayed(
              const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _wrongEnglishId = null;
                _wrongVietnameseId = null;
                _selectedEnglishId = null;
              });
            }
          });
        }
      }
    });
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

  void _showSelectWordsDialog() {
    final selectedWords = <String>{};

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) =>
            AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.bookmark_add,
                  color: Color(0xFF5EC9B4)),
              SizedBox(width: 8),
              Text('Chọn từ cần lưu'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _shuffledEnglishWords.length,
              itemBuilder: (context, index) {
                final word =
                    _shuffledEnglishWords[index].word;
                final meaning =
                    _shuffledEnglishWords[index]
                        .meaning;
                final isSelected =
                    selectedWords.contains(word);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setDialogState(() {
                      if (value == true) {
                        selectedWords.add(word);
                      } else {
                        selectedWords.remove(word);
                      }
                    });
                  },
                  title: Text(
                    word,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    meaning,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  activeColor: const Color(0xFF5EC9B4),
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
                backgroundColor:
                    const Color(0xFF5EC9B4),
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Chúc mừng!',
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bạn đã ghép đúng tất cả!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSelectWordsDialog();
            },
            child: const Text('Lưu từ'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onBack();
            },
            child: const Text('Về menu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5EC9B4),
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
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    final screenWidth =
        MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height;

    // Hiển thị loading khi đang tải dữ liệu
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5EC9B4),
                Color(0xFF4BB9A5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: Colors.white),
                SizedBox(height: screenHeight * 0.025),
                Text(
                  'Đang tải từ vựng...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (screenWidth * 0.043)
                        .clamp(16.0, 20.0),
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
    if (_shuffledEnglishWords.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5EC9B4),
                Color(0xFF4BB9A5)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.all(screenWidth * 0.08),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: (screenWidth * 0.2)
                        .clamp(70.0, 100.0),
                    color: Colors.white,
                  ),
                  SizedBox(
                      height: screenHeight * 0.025),
                  Text(
                    'Bạn chưa tra từ nào trong từ điển.\nHãy tra từ trước khi chơi game!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (screenWidth * 0.043)
                          .clamp(16.0, 20.0),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: screenHeight * 0.04),
                  ElevatedButton.icon(
                    onPressed: widget.onBack,
                    icon: Icon(Icons.arrow_back,
                        size: (screenWidth * 0.048)
                            .clamp(18.0, 24.0)),
                    label: Text('Quay lại',
                        style: TextStyle(
                            fontSize: (screenWidth *
                                    0.04)
                                .clamp(15.0, 19.0))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xFF4BB9A5),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.02,
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

    final isComplete = _matchedPairs.length ==
        _shuffledEnglishWords.length;

    // Responsive sizes for header
    final headerPadding = screenWidth * 0.05;
    final iconSize =
        (screenWidth * 0.065).clamp(24.0, 32.0);
    final titleFontSize =
        (screenWidth * 0.048).clamp(18.0, 24.0);
    final scoreFontSize =
        (screenWidth * 0.037).clamp(14.0, 18.0);

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
                    onTap: widget.onBack,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  Text(
                    'Ghép từ',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: iconSize * 0.7,
                        ),
                        SizedBox(
                            width: screenWidth * 0.01),
                        Text(
                          '$_score',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: scoreFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Game content
          if (isComplete)
            _buildMatchingComplete(isDark)
          else
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: _shuffledEnglishWords
                            .map((pair) =>
                                _buildMatchingCard(
                                  pair.word,
                                  pair.id,
                                  true,
                                  isDark,
                                  screenWidth,
                                  screenHeight,
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                        width: screenWidth * 0.05),
                    Expanded(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: _shuffledMeanings
                            .map((pair) =>
                                _buildMatchingCard(
                                  pair.meaning,
                                  pair.id,
                                  false,
                                  isDark,
                                  screenWidth,
                                  screenHeight,
                                ))
                            .toList(),
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

  Widget _buildMatchingCard(
      String text,
      int id,
      bool isEnglish,
      bool isDark,
      double screenWidth,
      double screenHeight) {
    final isMatched = _matchedPairs.contains(id);
    final isSelected =
        _selectedEnglishId == id && isEnglish;
    final isWrong =
        (isEnglish && _wrongEnglishId == id) ||
            (!isEnglish && _wrongVietnameseId == id);

    // Responsive sizes for cards
    final cardPadding = screenHeight * 0.018;
    final fontSize =
        (screenWidth * 0.036).clamp(14.0, 18.0);
    final borderRadius =
        (screenWidth * 0.03).clamp(10.0, 15.0);

    LinearGradient? gradient;
    if (isMatched) {
      gradient = const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
      );
    } else if (isWrong) {
      gradient = const LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFFD81B60)],
      );
    } else if (isSelected) {
      gradient = const LinearGradient(
        colors: [Color(0xFF5EC9B4), Color(0xFF4BB9A5)],
      );
    }

    return Padding(
      padding: EdgeInsets.only(
          bottom: screenHeight * 0.015),
      child: GestureDetector(
        onTap: () => _handleWordClick(id, isEnglish),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: cardPadding,
              horizontal: cardPadding * 0.75),
          decoration: BoxDecoration(
            gradient:
                isMatched || isSelected || isWrong
                    ? gradient
                    : null,
            color:
                !isMatched && !isSelected && !isWrong
                    ? (isDark
                        ? const Color(0xFF2D2D2D)
                        : Colors.white)
                    : null,
            borderRadius:
                BorderRadius.circular(borderRadius),
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
            boxShadow:
                isSelected || isMatched || isWrong
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
              fontSize: fontSize,
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
      ),
    );
  }

  Widget _buildMatchingComplete(bool isDark) {
    final screenWidth =
        MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height;

    // Responsive sizes
    final iconSize =
        (screenWidth * 0.2).clamp(80.0, 120.0);
    final titleFontSize =
        (screenWidth * 0.07).clamp(24.0, 36.0);
    final subtitleFontSize =
        (screenWidth * 0.04).clamp(16.0, 20.0);
    final scoreFontSize =
        (screenWidth * 0.06).clamp(22.0, 32.0);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFC107),
                    Color(0xFFFF9800)
                  ],
                ),
                borderRadius: BorderRadius.circular(
                    iconSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events,
                color: Colors.white,
                size: iconSize * 0.5,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              '🎉 Chúc mừng!',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              'Bạn đã ghép đúng tất cả!',
              style: TextStyle(
                fontSize: subtitleFontSize,
                color: isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02),
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
                style: TextStyle(
                  fontSize: scoreFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            OutlinedButton.icon(
              onPressed: _showSelectWordsDialog,
              icon: Icon(Icons.bookmark_add,
                  size: subtitleFontSize),
              label: const Text('Lưu từ'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.018,
                ),
                side: const BorderSide(
                  color: Color(0xFF5EC9B4),
                  width: 2,
                ),
                foregroundColor:
                    const Color(0xFF5EC9B4),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton.icon(
              onPressed: _startGame,
              icon: const Icon(Icons.refresh),
              label: Text(
                'Chơi lại',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor:
                    const Color(0xFF5EC9B4),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
