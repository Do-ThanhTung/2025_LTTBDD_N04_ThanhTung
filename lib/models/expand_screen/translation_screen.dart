import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() =>
      _TranslationScreenState();
}

class _TranslationScreenState
    extends State<TranslationScreen> {
  final TextEditingController _controller =
      TextEditingController();
  final translator = GoogleTranslator();
  final FlutterTts _flutterTts = FlutterTts();
  String _result = '';
  String _sourceLang = 'en';
  String _targetLang = 'vi';

  // Quick phrases
  final Map<String, String> _quickPhrases = {
    'hello': 'xin chào',
    'how are you': 'bạn khỏe không',
    'thank you': 'cảm ơn',
    'good morning': 'chào buổi sáng',
    'good night': 'chúc ngủ ngon',
    'i love you': 'tôi yêu bạn',
  };

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text, String lang) async {
    await _flutterTts
        .setLanguage(lang == 'en' ? 'en-US' : 'vi-VN');
    await _flutterTts.speak(text);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _translate() async {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter text to translate')),
      );
      return;
    }

    try {
      final res = await translator.translate(
        input,
        from: _sourceLang,
        to: _targetLang,
      );
      setState(() {
        _result = res.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Translation failed: $e')),
      );
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
      _controller.text = _result;
      _result = _controller.text;
    });
  }

  void _useQuickPhrase(String en, String vi) {
    setState(() {
      if (_sourceLang == 'en') {
        _controller.text = en;
        _result = vi;
      } else {
        _controller.text = vi;
        _result = en;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark;

    return Hero(
      tag: 'hero_translation',
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF1a1a2e)
            : const Color(0xFFF0F9FF),
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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0EA5E9),
                    Color(0xFF06B6D4),
                    Color(0xFF14B8A6)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Top bar
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context)
                                .maybePop(),
                        child: Container(
                          padding:
                              const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                                .withAlpha((0.2 * 255)
                                    .round()),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Text(
                        'Translation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Language selector card
                    Container(
                      padding:
                          const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                                .withAlpha((0.6 * 255)
                                    .round())
                            : Colors.white.withAlpha(
                                (0.8 * 255).round()),
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withAlpha((0.1 * 255)
                                    .round()),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Source language
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 20,
                                  vertical: 12),
                              decoration:
                                  BoxDecoration(
                                gradient: _sourceLang ==
                                        'en'
                                    ? const LinearGradient(
                                        colors: [
                                          Color(
                                              0xFF0EA5E9),
                                          Color(
                                              0xFF06B6D4)
                                        ],
                                      )
                                    : null,
                                color:
                                    _sourceLang == 'vi'
                                        ? Colors.grey
                                            .shade200
                                        : null,
                                borderRadius:
                                    BorderRadius
                                        .circular(16),
                              ),
                              child: Text(
                                _sourceLang == 'en'
                                    ? '🇬🇧 English'
                                    : '🇻🇳 Tiếng Việt',
                                textAlign:
                                    TextAlign.center,
                                style: TextStyle(
                                  color: _sourceLang ==
                                          'en'
                                      ? Colors.white
                                      : Colors.grey
                                          .shade600,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Swap button
                          Padding(
                            padding: const EdgeInsets
                                .symmetric(
                                horizontal: 12),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFFA855F7),
                                    Color(0xFFEC4899)
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                            0xFFA855F7)
                                        .withAlpha((0.3 *
                                                255)
                                            .round()),
                                    blurRadius: 12,
                                    offset:
                                        const Offset(
                                            0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed:
                                    _swapLanguages,
                                icon: const Icon(
                                  Icons.swap_horiz,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),

                          // Target language
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets
                                  .symmetric(
                                  horizontal: 20,
                                  vertical: 12),
                              decoration:
                                  BoxDecoration(
                                gradient: _targetLang ==
                                        'vi'
                                    ? const LinearGradient(
                                        colors: [
                                          Color(
                                              0xFF0EA5E9),
                                          Color(
                                              0xFF06B6D4)
                                        ],
                                      )
                                    : null,
                                color:
                                    _targetLang == 'en'
                                        ? Colors.grey
                                            .shade200
                                        : null,
                                borderRadius:
                                    BorderRadius
                                        .circular(16),
                              ),
                              child: Text(
                                _targetLang == 'vi'
                                    ? '🇻🇳 Tiếng Việt'
                                    : '🇬🇧 English',
                                textAlign:
                                    TextAlign.center,
                                style: TextStyle(
                                  color: _targetLang ==
                                          'vi'
                                      ? Colors.white
                                      : Colors.grey
                                          .shade600,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Source text card
                    Container(
                      padding:
                          const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  Colors.grey.shade800
                                      .withAlpha((0.5 *
                                              255)
                                          .round()),
                                  Colors.grey.shade800
                                      .withAlpha((0.3 *
                                              255)
                                          .round()),
                                ]
                              : [
                                  Colors.white,
                                  const Color(
                                          0xFFF0F9FF)
                                      .withAlpha((0.3 *
                                              255)
                                          .round()),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withAlpha((0.1 * 255)
                                    .round()),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
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
                                decoration:
                                    const BoxDecoration(
                                  color: Color(
                                      0xFF0EA5E9),
                                  shape:
                                      BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _sourceLang == 'en'
                                    ? 'English'
                                    : 'Tiếng Việt',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey
                                          .shade300
                                      : Colors.grey
                                          .shade700,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _controller
                                        .text.isEmpty
                                    ? null
                                    : () => _speak(
                                        _controller
                                            .text,
                                        _sourceLang),
                                icon: Icon(
                                  Icons.volume_up,
                                  size: 20,
                                  color: _controller
                                          .text.isEmpty
                                      ? Colors.grey
                                          .shade400
                                      : const Color(
                                          0xFF0EA5E9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _controller,
                            maxLines: 4,
                            decoration:
                                InputDecoration(
                              hintText: _sourceLang ==
                                      'en'
                                  ? 'Enter text in English...'
                                  : 'Nhập văn bản tiếng Việt...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors
                                    .grey.shade400,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: isDark
                                  ? Colors.white
                                  : Colors
                                      .grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Translate button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF0EA5E9),
                              Color(0xFF06B6D4),
                              Color(0xFF14B8A6)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                      0xFF0EA5E9)
                                  .withAlpha(
                                      (0.3 * 255)
                                          .round()),
                              blurRadius: 20,
                              offset:
                                  const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _translate,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.transparent,
                            shadowColor:
                                Colors.transparent,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(Icons.auto_awesome,
                                  size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Translate Now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Translated text card (if available)
                    if (_result.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding:
                            const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFF14B8A6),
                              Color(0xFF06B6D4),
                              Color(0xFF0EA5E9)
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                      0xFF14B8A6)
                                  .withAlpha(
                                      (0.3 * 255)
                                          .round()),
                              blurRadius: 20,
                              offset:
                                  const Offset(0, 4),
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
                                  decoration:
                                      const BoxDecoration(
                                    color:
                                        Colors.white,
                                    shape: BoxShape
                                        .circle,
                                  ),
                                ),
                                const SizedBox(
                                    width: 8),
                                Text(
                                  _targetLang == 'vi'
                                      ? 'Tiếng Việt'
                                      : 'English',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () =>
                                      _speak(_result,
                                          _targetLang),
                                  icon: const Icon(
                                    Icons.volume_up,
                                    size: 20,
                                    color:
                                        Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _copyToClipboard(
                                          _result),
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _result,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Quick Phrases
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF0EA5E9),
                                    Color(0xFF06B6D4)
                                  ],
                                  begin: Alignment
                                      .topCenter,
                                  end: Alignment
                                      .bottomCenter,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Quick Phrases',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors
                                        .grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount:
                              _quickPhrases.length,
                          itemBuilder:
                              (context, index) {
                            final entry = _quickPhrases
                                .entries
                                .elementAt(index);
                            return InkWell(
                              onTap: () =>
                                  _useQuickPhrase(
                                      entry.key,
                                      entry.value),
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(12),
                                decoration:
                                    BoxDecoration(
                                  color: isDark
                                      ? Colors.white
                                          .withAlpha((0.05 *
                                                  255)
                                              .round())
                                      : Colors.white
                                          .withAlpha((0.8 *
                                                  255)
                                              .round()),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white
                                            .withAlpha((0.1 *
                                                    255)
                                                .round())
                                        : Colors.grey
                                            .shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors
                                                .white
                                            : Colors
                                                .grey
                                                .shade800,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 4),
                                    Text(
                                      entry.value,
                                      style:
                                          const TextStyle(
                                        fontSize: 11,
                                        color: Color(
                                            0xFF0EA5E9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
