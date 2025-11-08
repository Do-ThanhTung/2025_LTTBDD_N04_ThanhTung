import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_plus/translator_plus.dart';

class Story {
  final String title;
  final String content;
  final String category;
  final List<String> keywords;

  Story({
    required this.title,
    required this.content,
    required this.category,
    this.keywords = const [],
  });

  factory Story.fromJson(Map<String, dynamic> json) => Story(
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        category: json['category'] ?? 'General',
        keywords: List<String>.from(json['keywords'] as List? ?? []),
      );
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<Story> stories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/stories.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      debugPrint('✅ Loaded ${jsonList.length} stories');
      debugPrint('First story keywords: ${(jsonList[0] as Map)['keywords']}');
      setState(() {
        stories = jsonList
            .map((e) => Story.fromJson(e as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading stories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: 'hero_story',
      child: Scaffold(
        body: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.only(
                top: 50,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.02,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFF4DD0E1),
                    Color(0xFF26C6DA),
                    Color(0xFF00BCD4),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: screenWidth * 0.065,
                      ),
                    ),
                    Text(
                      '📚 Truyện ngắn',
                      style: TextStyle(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.065),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: const Color(0xFF00BCD4),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Đang tải truyện...',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ],
                      ),
                    )
                  : stories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                size: screenWidth * 0.2,
                                color: isDark ? Colors.white38 : Colors.black26,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                'Chưa có truyện nào',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Truyện sẽ được cập nhật sớm',
                                style: TextStyle(
                                  color:
                                      isDark ? Colors.white38 : Colors.black38,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.02,
                            ),
                            child: Column(
                              children: stories.map((story) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.015),
                                  child: _buildStoryListItem(context, story,
                                      screenWidth, screenHeight, isDark),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryListItem(BuildContext context, Story story,
      double screenWidth, double screenHeight, bool isDark) {
    final containerHeight = screenHeight * 0.11;
    final titleFontSize = screenWidth * 0.036;
    final descriptionFontSize = screenWidth * 0.026;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryDetailScreen(story: story),
          ),
        );
      },
      child: Container(
        height: containerHeight,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.008,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? Colors.grey[800]?.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      story.title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.003),
                  Text(
                    story.category,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.04,
              color: isDark ? Colors.white38 : Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  double _fontSize = 16.0;
  final bool _isReadingMode = false;
  bool _isStoryRead = false;
  String _translatedContent = '';
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _checkIfStoryRead();
  }

  Future<void> _checkIfStoryRead() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString('login_provider') ?? 'default';
    final readStories = prefs.getStringList('${provider}_read_stories') ?? [];
    setState(() {
      _isStoryRead = readStories.contains(widget.story.title);
    });
  }

  Future<void> _toggleStoryRead() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = prefs.getString('login_provider') ?? 'default';
    final readStories = prefs.getStringList('${provider}_read_stories') ?? [];

    setState(() {
      _isStoryRead = !_isStoryRead;
    });

