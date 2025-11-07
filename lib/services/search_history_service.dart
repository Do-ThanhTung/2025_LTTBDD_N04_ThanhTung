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

  static SearchHistoryService get instance =>
      _instance;

  Future<void> loadHistory() async {
    try {
      final p = await SharedPreferences.getInstance();
      _history = p.getStringList(_key) ?? [];
    } catch (e) {
      _history = [];
    }
  }

  Future<void> addSearch(String term) async {
    if (term.isEmpty) return;

    _history.remove(term);
    _history.insert(0, term);

    if (_history.length > 50) {
      _history = _history.sublist(0, 50);
    }

    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(_key, _history);
    } catch (e) {
      // Ignore errors
    }
  }

  List<String> getHistory() => _history;

  Future<void> clearHistory() async {
    _history.clear();
    try {
      final p = await SharedPreferences.getInstance();
      await p.remove(_key);
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> removeItem(String term) async {
    _history.remove(term);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(_key, _history);
    } catch (e) {
      // Ignore errors
    }
  }
}
