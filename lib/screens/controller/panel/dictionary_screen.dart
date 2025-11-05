import '../../../models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/api.dart';
import '../../../l10n/app_localizations.dart';
import 'package:translator_plus/translator_plus.dart';
import '../../../services/translation_service.dart';
import '../../../services/search_history_service.dart';
import '../../../services/vocabulary_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() =>
      _DictionaryScreenState();
}

class _DictionaryScreenState
    extends State<DictionaryScreen> {
  bool inProgress = false;
  ResponseModel? responseModel;
  String noDataText = "";
  final GoogleTranslator translator =
      GoogleTranslator();
  final TextEditingController _searchController =
      TextEditingController();
  late final FocusNode _searchFocusNode = FocusNode();
  final FlutterTts _flutterTts = FlutterTts();
  final Set<String> _savedWords = {};

  @override
  void initState() {
    super.initState();
    // Load search history
    SearchHistoryService.instance.loadHistory();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String word) async {
    await _flutterTts.speak(word);
  }

  void _toggleSaveWord(String word) {
    setState(() {
      if (_savedWords.contains(word)) {
        _savedWords.remove(word);
      } else {
        _savedWords.add(word);
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Hero(
      tag: 'hero_dictionary',
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF1a1a2e)
              : const Color(0xFFF3E5F5),
          body: Column(
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
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFB39DDB),
                      Color(0xFF9575CD),
                      Color(0xFF7E57C2),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    // Top bar with back button
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context)
                                  .maybePop(),
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
                        Text(
                          AppLocalizations.t(context,
                              'practice_dictionary'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.search,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search box
                    _buildSearchWidget(),
                  ],
                ),
              ),

              // Content area
              const SizedBox(height: 12),
              if (inProgress)
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20),
                  child: LinearProgressIndicator(),
                )
              else if (responseModel != null)
                Expanded(child: _buildResponseWidget())
              else
                Expanded(child: _buildEmptyState()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white
            .withAlpha((0.95 * 255).round()),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withAlpha((0.1 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search for a word...',
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade600,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(4),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_searchController
                          .text.isNotEmpty) {
                        _getMeaningFromApi(
                            _searchController.text);
                        _searchFocusNode.unfocus();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context)
                              .colorScheme
                              .primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 20),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18),
        ),
        onChanged: (value) {
          setState(
              () {}); // To show/hide search button
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _getMeaningFromApi(value);
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    // Lấy lịch sử tìm kiếm
    final searchHistory =
        SearchHistoryService.instance.getHistory();

    return SingleChildScrollView(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Icon và tiêu đề
          Center(
            child: Card(
              elevation: 0,
              color: isDark
                  ? Colors.grey.shade800
                      .withAlpha((0.6 * 255).round())
                  : Colors.white
                      .withAlpha((0.8 * 255).round()),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFB39DDB),
                            Color(0xFF9575CD),
                            Color(0xFF7E57C2),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.t(
                          context, 'search_word'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover meanings, examples, and more',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Lịch sử tìm kiếm
          if (searchHistory.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.history,
                  size: 20,
                  color: Color(0xFF9575CD),
                ),
                const SizedBox(width: 8),
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      SearchHistoryService.instance
                          .clearHistory();
                    });
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: searchHistory.map((word) {
                return InkWell(
                  onTap: () {
                    _searchController.text = word;
                    _getMeaningFromApi(word);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE1BEE7),
                          Color(0xFFCE93D8),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                                  0xFF9575CD)
                              .withAlpha(
                                  (0.2 * 255).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF7E57C2),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          word,
                          style: const TextStyle(
                            color: Color(0xFF6A1B9A),
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            // Nếu chưa có lịch sử, hiển thị gợi ý
            Text(
              'Suggested Words',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? Colors.white
                    : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'hello',
                'happy',
                'learn',
                'beautiful',
                'friend',
                'love',
              ].map((word) {
                return InkWell(
                  onTap: () {
                    _searchController.text = word;
                    _getMeaningFromApi(word);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE1BEE7),
                          Color(0xFFCE93D8),
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      word,
                      style: const TextStyle(
                        color: Color(0xFF6A1B9A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _getMeaningFromApi(String word) async {
    // Add to search history
    await SearchHistoryService.instance
        .addSearch(word);

    setState(() {
      inProgress = true;
    });
    try {
      responseModel = await API.fetchMeaning(word);
      if (!mounted) return;

      // Cập nhật số từ đã tra (chỉ khi tra thành công và chưa tra từ này bao giờ)
      if (responseModel != null) {
        final prefs =
            await SharedPreferences.getInstance();
        // Lấy danh sách các từ đã tra
        List<String> searchedWords =
            prefs.getStringList('searched_words') ??
                [];
        String normalizedWord =
            word.toLowerCase().trim();

        // Chỉ tăng count nếu từ chưa được tra bao giờ
        if (!searchedWords.contains(normalizedWord)) {
          searchedWords.add(normalizedWord);
          await prefs.setStringList(
              'searched_words', searchedWords);
          await prefs.setInt(
              'search_count', searchedWords.length);
        }

        // Lưu từ vựng kèm nghĩa và ví dụ cho game
        if (responseModel!.meanings != null &&
            responseModel!.meanings!.isNotEmpty) {
          final meaning =
              responseModel!.meanings!.first;
          if (meaning.definitions != null &&
              meaning.definitions!.isNotEmpty) {
            final definition = meaning
                    .definitions!.first.definition ??
                '';
            final example =
                meaning.definitions!.first.example ??
                    'No example available';

            await VocabularyService.instance
                .saveVocabularyItem(
              normalizedWord,
              definition,
              example,
            );
          }
        }
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      responseModel = null;
      if (!mounted) return;
      final msg = AppLocalizations.t(
        context,
        'meaning_cannot_be_fetched',
      );
      noDataText = msg;
      setState(() {});
    } finally {
      if (mounted) {
        setState(() {
          inProgress = false;
        });
      }
    }
  }

  Widget _buildResponseWidget() {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 0,
        color: isDark
            ? Colors.grey.shade800
                .withAlpha((0.6 * 255).round())
            : Colors.white
                .withAlpha((0.9 * 255).round()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Word header with actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              responseModel!.word!
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:
                                    FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors
                                        .grey.shade900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                                Icons.auto_awesome,
                                color: Colors.amber,
                                size: 24),
                          ],
                        ),
                        if (responseModel!.phonetic
                                ?.isNotEmpty ??
                            false)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                                    top: 4),
                            child: Text(
                              responseModel!.phonetic!,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context)
                                        .colorScheme
                                        .primary,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        if (responseModel!.meanings
                                ?.isNotEmpty ??
                            false)
                          Container(
                            padding: const EdgeInsets
                                .symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary,
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha((0.7 *
                                              255)
                                          .round()),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                            child: Text(
                              responseModel!
                                      .meanings![0]
                                      .partOfSpeech ??
                                  '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Action buttons
                  Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF5BA3E8),
                              Color(0xFF4A8DD4)
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                      0xFF5BA3E8)
                                  .withAlpha(
                                      (0.3 * 255)
                                          .round()),
                              blurRadius: 8,
                              offset:
                                  const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => _speak(
                              responseModel!.word!),
                          icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 22),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: _savedWords
                                  .contains(
                                      responseModel!
                                          .word!)
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFFF7B9C),
                                    Color(0xFFFF6B8F)
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors
                                        .grey.shade400,
                                    Colors
                                        .grey.shade500
                                  ],
                                ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withAlpha(
                                      (0.2 * 255)
                                          .round()),
                              blurRadius: 8,
                              offset:
                                  const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () =>
                              _toggleSaveWord(
                                  responseModel!
                                      .word!),
                          icon: Icon(
                            _savedWords.contains(
                                    responseModel!
                                        .word!)
                                ? Icons.bookmark
                                : Icons
                                    .bookmark_border,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Meanings list
              ...responseModel!.meanings!
                  .asMap()
                  .entries
                  .map((entry) {
                final meaning = entry.value;
                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildMeaningSection(
                        meaning, isDark),
                    if (entry.key <
                        responseModel!
                                .meanings!.length -
                            1)
                      const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeaningSection(
      Meanings meaning, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Definition Card with border
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white
                    .withAlpha((0.05 * 255).round())
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white
                      .withAlpha((0.1 * 255).round())
                  : Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withAlpha((0.05 * 255).round()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary,
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(
                                  (0.7 * 255).round()),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Definition',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  // Translate button for definition
                  IconButton(
                    onPressed: () => _translateSection(
                      context,
                      meaning.definitions
                              ?.map((d) =>
                                  d.definition ?? '')
                              .join('\n') ??
                          '',
                      'Definition',
                    ),
                    icon: Icon(
                      Icons.translate,
                      size: 20,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                    tooltip: 'Translate to Vietnamese',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...?meaning.definitions
                  ?.map((def) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8),
                        child: Text(
                          '• ${def.definition}',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: isDark
                                ? Colors.grey.shade300
                                : Colors.grey.shade700,
                          ),
                        ),
                      )),
            ],
          ),
        ),

        // Example Card with border (if available)
        if (meaning.definitions?.isNotEmpty ?? false)
          if (meaning.definitions!.first.example
                  ?.isNotEmpty ??
              false) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF5D4E37)
                              .withAlpha(
                                  (0.3 * 255).round()),
                          const Color(0xFF6B5840)
                              .withAlpha(
                                  (0.3 * 255).round()),
                        ]
                      : [
                          const Color(0xFFFFF3E0),
                          const Color(0xFFFFE8CC),
                        ],
                ),
                borderRadius:
                    BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFB74D)
                      .withAlpha((0.4 * 255).round()),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration:
                            const BoxDecoration(
                          color: Color(0xFFFFB74D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Example',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                      ),
                      const Spacer(),
                      // Translate button for example
                      IconButton(
                        onPressed: () =>
                            _translateSection(
                          context,
                          meaning.definitions!.first
                                  .example ??
                              '',
                          'Example',
                        ),
                        icon: const Icon(
                          Icons.translate,
                          size: 20,
                          color: Color(0xFFFFB74D),
                        ),
                        tooltip:
                            'Translate to Vietnamese',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${meaning.definitions!.first.example}"',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      color: isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],

        // Synonyms Card with border (if available)
        if (meaning.synonyms?.isNotEmpty ?? false) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white
                      .withAlpha((0.05 * 255).round())
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white
                        .withAlpha((0.1 * 255).round())
                    : Colors.grey.shade200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withAlpha((0.05 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF5EC9B4),
                            Color(0xFF4BB9A5)
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Synonyms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: meaning.synonyms!
                      .take(6)
                      .map((synonym) {
                    return InkWell(
                      onTap: () {
                        // Search for the synonym when tapped
                        _searchController.text =
                            synonym;
                        _getMeaningFromApi(synonym);
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF5EC9B4),
                              Color(0xFF4BB9A5)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                      0xFF5EC9B4)
                                  .withAlpha(
                                      (0.3 * 255)
                                          .round()),
                              blurRadius: 4,
                              offset:
                                  const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Text(
                              synonym,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Function to translate a section
  Future<void> _translateSection(BuildContext context,
      String text, String title) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (text.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Nothing to translate')),
      );
      return;
    }

    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.translate,
                color: Color(0xFF5BA3E8)),
            const SizedBox(width: 8),
            Text('$title Translation'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Translating...'),
          ],
        ),
      ),
    );

    try {
      // Try local translation first
      final tgt =
          TranslationService.instance.targetLang;
      String? translated = await TranslationService
          .instance
          .translateLocal(text, to: tgt);

      // If local fails, use Google Translate
      if (translated == null || translated == text) {
        final translation = await translator
            .translate(text, from: 'en', to: 'vi');
        translated = translation.text;
      }

      if (!mounted) return;
      navigator.pop(); // Close loading dialog

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark
              ? Colors.grey.shade900
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5BA3E8),
                      Color(0xFF4A8DD4)
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.translate,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.grey.shade800,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'English',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Icon(Icons.arrow_downward,
                    color: Color(0xFF5BA3E8)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF5BA3E8),
                        Color(0xFF4A8DD4)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tiếng Việt',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        translated ?? text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      navigator.pop(); // Close loading dialog
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(
            content: Text('Translation failed: $e')),
      );
    }
  }
}
