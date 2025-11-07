import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api.dart';
import '../models/response_model.dart';

/// Model để lưu thông tin từ vựng đầy đủ
class VocabularyItem {
  final String word;
  final String definition;
  final String example;

  VocabularyItem({
    required this.word,
    required this.definition,
    required this.example,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'example': example,
      };

  factory VocabularyItem.fromJson(Map<String, dynamic> json) => VocabularyItem(
        word: json['word'] ?? '',
        definition: json['definition'] ?? '',
        example: json['example'] ?? '',
      );
}

/// Service để quản lý từ vựng từ lịch sử tra từ
class VocabularyService {
  VocabularyService._();
  static final VocabularyService instance = VocabularyService._();

  static const String _vocabularyKey = 'saved_vocabulary_items';

  /// Lưu từ vựng kèm nghĩa và ví dụ
  Future<void> saveVocabularyItem(
      String word, String definition, String example) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final items = await getSavedVocabulary();

      items
          .removeWhere((item) => item.word.toLowerCase() == word.toLowerCase());

      items.insert(
          0,
          VocabularyItem(
            word: word,
            definition: definition,
            example: example,
          ));

      if (items.length > 100) {
        items.removeRange(100, items.length);
      }

      final jsonList = items.map((item) => item.toJson()).toList();
      await prefs.setString(_vocabularyKey, json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving vocabulary: $e');
    }
  }

  /// Lấy danh sách từ vựng đã lưu kèm nghĩa
  Future<List<VocabularyItem>> getSavedVocabulary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_vocabularyKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => VocabularyItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error loading vocabulary: $e');
      return [];
    }
  }

  /// Lấy danh sách tất cả các từ đã tra (chỉ từ, không có nghĩa)
  Future<List<String>> getSearchedWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searchedWords = prefs.getStringList('searched_words') ?? [];
      return searchedWords;
    } catch (e) {
      return [];
    }
  }

  /// Lấy danh sách từ yêu thích (người dùng chủ động nhấn "Lưu từ")
  Future<List<String>> getFavoriteWords() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoriteWords = prefs.getStringList('recent_searches') ?? [];
      return favoriteWords;
    } catch (e) {
      return [];
    }
  }

  /// Lấy từ vựng cho game: Lấy từ "Từ đã tra", ghép với nghĩa đã lưu
  Future<List<VocabularyItem>> getVocabularyForGame() async {
    final items = <VocabularyItem>[];
    final savedVocab = await getSavedVocabulary();
    final searchedWords = await getSearchedWords();

    for (var word in searchedWords) {
      final found = savedVocab.firstWhere(
        (item) => item.word.toLowerCase() == word.toLowerCase(),
        orElse: () => VocabularyItem(word: '', definition: '', example: ''),
      );
      if (found.word.isNotEmpty) {
        items.add(found);
      }
    }

    return items;
  }

  /// Lấy danh sách từ gần đây
  Future<List<String>> getRecentWords({int limit = 20}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentSearches = prefs.getStringList('recent_searches') ?? [];
      return recentSearches.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Lấy nghĩa của từ từ API
  Future<ResponseModel?> getWordMeaning(String word) async {
    try {
      return await API.fetchMeaning(word);
    } catch (e) {
      return null;
    }
  }

  /// Lấy định nghĩa đơn giản của từ
  Future<String> getSimpleDefinition(String word) async {
    try {
      final response = await API.fetchMeaning(word);
      if (response.meanings != null && response.meanings!.isNotEmpty) {
        final meaning = response.meanings!.first;
        if (meaning.definitions != null && meaning.definitions!.isNotEmpty) {
          return meaning.definitions!.first.definition ??
              'No definition available';
        }
      }
      return 'No definition available';
    } catch (e) {
      return 'Unable to fetch definition';
    }
  }

  /// Lấy ví dụ của từ
  Future<String> getExample(String word) async {
    try {
      final response = await API.fetchMeaning(word);
      if (response.meanings != null && response.meanings!.isNotEmpty) {
        final meaning = response.meanings!.first;
        if (meaning.definitions != null && meaning.definitions!.isNotEmpty) {
          final example = meaning.definitions!.first.example;
          if (example != null && example.isNotEmpty) {
            return example;
          }
        }
      }
      return 'No example available';
    } catch (e) {
      return 'No example available';
    }
  }

  /// Tạo gợi ý (hint) cho từ - hiển thị một số chữ cái
  String createHint(String word) {
    if (word.isEmpty) return '';

    final letters = word.toLowerCase().split('');
    final result = <String>[];

    for (int i = 0; i < letters.length; i++) {
      if (i == 0 || i == letters.length - 1 || i % 3 == 0) {
        result.add(letters[i]);
      } else {
        result.add('_');
      }
    }

    return result.join(' ');
  }

  /// Kiểm tra xem có đủ từ để chơi game không
  Future<bool> hasEnoughWords({int minWords = 5}) async {
    final words = await getSearchedWords();
    return words.length >= minWords;
  }

  /// Lấy số lượng từ đã tra
  Future<int> getWordCount() async {
    final words = await getSearchedWords();
    return words.length;
  }
}
