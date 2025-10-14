import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'vocabulary': 'Vocabulary',
      'welcome_start': 'Welcome , Start searching',
      'practice_dictionary': 'Practice\nDictionary',
      'meaning_cannot_be_fetched': 'Meaning cannot be fetched',
      'language': 'Language',
      'theme': 'Theme',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'system_default': 'System default',
      'light': 'Light',
      'dark': 'Dark',
      'my_learning': 'My Learning',
      'dictionary': 'Dictionary',
      'expand': 'Expand',
      // Expand screen
      'story_short': 'Short Stories',
      'game': 'Game',
      'translation': 'Translation',
      'ok': 'OK',
      'translation_failed': 'Translation failed',
      'expand_header_title': 'Study & Chill\nLearn more, have fun',
      'expand_header_subtitle': 'Learn on the go — read and practice',
      'definition': 'Definition',
      'synonyms': 'Synonyms',
      'antonyms': 'Antonyms',
      'nothing_to_translate': 'Nothing to translate',
      'translation_network_hint':
          'Please check your internet connection and try again',
      'not_found_in_local': 'No local translation found for this text',
      'no_results': 'No results',
    },
    'vi': {
      'settings': 'Cài đặt',
      'vocabulary': 'Từ vựng',
      'welcome_start': 'Chào mừng, bắt đầu tìm kiếm',
      'practice_dictionary': 'Từ điển \n thực hành',
      'meaning_cannot_be_fetched': 'Không thể lấy nghĩa',
      'language': 'Ngôn ngữ',
      'theme': 'Giao diện',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'system_default': 'Mặc định hệ thống',
      'light': 'Sáng',
      'dark': 'Tối',
      'my_learning': 'Khóa học của tôi',
      'dictionary': 'Từ điển',
      'expand': 'Mở rộng',
      // Expand screen
      'story_short': 'Truyện ngắn',
      'game': 'Trò chơi',
      'translation': 'Dịch văn bản',
      'ok': 'OK',
      'translation_failed': 'Dịch thất bại',
      'expand_header_title': 'Vừa học vừa chill\nCàng học càng fun',
      'expand_header_subtitle':
          'Ứng dụng ngay kiến vừa học \nvào đọc và phản xạ',
      'definition': 'Định nghĩa',
      'synonyms': 'Từ đồng nghĩa',
      'antonyms': 'Từ trái nghĩa',
      'nothing_to_translate': 'Không có gì để dịch',
      'translation_network_hint': 'Vui lòng kiểm tra kết nối mạng và thử lại',
      'not_found_in_local': 'Không tìm thấy bản dịch nội bộ cho văn bản này',
      'no_results': 'Không có kết quả',
    },
  };

  static String t(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return _localizedValues[code]?[key] ?? key;
  }
}

/// A simple delegate so `AppLocalizations` can be used with
/// `MaterialApp.localizationsDelegates`.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Nothing async to do, but return an instance so the delegate works.
    return AppLocalizations();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
