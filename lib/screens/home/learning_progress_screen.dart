import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() =>
      _MyLearningScreenState();
}

class _MyLearningScreenState
    extends State<MyLearningScreen> {
  late SharedPreferences prefs;
  List<String> savedWords = [];
  List<String> readStories = [];
  int todayWords = 0;
  int currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeSampleData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _initializeSampleData() async {
    prefs = await SharedPreferences.getInstance();
    // Check if already initialized
    if ((prefs.getStringList('saved_words') ?? [])
        .isEmpty) {
      final sampleWords = [
        'Awesome',
        'Incredible',
        'Beautiful',
        'Wonderful',
        'Amazing'
      ];
      await prefs.setStringList(
          'saved_words', sampleWords);
      setState(() {
        savedWords = sampleWords;
      });
    }
  }

  Future<void> _loadData() async {
    prefs = await SharedPreferences.getInstance();
    final isLoggedIn =
        prefs.getBool('is_logged_in') ?? false;

    setState(() {
      if (isLoggedIn) {
        // Load data only if logged in
        savedWords =
            prefs.getStringList('saved_words') ?? [];
        readStories =
            prefs.getStringList('read_stories') ?? [];
        todayWords = prefs.getInt('today_words') ?? 0;
        currentStreak =
            prefs.getInt('current_streak') ?? 0;
      } else {
        // Show 0 if not logged in
        savedWords = [];
        readStories = [];
        todayWords = 0;
        currentStreak = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      body: Container(
        color: isDark ? Colors.black : Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  '📚 Quá trình học tập',
                  style: TextStyle(
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // Daily Words - Full width with Streak Badge
                GestureDetector(
                  onTap: () => _showTodayWordsList(
                      context, screenWidth, isDark),
                  child: _buildTodayWordsCard(
                    context,
                    screenWidth,
                    isDark,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Saved Words (Clickable)
                GestureDetector(
                  onTap: () => _showSavedWordsList(
                      context, screenWidth, isDark),
                  child: _buildBasicCard(
                    context,
                    screenWidth,
                    '⭐ Từ đã lưu',
                    '${savedWords.length} từ',
                    isDark,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Read Stories (Clickable)
                GestureDetector(
                  onTap: () => _showReadStoriesList(
                      context, screenWidth, isDark),
                  child: _buildBasicCard(
                    context,
                    screenWidth,
                    '📕 Truyện đã đọc',
                    '${readStories.length} truyện',
                    isDark,
                  ),
                ),
                SizedBox(height: screenHeight * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicCard(
    BuildContext context,
    double screenWidth,
    String title,
    String value,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white70
                  : Colors.black54,
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.075,
              fontWeight: FontWeight.bold,
              color:
                  isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // New widget with streak icon
  Widget _buildTodayWordsCard(
    BuildContext context,
    double screenWidth,
    bool isDark,
  ) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[900]
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.grey[800]!
                  : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '📖 Từ học hôm nay',
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                '$todayWords/10',
                style: TextStyle(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: screenWidth * 0.03),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: todayWords / 10,
                  minHeight: screenWidth * 0.025,
                  backgroundColor: isDark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    todayWords >= 10
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Streak badge top-right
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.03,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey[800]
                  : Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🔥',
                  style: TextStyle(
                      fontSize: screenWidth * 0.05),
                ),
                SizedBox(height: screenWidth * 0.005),
                Text(
                  '$currentStreak',
                  style: TextStyle(
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Show today's words list
  void _showTodayWordsList(
    BuildContext context,
    double screenWidth,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? Colors.grey[900] : Colors.grey[100],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '📖 Từ học hôm nay ($todayWords)',
                style: TextStyle(
                  fontSize: screenWidth * 0.048,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Expanded(
                child: todayWords == 0
                    ? Center(
                        child: Text(
                          'Chưa có từ nào hôm nay',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.036,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          'Đã học $todayWords từ hôm nay\n${todayWords >= 10 ? "🔥 Chuỗi lửa +1!" : "Cần ${10 - todayWords} từ nữa để đạt chuỗi lửa"}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.04,
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show saved words - tapping word jumps to dictionary
  void _showSavedWordsList(
    BuildContext context,
    double screenWidth,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? Colors.grey[900] : Colors.grey[100],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '⭐ Từ đã lưu (${savedWords.length})',
                style: TextStyle(
                  fontSize: screenWidth * 0.048,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Expanded(
                child: savedWords.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa có từ nào được lưu',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.036,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: savedWords.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: screenWidth *
                                    0.03),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors
                                        .grey[300]!,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                savedWords[index],
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                          0.04,
                                  fontWeight:
                                      FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Jump to dictionary
                                      _jumpToDictionary(
                                          savedWords[
                                              index]);
                                      Navigator.pop(
                                          context);
                                    },
                                    icon: const Icon(
                                      Icons.search,
                                      color:
                                          Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        savedWords
                                            .removeAt(
                                                index);
                                        prefs.setStringList(
                                            'saved_words',
                                            savedWords);
                                      });
                                      Navigator.pop(
                                          context);
                                      _showSavedWordsList(
                                          context,
                                          screenWidth,
                                          isDark);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: isDark
                                          ? Colors
                                              .red[300]
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Show read stories history
  void _showReadStoriesList(
    BuildContext context,
    double screenWidth,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDark ? Colors.grey[900] : Colors.grey[100],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '📕 Lịch sử đọc truyện (${readStories.length})',
                style: TextStyle(
                  fontSize: screenWidth * 0.048,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Expanded(
                child: readStories.isEmpty
                    ? Center(
                        child: Text(
                          'Chưa có truyện nào được đọc',
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.036,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: readStories.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: screenWidth *
                                    0.03),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors
                                        .grey[300]!,
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                readStories[index],
                                style: TextStyle(
                                  fontSize:
                                      screenWidth *
                                          0.04,
                                  fontWeight:
                                      FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    readStories
                                        .removeAt(
                                            index);
                                    prefs.setStringList(
                                        'read_stories',
                                        readStories);
                                  });
                                  Navigator.pop(
                                      context);
                                  _showReadStoriesList(
                                      context,
                                      screenWidth,
                                      isDark);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: isDark
                                      ? Colors.red[300]
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Jump to dictionary page
  void _jumpToDictionary(String word) {
    // TODO: Implement navigation to dictionary screen
    // For now, show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tra từ "$word" trong từ điển'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
