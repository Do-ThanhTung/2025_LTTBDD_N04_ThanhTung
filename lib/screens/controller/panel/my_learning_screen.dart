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
  int wordsLearned = 142;
  int dailyGoal = 10;
  int todayProgress = 7;
  int currentStreak = 5;
  int totalStories = 8;
  int gamesPlayed = 23;
  int coursesInProgress = 2;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF111827),
                    Color(0xFF1F2937)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFF0E6FF),
                    Color(0xFFE6D5FF),
                    Color(0xFFFFE6F0)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFF8B5CF6),
                        Color(0xFFEC4899)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Quá trình học tập',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9333EA),
                        Color(0xFFEC4899)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Khóa học: $coursesInProgress',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF06B6D4),
                        Color(0xFF14B8A6)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text('Mục tiêu hôm nay',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 12),
                      Text(
                          '$todayProgress / $dailyGoal từ',
                          style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white)),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value:
                            todayProgress / dailyGoal,
                        backgroundColor:
                            Colors.white30,
                        valueColor:
                            const AlwaysStoppedAnimation(
                                Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF97316),
                        Color(0xFFEF4444),
                        Color(0xFFEC4899)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text('Chuỗi học',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white)),
                      Text('$currentStreak ngày ',
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                                  colors: [
                                Color(0xFF9333EA),
                                Color(0xFF7C3AED)
                              ]),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.book,
                                color: Colors.white,
                                size: 32),
                            const SizedBox(height: 12),
                            Text('$wordsLearned',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Colors.white)),
                            const Text('Từ đã học',
                                style: TextStyle(
                                    color: Colors
                                        .white70)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                                  colors: [
                                Color(0xFFFB923C),
                                Color(0xFFF97316)
                              ]),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 32),
                            const SizedBox(height: 12),
                            Text('$gamesPlayed',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color:
                                        Colors.white)),
                            const Text('Trò chơi',
                                style: TextStyle(
                                    color: Colors
                                        .white70)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          Color(0xFF10B981),
                          Color(0xFF14B8A6)
                        ]),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text('Truyện đã đọc',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white)),
                      Text('$totalStories ',
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
