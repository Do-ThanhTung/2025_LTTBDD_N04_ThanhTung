import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>>
      _localizedValues = {
    'en': {
      'settings': 'Settings',
      'settings_intro':
          'Personalize how you learn best',
      'account': 'Account',
      'profile': 'Profile',
      'profile_subtitle':
          'Update your display name and avatar',
      'security': 'Security',
      'security_subtitle':
          'Manage password and sign-in options',
      'preferences': 'Preferences',
      'dark_mode': 'Dark mode',
      'dark_mode_subtitle':
          'Give your eyes a break at night',
      'vocabulary': 'Vocabulary',
      'welcome_start': 'Welcome , Start searching',
      'practice_dictionary': 'Practice\nDictionary',
      'meaning_cannot_be_fetched':
          'Meaning cannot be fetched',
      'language': 'Language',
      'language_subtitle': 'Set the app language',
      'theme': 'Theme',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'notifications': 'Notifications',
      'notifications_subtitle':
          'Stay informed about new lessons',
      'system_default': 'System default',
      'light': 'Light',
      'dark': 'Dark',
      'home': 'Home',
      'my_learning': 'My Learning',
      'learning_progress': 'Learning Progress',
      'today_learning': 'Today\'s Learning',
      'daily_words_label': 'Daily Words',
      'saved_words_label': 'Saved Words',
      'read_stories_label': 'Read Stories',
      'stories_count': 'stories',
      'dictionary': 'Dictionary',
      'expand': 'Expand',
      'study_chill': 'Study & Chill',
      'learn_more_fun': 'Learn more, have fun',
      'learn_on_go':
          'Learn on the go — read and practice',
      'short_stories': 'Short Stories',
      'short_stories_subtitle': 'Read and learn words',
      'home_stats_title': 'Statistics',
      'home_stats_words': 'Words',
      'home_stats_games': 'Games',
      'home_stats_trophies': 'Trophies',
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
      'clear': 'Clear',
      // Settings - colors
      'primary_color': 'Primary Color',
      'choose_a_color': 'Choose a color',
      'primary_color_updated':
          'Primary color updated!',
      'text_to_speech': 'Text-to-speech',
      'tts_description': 'Enable voice pronunciation',
      'support': 'Support',
      'help_support': 'Help & support',
      'help_support_subtitle':
          'Get answers and contact support',
      'about': 'About',
      'logout': 'Logout',
      'logout_message_short':
          'Sign out of your account',
      'confirm_logout': 'Confirm logout',
      'logout_message':
          'Are you sure you want to logout?',
      'login_required': 'Login Required',
      'login_required_message':
          'You need to login to access this feature',
      'cancel': 'Cancel',
      // Login/Signup
      'welcome_back': 'Welcome Back!',
      'join_us': 'Join Us',
      'email': 'Email',
      'password': 'Password',
      'login': 'Login',
      'signup': 'Sign Up',
      'no_account': "Don't have an account? ",
      'have_account': 'Already have an account? ',
      'continue_as_guest': 'Continue as Guest',
      'fill_all_fields': 'Please fill all fields',
      'invalid_email': 'Please enter a valid email',
      'password_too_short':
          'Password must be at least 6 characters',
      'login_success': 'Login successful!',
      'signup_success':
          'Account created successfully!',
      'or': 'OR',
      'app_title': 'English Learning',
      'account_benefits':
          'Why do you need an account?',
      'benefit_history':
          'Save search history and favorite words',
      'benefit_features':
          'Sync learning progress across all devices',
      'login_with': 'Login with ',
      'login_with_email': 'Login with Email',
      'email_login': 'Email Login',
      'terms_intro':
          'When using PEnglish, you agree with our ',
      'terms_link': 'terms of use ',
      'privacy_link': 'and privacy policy',
      // Home screen - new home
      'additional': 'Additional',
      'search_word': 'Search word',
      'dictionary_search_hint': 'Search for a word...',
      'dictionary_search_button': 'Search',
      'dictionary_empty_subtitle':
          'Discover meanings, examples, and more',
      'dictionary_recent_searches': 'Recent Searches',
      'dictionary_suggested_words': 'Suggested Words',
      // Translation screen
      'translate_text': 'Translate Text',
      'practice': 'Practice',
      'auto_detect': 'Auto',
      'enter_text': 'Enter text',
      'translated_text': 'Translated text',
      'translate_button': 'Translate',
      'translate_now': 'Translate Now',
      'translation_screen_title': 'Translation',
      'translation_history_title':
          'Translation History',
      'copied_to_clipboard': 'Copied to clipboard',
      'enter_text_to_translate':
          'Please enter text to translate',
      'translation_failed_error':
          'Translation failed: {error}',
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
      'games_title': 'Learning Games',
      'flashcard_menu_title': 'Flashcards',
      'flashcard_menu_description':
          'Test your vocabulary with interactive flashcards',
      'flashcard_menu_badge': '20 cards',
      'game_trophies_badge': '{count} 🏆',
      'matching_menu_title': 'Matching',
      'matching_menu_description':
          'Match English words with Vietnamese meanings',
      'guessing_menu_title': 'Guess Word',
      'guessing_menu_description':
          'Guess the word using hints and definitions',
      'flashcard_header_title': 'Flashcards',
      'flashcard_progress_label':
          'Card {current} of {total}',
      'flashcard_skip': 'Skip',
      'flashcard_save': 'Save',
      'flashcard_known': 'I know this word',
      'flashcard_dialog_perfect_title': 'Amazing!',
      'flashcard_dialog_try_title': 'Keep trying!',
      'flashcard_dialog_try_body':
          'You need to practice more.',
      'flashcard_dialog_good_title': 'Great job!',
      'flashcard_dialog_good_body':
          'You know {known}/{total} words.',
      'flashcard_dialog_known_label': 'Known',
      'flashcard_dialog_skipped_label': 'Skipped',
      'flashcard_dialog_save_words': 'Save words',
      'flashcard_dialog_play_again': 'Play again',
      'flashcard_dialog_skip': 'Skip',
      'flashcard_saved_word':
          'Saved "{word}" to dictionary',
      'flashcard_login_required':
          'Please log in to save words',
      'flashcard_translated_label':
          'Translated to Vietnamese',
      'flashcard_translate_error':
          'Unable to translate this text',
      'flashcard_translate_failed':
          'Translation error: {error}',
      'matching_header_title': 'Matching',
      'matching_dialog_title': 'Great effort!',
      'matching_dialog_subtitle':
          'You matched everything correctly!',
      'matching_dialog_points': '{points} points',
      'matching_dialog_save_words': 'Save words',
      'matching_dialog_skip': 'Skip',
      'matching_dialog_play_again': 'Play again',
      'matching_select_words_title':
          'Choose words to save',
      'matching_save_button': 'Save ({count})',
      'matching_cancel': 'Cancel',
      'guessing_header_title': 'Guess Word',
      'guessing_hint_used_single': 'Used 1 hint',
      'guessing_hint_used_plural':
          'Used {count} hints',
      'guessing_input_placeholder':
          'Enter your answer...',
      'guessing_hint_button': 'Hint ({remaining})',
      'guessing_check_button': 'Check',
      'guessing_correct_title': 'Correct!',
      'guessing_incorrect_title': 'Not quite!',
      'guessing_correct_answer':
          'Correct answer: {word}',
      'translate_generic': 'Translate',
      'save_word': 'Save word',
      'complete': 'Finish',
      'guessing_translate_dialog_title': 'Translation',
      'guessing_translate_dialog_source': 'English',
      'guessing_translate_dialog_target': 'Vietnamese',
      'guessing_translate_dialog_close': 'Close',
      'guessing_translate_error':
          'Unable to translate. Please try again.',
      // About screen
      'about_app_name': 'English Learning',
      'about_version': 'Version 1.0.0',
      'about_copyright': 'Copyright © 2025',
      'about_developer': 'Do Thanh Tung',
      'about_developer_title': 'Flutter Developer',
      'about_developer_description':
          'Passionate about creating beautiful and functional mobile applications with Flutter.',
      'about_features': 'App Features',
      'about_feature_vocabulary': 'Rich Vocabulary',
      'about_feature_vocabulary_desc':
          'Learn English words with detailed definitions',
      'about_feature_games': 'Interactive Games',
      'about_feature_games_desc':
          'Practice with flashcards, matching games, and more',
      'about_feature_progress': 'Progress Tracking',
      'about_feature_progress_desc':
          'Monitor your learning progress with detailed statistics',
      'about_feature_customize': 'Customization',
      'about_feature_customize_desc':
          'Dark mode, multiple languages, and more options',
      'about_footer': 'Made in Vietnam ❤️',
    },
    'vi': {
      'settings': 'Cài đặt',
      'settings_intro':
          'Cá nhân hoá trải nghiệm học của bạn',
      'account': 'Tài khoản',
      'profile': 'Hồ sơ',
      'profile_subtitle':
          'Cập nhật tên hiển thị và ảnh đại diện',
      'security': 'Bảo mật',
      'security_subtitle':
          'Quản lý mật khẩu và tuỳ chọn đăng nhập',
      'preferences': 'Tuỳ chọn',
      'dark_mode': 'Chế độ tối',
      'dark_mode_subtitle':
          'Giảm chói mắt vào ban đêm',
      'vocabulary': 'Từ vựng',
      'welcome_start': 'Chào mừng, bắt đầu tìm kiếm',
      'practice_dictionary': 'Từ điển \n thực hành',
      'meaning_cannot_be_fetched':
          'Không thể lấy nghĩa',
      'language': 'Ngôn ngữ',
      'language_subtitle': 'Chọn ngôn ngữ hiển thị',
      'theme': 'Giao diện',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'notifications': 'Thông báo',
      'notifications_subtitle':
          'Nhận thông báo về bài học mới',
      'system_default': 'Mặc định hệ thống',
      'light': 'Sáng',
      'dark': 'Tối',
      'home': 'Trang chủ',
      'my_learning': 'Khóa học của tôi',
      'learning_progress': 'Quá trình học tập',
      'today_learning': 'Học hôm nay',
      'daily_words_label': 'Từ học hôm nay',
      'saved_words_label': 'Từ đã lưu',
      'read_stories_label': 'Truyện đã đọc',
      'stories_count': 'truyện',
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
      'home_stats_title': 'Thống kê',
      'home_stats_words': 'Từ',
      'home_stats_games': 'Trò chơi',
      'home_stats_trophies': 'Cúp',
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
      'clear': 'Xóa',
      // Settings - colors
      'primary_color': 'Màu chủ đạo',
      'choose_a_color': 'Chọn một màu',
      'primary_color_updated':
          'Đã cập nhật màu chủ đạo!',
      'text_to_speech': 'Đọc văn bản',
      'tts_description': 'Bật phát âm giọng đọc',
      'support': 'Hỗ trợ',
      'help_support': 'Trợ giúp & hỗ trợ',
      'help_support_subtitle':
          'Tìm câu trả lời hoặc liên hệ hỗ trợ',
      'about': 'Giới thiệu',
      'logout': 'Đăng xuất',
      'logout_message_short':
          'Đăng xuất khỏi tài khoản',
      'confirm_logout': 'Xác nhận đăng xuất',
      'logout_message':
          'Bạn có chắc chắn muốn đăng xuất không?',
      'login_required': 'Yêu cầu đăng nhập',
      'login_required_message':
          'Bạn cần đăng nhập để xem tính năng này',
      'cancel': 'Hủy',
      // Login/Signup
      'welcome_back': 'Chào mừng trở lại!',
      'join_us': 'Tham gia cùng chúng tôi',
      'email': 'Email',
      'password': 'Mật khẩu',
      'login': 'Đăng nhập tài khoản',
      'signup': 'Tạo tài khoản mới',
      'no_account': 'Chưa có tài khoản? ',
      'have_account': 'Đã có tài khoản? ',
      'continue_as_guest': 'Tiếp tục dưới dạng khách',
      'fill_all_fields':
          'Vui lòng điền tất cả các trường',
      'invalid_email': 'Vui lòng nhập email hợp lệ',
      'password_too_short':
          'Mật khẩu phải có ít nhất 6 ký tự',
      'login_success': 'Đăng nhập thành công!',
      'signup_success':
          'Tài khoản đã được tạo thành công!',
      'or': 'HOẶC',
      'app_title': 'Học Tiếng Anh',
      'account_benefits': 'Tại sao cần tài khoản?',
      'benefit_history':
          'Lưu lịch sử sử tra cứu và từ yêu thích',
      'benefit_features':
          'Tiến độ học tập đồng bộ trên tất cả thiết bị',
      'login_with': 'Đăng nhập với ',
      'login_with_email': 'Đăng nhập bằng Email',
      'email_login': 'Đăng nhập Email',
      'terms_intro':
          'Khi sử dụng PEnglish, bạn đồng ý với ',
      'terms_link': 'điều khoản sử dụng ',
      'privacy_link': 'và chính sách bảo mật',
      // Home screen - new home
      'additional': 'Bổ sung',
      'search_word': 'Tìm kiếm từ',
      'dictionary_search_hint': 'Tìm kiếm một từ...',
      'dictionary_search_button': 'Tìm kiếm',
      'dictionary_empty_subtitle':
          'Khám phá nghĩa, ví dụ và nhiều hơn nữa',
      'dictionary_recent_searches': 'Tìm kiếm gần đây',
      'dictionary_suggested_words': 'Gợi ý từ',
      // Translation screen
      'translate_text': 'Dịch văn bản',
      'practice': 'Thực hành',
      'auto_detect': 'Tự động',
      'enter_text': 'Nhập văn bản',
      'translated_text': 'Văn bản dịch',
      'translate_button': 'Dịch',
      'translate_now': 'Dịch ngay',
      'translation_screen_title': 'Dịch',
      'translation_history_title': 'Lịch sử dịch',
      'copied_to_clipboard':
          'Đã sao chép vào bộ nhớ tạm',
      'enter_text_to_translate':
          'Vui lòng nhập văn bản để dịch',
      'translation_failed_error':
          'Dịch thất bại: {error}',
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
      'games_title': 'Trò chơi học tập',
      'flashcard_menu_title': 'Thẻ ghi nhớ',
      'flashcard_menu_description':
          'Kiểm tra vốn từ vựng với thẻ ghi nhớ tương tác',
      'flashcard_menu_badge': '20 thẻ',
      'game_trophies_badge': '{count} 🏆',
      'matching_menu_title': 'Ghép đôi',
      'matching_menu_description':
          'Ghép từ tiếng Anh với nghĩa tiếng Việt',
      'guessing_menu_title': 'Đoán từ',
      'guessing_menu_description':
          'Đoán từ dựa trên gợi ý và định nghĩa',
      'flashcard_header_title': 'Thẻ ghi nhớ',
      'flashcard_progress_label':
          'Thẻ {current} trong số {total}',
      'flashcard_skip': 'Bỏ qua',
      'flashcard_save': 'Lưu',
      'flashcard_known': 'Tôi biết từ này',
      'flashcard_dialog_perfect_title': 'Tuyệt vời!',
      'flashcard_dialog_try_title': 'Cố gắng lên!',
      'flashcard_dialog_try_body':
          'Bạn phải cố gắng nhiều hơn.',
      'flashcard_dialog_good_title': 'Chúc mừng!',
      'flashcard_dialog_good_body':
          'Bạn đã biết {known}/{total} từ.',
      'flashcard_dialog_known_label': 'Đã biết',
      'flashcard_dialog_skipped_label': 'Bỏ qua',
      'flashcard_dialog_save_words': 'Lưu từ',
      'flashcard_dialog_play_again': 'Chơi lại',
      'flashcard_dialog_skip': 'Bỏ qua',
      'flashcard_saved_word':
          'Đã lưu "{word}" vào từ điển',
      'flashcard_login_required':
          'Vui lòng đăng nhập để lưu từ',
      'flashcard_translated_label':
          'Đã dịch sang Tiếng Việt',
      'flashcard_translate_error':
          'Không thể dịch văn bản này',
      'flashcard_translate_failed':
          'Lỗi khi dịch: {error}',
      'matching_header_title': 'Ghép từ',
      'matching_dialog_title': 'Cố gắng lên!',
      'matching_dialog_subtitle':
          'Bạn đã ghép đúng tất cả!',
      'matching_dialog_points': '{points} điểm',
      'matching_dialog_save_words': 'Lưu từ',
      'matching_dialog_skip': 'Bỏ qua',
      'matching_dialog_play_again': 'Chơi lại',
      'matching_select_words_title': 'Chọn từ cần lưu',
      'matching_save_button': 'Lưu ({count})',
      'matching_cancel': 'Hủy',
      'guessing_header_title': 'Đoán từ',
      'guessing_hint_used_single': 'Đã dùng 1 gợi ý',
      'guessing_hint_used_plural':
          'Đã dùng {count} gợi ý',
      'guessing_input_placeholder':
          'Nhập đáp án của bạn...',
      'guessing_hint_button': 'Gợi ý ({remaining})',
      'guessing_check_button': 'Kiểm tra',
      'guessing_correct_title': 'Chính xác!',
      'guessing_incorrect_title': 'Chưa đúng!',
      'guessing_correct_answer': 'Đáp án đúng: {word}',
      'translate_generic': 'Dịch',
      'save_word': 'Lưu từ',
      'complete': 'Hoàn thành',
      'guessing_translate_dialog_title': 'Bản dịch',
      'guessing_translate_dialog_source': 'Tiếng Anh',
      'guessing_translate_dialog_target': 'Tiếng Việt',
      'guessing_translate_dialog_close': 'Đóng',
      'guessing_translate_error':
          'Không thể dịch. Vui lòng thử lại.',
      // About screen
      'about_app_name': 'Học Tiếng Anh',
      'about_version': 'Phiên bản 1.0.0',
      'about_copyright': 'Bản quyền © 2025',
      'about_developer': 'Đỗ Thanh Tùng',
      'about_developer_title': 'Flutter Developer',
      'about_developer_description':
          'Đam mê tạo các ứng dụng di động đẹp và chức năng với Flutter.',
      'about_features': 'Tính năng của ứng dụng',
      'about_feature_vocabulary': 'Từ vựng phong phú',
      'about_feature_vocabulary_desc':
          'Học từ tiếng Anh có định nghĩa chi tiết',
      'about_feature_games': 'Trò chơi tương tác',
      'about_feature_games_desc':
          'Thực hành với thẻ ghi nhớ, trò chơi ghép đôi, v.v.',
      'about_feature_progress': 'Theo dõi tiến độ',
      'about_feature_progress_desc':
          'Giám sát tiến độ học của bạn với thống kê chi tiết',
      'about_feature_customize': 'Tùy chỉnh',
      'about_feature_customize_desc':
          'Chế độ tối, nhiều ngôn ngữ, và thêm nhiều tùy chọn',
      'about_footer': 'Tạo ra ở Việt Nam ❤️',
    },
  };

  static String t(BuildContext context, String key) {
    final code =
        Localizations.localeOf(context).languageCode;
    return _localizedValues[code]?[key] ?? key;
  }

  static String tr(
    BuildContext context,
    String key, {
    Map<String, String>? params,
  }) {
    var value = t(context, key);
    if (params != null) {
      for (final entry in params.entries) {
        value = value.replaceAll(
            '{${entry.key}}', entry.value);
      }
    }
    return value;
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