    if (_isStoryRead) {
      if (!readStories.contains(widget.story.title)) {
        readStories.add(widget.story.title);
        await prefs.setStringList('${provider}_read_stories', readStories);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã lưu truyện'),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFF00BCD4),
          ),
        );
      }
    } else {
      readStories.remove(widget.story.title);
      await prefs.setStringList('${provider}_read_stories', readStories);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Đã bỏ lưu truyện'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.grey,
          ),
        );
      }
    }
  }

  Future<void> _translateStory() async {
    if (_translatedContent.isNotEmpty) {
      // Show existing translation
      _showTranslateBottomSheet(context, 0, 0, false);
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final translator = GoogleTranslator();
      final translation = await translator.translate(
        widget.story.content,
        from: 'en',
        to: 'vi',
      );
      setState(() {
        _translatedContent = translation.toString();
        _isTranslating = false;
      });
      if (mounted) {
        _showTranslateBottomSheet(
            context,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
            Theme.of(context).brightness == Brightness.dark);
      }
    } catch (e) {
      setState(() {
        _isTranslating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi dịch: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _splitIntoSentences(String content) {
    // Tách nội dung thành các câu dựa trên dấu chấm, chấm hỏi, chấm than
    final sentences = content.split(RegExp(r'(?<=[.!?])\s+'));
    return sentences.where((sentence) => sentence.trim().isNotEmpty).toList();
  }

  void _showTranslateBottomSheet(BuildContext context, double screenWidth,
      double screenHeight, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🌐 Bản dịch tiếng Việt',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Divider(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              SizedBox(height: screenWidth * 0.03),

              // Content
              Expanded(
                child: _isTranslating
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: const Color(0xFF00BCD4),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              'Đang dịch...',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _translatedContent.isEmpty
                        ? Center(
                            child: Text(
                              'Nhấn nút dịch để bắt đầu',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _translatedContent,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  height: 1.8,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
              ),

              SizedBox(height: screenWidth * 0.04),

              // Button
              ElevatedButton(
                onPressed: _isTranslating ? null : _translateStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  disabledBackgroundColor: Colors.grey[400],
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.04,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _isTranslating
                      ? '⏳ Đang dịch...'
                      : _translatedContent.isEmpty
                          ? '🔄 Dịch sang Tiếng Việt'
                          : '🔄 Dịch lại',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: 50,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.02,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xFF4DD0E1),
                  Color(0xFF26C6DA),
                  Color(0xFF00BCD4),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: screenWidth * 0.065,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.story.title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isTranslating ? null : _translateStory,
                    icon: Icon(
                      Icons.translate,
                      color: Colors.white,
                      size: screenWidth * 0.055,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleStoryRead,
                    icon: Icon(
                      _isStoryRead ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                      size: screenWidth * 0.055,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: _isReadingMode
                ? _buildReadingMode(screenWidth, screenHeight, isDark)
                : _buildNormalMode(screenWidth, screenHeight, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalMode(
      double screenWidth, double screenHeight, bool isDark) {
    // Responsive adjustments
    final contentPadding = screenWidth * 0.04;
    final contentCardPadding = screenWidth * 0.05;
    final keywordPadding = screenWidth * 0.03;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Story content as paragraph
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(contentCardPadding),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.story.content,
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.8,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            SizedBox(height: contentPadding * 2),

            // Keywords section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(contentCardPadding),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📖 Key Words',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00BCD4),
                    ),
                  ),
                  SizedBox(height: contentPadding * 1.5),
                  widget.story.keywords.isEmpty
                      ? Text(
                          'No keywords available',
                          style: TextStyle(
                            fontSize: screenWidth * 0.034,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        )
                      : Wrap(
                          spacing: keywordPadding * 1.5,
                          runSpacing: keywordPadding * 1.5,
                          children: widget.story.keywords.map((keyword) {
                            return GestureDetector(
                              onTap: () async {
                                // Save to favorites
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final isLoggedIn =
                                    prefs.getBool('is_logged_in') ?? false;

                                if (!isLoggedIn) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Vui lòng đăng nhập để lưu từ'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Get provider for key prefix
                                final provider =
                                    prefs.getString('login_provider') ??
                                        'default';
                                final savedWordsKey = '${provider}_saved_words';
                                List<String> savedWords =
                                    prefs.getStringList(savedWordsKey) ?? [];

                                if (!savedWords.contains(keyword)) {
                                  savedWords.insert(0, keyword);
                                  if (savedWords.length > 100) {
                                    savedWords = savedWords.sublist(0, 100);
                                  }
                                  await prefs.setStringList(
                                      savedWordsKey, savedWords);
                                }

                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã lưu: $keyword'),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: const Color(0xFF00BCD4),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: keywordPadding * 1.3,
                                  vertical: keywordPadding * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DD0E1)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFF00BCD4)
                                        .withValues(alpha: 0.6),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  keyword,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.034,
                                    color: const Color(0xFF00BCD4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),

            SizedBox(height: contentPadding * 3),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingMode(
      double screenWidth, double screenHeight, bool isDark) {
    // Responsive adjustments
    final horizontalPadding = screenWidth * (screenWidth > 600 ? 0.12 : 0.08);
    final titleFontSize = screenWidth * (screenWidth > 600 ? 0.07 : 0.06);
    final topSpacing = screenHeight * (screenWidth > 600 ? 0.08 : 0.05);
    final titleBottomSpacing = screenHeight * (screenWidth > 600 ? 0.06 : 0.04);
    final bottomSpacing = screenHeight * (screenWidth > 600 ? 0.15 : 0.1);
    final controlBottomPosition =
        screenHeight * (screenWidth > 600 ? 0.08 : 0.05);
    final controlRightPosition =
        screenWidth * (screenWidth > 600 ? 0.08 : 0.05);
    final controlPadding = screenWidth * (screenWidth > 600 ? 0.03 : 0.02);
    final controlIconSize = screenWidth * (screenWidth > 600 ? 0.06 : 0.05);

    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),
                    Text(
                      widget.story.title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: titleBottomSpacing),
                    Column(
                      children: _splitIntoSentences(widget.story.content)
                          .asMap()
                          .entries
                          .map((entry) {
                        final index = entry.key;
                        final sentence = entry.value.trim();
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth *
                                    (screenWidth > 600 ? 0.08 : 0.07),
                                height: screenWidth *
                                    (screenWidth > 600 ? 0.08 : 0.07),
                                margin: EdgeInsets.only(
                                    right: screenWidth * 0.03,
                                    top: screenHeight * 0.005),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DD0E1)
                                      .withValues(alpha: 0.3),
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.04),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: screenWidth *
                                          (screenWidth > 600 ? 0.035 : 0.032),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00BCD4),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  sentence,
                                  style: TextStyle(
                                    fontSize:
                                        _fontSize + (screenWidth > 600 ? 4 : 2),
                                    height: 1.8,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: bottomSpacing),
                  ],
                ),
              ),
            ),

            // Font size controls
            Positioned(
              bottom: controlBottomPosition,
              right: controlRightPosition,
              child: Container(
                padding: EdgeInsets.all(controlPadding),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_fontSize > 12) _fontSize -= 2;
                        });
                      },
                      icon: Icon(
                        Icons.text_decrease,
                        color: isDark ? Colors.white : Colors.black,
                        size: controlIconSize,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_fontSize < 24) _fontSize += 2;
                        });
                      },
                      icon: Icon(
                        Icons.text_increase,
                        color: isDark ? Colors.white : Colors.black,
                        size: controlIconSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
