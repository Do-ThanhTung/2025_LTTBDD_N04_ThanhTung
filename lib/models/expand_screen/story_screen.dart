import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:education/l10n/app_localizations.dart';
import 'package:flutter/services.dart' show rootBundle;

class Story {
  final String title;
  final String content;
  Story({required this.title, required this.content});
  factory Story.fromJson(Map<String, dynamic> j) =>
      Story(
        title: j['title'] ?? '',
        content: j['content'] ?? '',
      );
}

class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() =>
      _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  List<Story> stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    try {
      final s = await rootBundle.loadString(
        'assets/data/stories.json',
      );
      final list = json.decode(s) as List<dynamic>;
      setState(() {
        stories = list
            .map(
              (e) => Story.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      });
    } catch (e) {
      // silently ignore, show empty list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.t(
              context, 'story_short'))),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (c, i) {
          final st = stories[i];
          return ListTile(
            title: Text(st.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(st.title),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(
                          16.0,
                        ),
                        child: SingleChildScrollView(
                          child: Text(st.content),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
