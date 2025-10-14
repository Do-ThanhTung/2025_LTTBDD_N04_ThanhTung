import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A simple local translation service that loads JSON mapping files from
/// assets (or could be extended to load from external files).
///
/// Expected asset files (optional):
/// - assets/data/local_en_vi.json  (mapping from English phrase -> Vietnamese)
/// - assets/data/local_vi_en.json  (mapping from Vietnamese phrase -> English)
///
/// Each file should be a flat JSON object: { "hello": "xin chào", "good morning": "chào buổi sáng" }
class TranslationService {
  TranslationService._();
  static final TranslationService instance = TranslationService._();

  final Map<String, String> _enToVi = {};
  final Map<String, String> _viToEn = {};
  bool _loaded = false;
  static const _prefsKeyEnVi = 'local_en_vi_user';
  static const _prefsKeyViEn = 'local_vi_en_user';
  static const _prefsKeyTargetLang = 'translation_target_lang';
  String _targetLang = 'vi';

  String get targetLang => _targetLang;

  Future<void> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _targetLang = prefs.getString(_prefsKeyTargetLang) ?? 'vi';
    } catch (_) {}
  }

  Future<void> saveTargetLang(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKeyTargetLang, code);
      _targetLang = code;
    } catch (_) {}
  }

  /// Call early (optional) to attempt loading the asset dictionaries.
  Future<void> loadAssets({
    String enViAsset = 'assets/data/local_en_vi.json',
    String viEnAsset = 'assets/data/local_vi_en.json',
  }) async {
    if (_loaded) return;
    try {
      final s = await rootBundle.loadString(enViAsset);
      final Map<String, dynamic> m = json.decode(s);
      m.forEach((k, v) {
        if (v is String) _enToVi[_normalize(k)] = v;
      });
    } catch (_) {
      // ignore missing asset
    }
    try {
      final s = await rootBundle.loadString(viEnAsset);
      final Map<String, dynamic> m = json.decode(s);
      m.forEach((k, v) {
        if (v is String) _viToEn[_normalize(k)] = v;
      });
    } catch (_) {
      // ignore missing asset
    }
    // Load any user-provided mappings from SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final envi = prefs.getString(_prefsKeyEnVi);
      if (envi != null) {
        final Map<String, dynamic> m = json.decode(envi);
        m.forEach((k, v) {
          if (v is String) _enToVi[_normalize(k)] = v;
        });
      }
      final vien = prefs.getString(_prefsKeyViEn);
      if (vien != null) {
        final Map<String, dynamic> m = json.decode(vien);
        m.forEach((k, v) {
          if (v is String) _viToEn[_normalize(k)] = v;
        });
      }
    } catch (_) {
      // ignore prefs errors
    }
    _loaded = true;
  }

  @override
  String toString() => 'TranslationService(target=$_targetLang)';

  /// Attempt a local translation. Returns null if nothing found.
  /// `to` should be either 'vi' or 'en'.
  Future<String?> translateLocal(String text, {required String to}) async {
    if (!_loaded) await loadAssets();
    // Offload heavy normalization/matching to a background isolate
    final args = {
      'enToVi': _enToVi,
      'viToEn': _viToEn,
      'text': text,
      'to': to,
    };
    try {
      final res = await compute(_translateLocalIsolate, args);
      return res;
    } catch (_) {
      return null;
    }
  }

  // split helper removed; isolate performs splitting/normalization for lookups

  String _normalize(String s) {
    var t = s.trim().toLowerCase();
    // remove punctuation
    t = t.replaceAll(RegExp(r"[\p{P}\p{S}]", unicode: true), '');
    // remove diacritics for Vietnamese to improve matching
    t = _removeDiacritics(t);
    return t.trim();
  }

  String _removeDiacritics(String str) {
    // Basic replacements for common Vietnamese diacritics
    const withDia =
        'áàảãạâấầẩẫậăắằẳẵặéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    const without =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuyyyyyd';
    var s = str;
    for (int i = 0; i < withDia.length; i++) {
      s = s.replaceAll(withDia[i], without[i]);
    }
    return s;
  }

  /// Top-level function executed in an isolate to perform normalization and lookup.
  /// Receives a Map with keys 'enToVi', 'viToEn', 'text', 'to'.
  String? _translateLocalIsolate(Map args) {
    final Map enToVi = Map.from(args['enToVi'] ?? {});
    final Map viToEn = Map.from(args['viToEn'] ?? {});
    final String text = args['text'] ?? '';
    final String to = args['to'] ?? 'vi';

    String normalizeLocal(String s) {
      var t = s.trim().toLowerCase();
      t = t.replaceAll(RegExp(r"[\p{P}\p{S}]", unicode: true), '');
      // remove diacritics (basic)
      const withDia =
          'áàảãạâấầẩẫậăắằẳẵặéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
      const without =
          'aaaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuyyyyyd';
      var s2 = t;
      for (int i = 0; i < withDia.length; i++) {
        s2 = s2.replaceAll(withDia[i], without[i]);
      }
      return s2.trim();
    }

    String key = normalizeLocal(text);
    if (key.isEmpty) return null;

    if (to == 'vi') {
      final exact = enToVi[key];
      if (exact is String) return exact;
      // try word by word
      final parts = key.split(RegExp(r"\s+"));
      final mapped =
          parts.map((p) => (enToVi[p] is String ? enToVi[p] : p)).join(' ');
      if (mapped.trim().isNotEmpty && mapped != key) {
        return mapped;
      }
    } else {
      final exact = viToEn[key];
      if (exact is String) return exact;
      final parts = key.split(RegExp(r"\s+"));
      final mapped =
          parts.map((p) => (viToEn[p] is String ? viToEn[p] : p)).join(' ');
      if (mapped.trim().isNotEmpty && mapped != key) {
        return mapped;
      }
    }
    return null;
  }

  /// Merge a JSON mapping into the local dictionary and persist it for future runs.
  /// `jsonString` should be a flat JSON object mapping source -> target.
  Future<void> mergeMappings(String jsonString, {required String to}) async {
    try {
      final Map<String, dynamic> m = json.decode(jsonString);
      if (to == 'vi') {
        m.forEach((k, v) {
          if (v is String) _enToVi[_normalize(k)] = v;
        });
        final prefs = await SharedPreferences.getInstance();
        final existing = prefs.getString(_prefsKeyEnVi);
        Map<String, dynamic> merged = {};
        if (existing != null) {
          merged.addAll(json.decode(existing));
        }
        merged.addAll(m);
        await prefs.setString(_prefsKeyEnVi, json.encode(merged));
      } else {
        m.forEach((k, v) {
          if (v is String) _viToEn[_normalize(k)] = v;
        });
        final prefs = await SharedPreferences.getInstance();
        final existing = prefs.getString(_prefsKeyViEn);
        Map<String, dynamic> merged = {};
        if (existing != null) {
          merged.addAll(json.decode(existing));
        }
        merged.addAll(m);
        await prefs.setString(_prefsKeyViEn, json.encode(merged));
      }
    } catch (_) {
      // ignore parse errors
    }
  }

  /// Add a single mapping and persist it.
  Future<void> addMapping(String source, String target,
      {required String to}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (to == 'vi') {
        final key = _normalize(source);
        _enToVi[key] = target;
        final existing = prefs.getString(_prefsKeyEnVi);
        Map<String, dynamic> merged = {};
        if (existing != null) {
          merged.addAll(json.decode(existing));
        }
        merged[source] = target;
        await prefs.setString(_prefsKeyEnVi, json.encode(merged));
      } else {
        final key = _normalize(source);
        _viToEn[key] = target;
        final existing = prefs.getString(_prefsKeyViEn);
        Map<String, dynamic> merged = {};
        if (existing != null) {
          merged.addAll(json.decode(existing));
        }
        merged[source] = target;
        await prefs.setString(_prefsKeyViEn, json.encode(merged));
      }
    } catch (_) {
      // ignore
    }
  }

  /// Return a list of English words/phrases available in the local dictionary.
  /// This is used by UI components to offer autocomplete suggestions.
  Future<List<String>> getEnglishWords() async {
    if (!_loaded) await loadAssets();
    // return original (non-normalized) keys where possible would require
    // storing originals; for now return the normalized keys which are fine
    // for suggestion/filtering purposes.
    return _enToVi.keys.map((k) => k.toString()).toList();
  }

  /// Return a map of original English phrase -> Vietnamese translation.
  /// This reads the asset `assets/data/local_en_vi.json` (if present)
  /// and merges any user-saved mappings from SharedPreferences so the UI
  /// can show human-friendly suggestions (original strings, not normalized keys).
  Future<Map<String, String>> getEnglishMap() async {
    final Map<String, String> result = {};
    // try load asset file first
    try {
      final s = await rootBundle.loadString('assets/data/local_en_vi.json');
      final Map<String, dynamic> m = json.decode(s);
      m.forEach((k, v) {
        if (v is String) result[k] = v;
      });
    } catch (_) {
      // ignore missing asset
    }
    // then merge any user-saved mappings
    try {
      final prefs = await SharedPreferences.getInstance();
      final envi = prefs.getString(_prefsKeyEnVi);
      if (envi != null) {
        final Map<String, dynamic> m = json.decode(envi);
        m.forEach((k, v) {
          if (v is String) result[k] = v;
        });
      }
    } catch (_) {}

    return result;
  }
}
