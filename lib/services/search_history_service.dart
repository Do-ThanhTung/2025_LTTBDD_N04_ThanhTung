import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static final SearchHistoryService _instance =
      SearchHistoryService._internal();

  factory SearchHistoryService() {
    return _instance;
  }

  SearchHistoryService._internal();

  static final _key = 'search_history';
  List<String> _history = [];

  // Get singleton instance
  static SearchHistoryService get instance =>
      _instance;

  // Load history from SharedPreferences
  Future<void> loadHistory() async {
    try {
      final p = await SharedPreferences.getInstance();
      _history = p.getStringList(_key) ?? [];
    } catch (e) {
      _history = [];
    }
  }

  // Add a search term to history (avoid duplicates, keep most recent first)
  Future<void> addSearch(String term) async {
    if (term.isEmpty) return;

    // Remove if already exists to avoid duplicates
    _history.remove(term);

    // Add to the beginning (most recent first)
    _history.insert(0, term);

    // Keep only last 50 searches
    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }

    // Save to SharedPreferences
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(_key, _history);
    } catch (e) {
      // Silently fail
    }
  }

  // Get all history
  List<String> getHistory() => _history;

  // Clear all history
  Future<void> clearHistory() async {
    _history.clear();
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_key);
    } catch (e) {
      // Silently fail
    }
  }

  // Remove a specific item from history
  Future<void> removeItem(String term) async {
    _history.remove(term);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(_key, _history);
    } catch (e) {
      // Silently fail
    }
  }
}
