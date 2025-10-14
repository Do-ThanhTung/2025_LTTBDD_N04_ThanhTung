import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:education/main.dart';

class Truyen {
  final String title;
  final String content;
  Truyen({required this.title, required this.content});
  factory Truyen.fromJson(Map<String, dynamic> j) => Truyen(
        title: j['title'] ?? 'No title',
        content: j['content'] ?? '',
      );
}

class TruyenListScreen extends StatefulWidget {
  const TruyenListScreen({Key? key}) : super(key: key);

  @override
  State<TruyenListScreen> createState() => _TruyenListScreenState();
}

class _TruyenListScreenState extends State<TruyenListScreen> {
  List<Truyen> _list = [];
  List<Truyen> _filtered = [];
  bool _loading = true;
  String? _error;
  Set<String> _bookmarks = {};

  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTruyen();
    _loadBookmarks();
    _searchCtrl.addListener(_onSearch);
  }

  Future<void> _loadBookmarks() async {
    try {
      final p = await SharedPreferences.getInstance();
      final saved = p.getStringList('bookmarks') ?? [];
      if (!mounted) return;
      setState(() {
        _bookmarks = saved.toSet();
      });
    } catch (e) {
      // ignore load bookmark errors
    }
  }

  Future<void> _toggleBookmark(Truyen t) async {
    try {
      final p = await SharedPreferences.getInstance();
      final title = t.title;
      if (_bookmarks.contains(title)) {
        _bookmarks.remove(title);
      } else {
        _bookmarks.add(title);
      }
      await p.setStringList(
        'bookmarks',
        _bookmarks.toList(),
      );
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      // ignore save errors
    }
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (!mounted) return;
    setState(() {
      _filtered = q.isEmpty
          ? List.from(_list)
          : _list
              .where(
                (t) =>
                    t.title.toLowerCase().contains(
                          q,
                        ) ||
                    t.content.toLowerCase().contains(
                          q,
                        ),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadTruyen() async {
    try {
      final s = await rootBundle.loadString(
        'assets/data/stories.json',
      );
      final data = json.decode(s) as List<dynamic>;
      final loaded = data
          .map(
            (e) => Truyen.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
      if (!mounted) return;
      setState(() {
        _list = loaded;
        _filtered = List.from(_list);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error =
            '${AppLocalizations.t(context, 'meaning_cannot_be_fetched')}: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.t(context, 'story_short')),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: AppLocalizations.t(context, 'vocabulary'),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(child: Text(_error!))
              : _buildList(),
    );
  }

  Widget _buildList() {
    final src = _filtered;
    if (src.isEmpty) {
      return Center(
        child: Text(AppLocalizations.t(context, 'no_results')),
      );
    }
    return ListView.separated(
      itemCount: src.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final t = src[index];
        final bookmarked = _bookmarks.contains(
          t.title,
        );
        return ListTile(
          title: Text(t.title),
          trailing: IconButton(
            icon: Icon(
              bookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () async => await _toggleBookmark(t),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TruyenDetailScreen(truyen: t),
              ),
            );
          },
        );
      },
    );
  }
}

class TruyenDetailScreen extends StatefulWidget {
  final Truyen truyen;
  const TruyenDetailScreen({
    Key? key,
    required this.truyen,
  }) : super(key: key);

  @override
  State<TruyenDetailScreen> createState() => _TruyenDetailScreenState();
}

class _TruyenDetailScreenState extends State<TruyenDetailScreen> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  bool _awaiting = false;

  @override
  void initState() {
    super.initState();
    // Register handlers to track progress and errors
    try {
      _tts.setStartHandler(() {
        if (!mounted) return;
        setState(() => _speaking = true);
      });
    } catch (_) {}
    try {
      _tts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() => _speaking = false);
      });
    } catch (_) {}
    try {
      _tts.setErrorHandler((msg) {
        if (!mounted) return;
        setState(() => _speaking = false);
      });
    } catch (_) {}
  }

  Future<void> _toggleTts() async {
    if (_awaiting) return;
    _awaiting = true;
    try {
      if (_speaking) {
        await _tts.stop();
        if (!mounted) return;
        setState(() => _speaking = false);
        _awaiting = false;
        return;
      }

      // Prefer app locale for TTS language; fallback to simple heuristic
      final text = widget.truyen.content;
      String lang;
      try {
        final code = AppLocale.locale.value.languageCode;
        if (code == 'vi') {
          lang = 'vi-VN';
        } else {
          lang = 'en-US';
        }
      } catch (_) {
        final useVi = RegExp(
          r'[ăâđêôơưáàạảãắằặẵấầậẩẫíìịỉĩýỳỵỷỹ]',
        ).hasMatch(text.toLowerCase());
        lang = useVi ? 'vi-VN' : 'en-US';
      }

      await _tts.setLanguage(lang);
      try {
        await _tts.awaitSpeakCompletion(true);
      } catch (_) {}
      await _tts.speak(text);
      if (!mounted) return;
      setState(() => _speaking = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _speaking = false);
    } finally {
      _awaiting = false;
    }
  }

  @override
  void dispose() {
    try {
      _tts.stop();
      // set empty handlers rather than null to avoid type errors
      _tts.setStartHandler(() {});
      _tts.setCompletionHandler(() {});
      _tts.setErrorHandler((msg) {});
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.truyen.title),
        actions: [
          IconButton(
            icon: Icon(
              _speaking ? Icons.volume_off : Icons.volume_up,
            ),
            onPressed: _toggleTts,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            widget.truyen.content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
