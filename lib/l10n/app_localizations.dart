import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>>
      _localizedValues = {
    'en': {
      'settings': 'Settings',
      'vocabulary': 'Vocabulary',
      'welcome_start': 'Welcome , Start searching',
      'practice_dictionary': 'Practice\nDictionary',
      'meaning_cannot_be_fetched':
          'Meaning cannot be fetched',
      'language': 'Language',
      'theme': 'Theme',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'system_default': 'System default',
      'light': 'Light',
      'dark': 'Dark',
      'home': 'Home',
      'my_learning': 'My Learning',
      'dictionary': 'Dictionary',
      'expand': 'Expand',
      'study_chill': 'Study & Chill',
      'learn_more_fun': 'Learn more, have fun',
      'learn_on_go':
          'Learn on the go — read and practice',
      'short_stories': 'Short Stories',
      'short_stories_subtitle': 'Read and learn words',
      // Expand screen
      'story_short': 'Short Stories',
      'game': 'Game',
      'game_subtitle': 'Play learning games',
      'translation': 'Translation',
      'translation_subtitle': 'Translate sentences',
      // Lesson names
      'lesson_why_flutter': 'Why Flutter Development',
      'lesson_setup_macos': 'Setup Flutter on MacOS',
      'lesson_setup_windows':
          'Setup Flutter on Windows',
      'lesson_intro_widgets':
          'Introduction to Flutter widgets.',
      'lesson_stateless_widgets':
          'What are Stateless Widgets?',
      'lesson_stateful_widgets':
          'What are Statefull Widgets?',
      // Duration units
      'duration_min': 'min',
      'duration_sec': 'sec',
      'ok': 'OK',
      'translation_failed': 'Translation failed',
      'expand_header_title':
          'Study & Chill\nLearn more, have fun',
      'expand_header_subtitle':
          'Learn on the go — read and practice',
      'definition': 'Definition',
      'synonyms': 'Synonyms',
      'antonyms': 'Antonyms',
      'nothing_to_translate': 'Nothing to translate',
      'translation_network_hint':
          'Please check your internet connection and try again',
      'not_found_in_local':
          'No local translation found for this text',
      'no_results': 'No results',
      // Settings - colors
      'primary_color': 'Primary Color',
      'choose_a_color': 'Choose a color',
      'primary_color_updated':
          'Primary color updated!',
      // Home screen - new home
      'additional': 'Additional',
      'search_word': 'Search word',
      // Translation screen
      'translate_text': 'Translate Text',
      'practice': 'Practice',
      'auto_detect': 'Auto',
      'enter_text': 'Enter text',
      'translated_text': 'Translated text',
      'translate_button': 'Translate',
      // Game screen
      'word_guess': 'Word Guess',
      'lives_remaining': 'Lives remaining',
      'hint': 'Hint',
      'congratulations': 'Congratulations!',
      'game_over': 'Game Over!',
      'correct_word': 'The correct word is',
      'play_again': 'Play Again',
      'loading_vocabulary': 'Loading vocabulary...',
      'no_vocabulary':
          'No vocabulary available to play',
    },
    'vi': {
      'settings': 'Cài đặt',
      'vocabulary': 'Từ vựng',
      'welcome_start': 'Chào mừng, bắt đầu tìm kiếm',
      'practice_dictionary': 'Từ điển \n thực hành',
      'meaning_cannot_be_fetched':
          'Không thể lấy nghĩa',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'system_default': 'Mặc định hệ thống',
      'light': 'Sáng',
      'dark': 'Tối',
      'home': 'Trang chủ',
      'my_learning': 'Khóa học của tôi',
      'dictionary': 'Từ điển',
      'expand': 'Mở rộng',
      'study_chill': 'Vừa học vừa thư giãn',
      'learn_more_fun': 'Càng học càng vui',
      'learn_on_go':
          'Ứng dụng ngay kiến vừa học vào đọc và phản xạ',
      'short_stories': 'Truyện ngắn',
      'short_stories_subtitle': 'Đọc và học từ',
      // Expand screen
      'story_short': 'Truyện ngắn',
      'game': 'Trò chơi',
      'game_subtitle': 'Chơi trò chơi học tập',
      'translation': 'Dịch văn bản',
      'translation_subtitle': 'Dịch các câu',
      // Lesson names
      'lesson_why_flutter':
          'Tại sao phát triển Flutter',
      'lesson_setup_macos':
          'Cài đặt Flutter trên MacOS',
      'lesson_setup_windows':
          'Cài đặt Flutter trên Windows',
      'lesson_intro_widgets':
          'Giới thiệu về Flutter widgets.',
      'lesson_stateless_widgets':
          'Stateless Widget là gì?',
      'lesson_stateful_widgets':
          'Stateful Widget là gì?',
      // Duration units
      'duration_min': 'phút',
      'duration_sec': 'giây',
      'ok': 'OK',
      'translation_failed': 'Dịch thất bại',
      'expand_header_title':
          'Vừa học vừa thư giãn\nCàng học càng vui',
      'expand_header_subtitle':
          'Ứng dụng ngay kiến vừa học \nvào đọc và phản xạ',
      'definition': 'Định nghĩa',
      'synonyms': 'Từ đồng nghĩa',
      'antonyms': 'Từ trái nghĩa',
      'nothing_to_translate': 'Không có gì để dịch',
      'translation_network_hint':
          'Vui lòng kiểm tra kết nối mạng và thử lại',
      'not_found_in_local':
          'Không tìm thấy bản dịch nội bộ cho văn bản này',
      'no_results': 'Không có kết quả',
      // Settings - colors
      'primary_color': 'Màu chủ đạo',
      'choose_a_color': 'Chọn một màu',
      'primary_color_updated':
          'Đã cập nhật màu chủ đạo!',
      // Home screen - new home
      'additional': 'Bổ sung',
      'search_word': 'Tìm kiếm từ',
      // Translation screen
      'translate_text': 'Dịch văn bản',
      'practice': 'Thực hành',
      'auto_detect': 'Tự động',
      'enter_text': 'Nhập văn bản',
      'translated_text': 'Văn bản dịch',
      'translate_button': 'Dịch',
      // Game screen
      'word_guess': 'Đoán chữ',
      'lives_remaining': 'Lượt còn lại',
      'hint': 'Gợi ý',
      'congratulations': 'Chúc mừng!',
      'game_over': 'Hết lượt!',
      'correct_word': 'Từ đúng là',
      'play_again': 'Chơi lại',
      'loading_vocabulary': 'Đang tải từ vựng...',
      'no_vocabulary': 'Không có từ vựng để chơi',
    },
  };

  static String t(BuildContext context, String key) {
    final code =
        Localizations.localeOf(context).languageCode;
    return _localizedValues[code]?[key] ?? key;
  }
}

/// A simple delegate so `AppLocalizations` can be used with
/// `MaterialApp.localizationsDelegates`.
class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Nothing async to do, but return an instance so the delegate works.
    return AppLocalizations();
  }

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<
                  AppLocalizations>
              old) =>
      false;
}
