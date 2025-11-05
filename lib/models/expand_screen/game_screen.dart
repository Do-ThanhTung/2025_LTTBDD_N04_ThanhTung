import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() =>
      _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<String> words = [
    'apple',
    'house',
    'flutter',
    'lesson',
    'english',
  ];
  late String word;
  Set<String> guessed = {};
  int remaining = 6;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _newWord();
  }

  void _newWord() {
    final r = Random();
    word = words[r.nextInt(words.length)]
        .toUpperCase();
    guessed.clear();
    remaining = 6;
    finished = false;
    setState(() {});
  }

  void _guess(String ch) {
    if (finished) return;
    ch = ch.toUpperCase();
    if (!word.contains(ch)) {
      remaining--;
    }
    guessed.add(ch);
    if (remaining <= 0 ||
        word
            .split('')
            .every((c) => guessed.contains(c))) {
      finished = true;
    }
    setState(() {});
  }

  Widget _buildKeyboard() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(
      '',
    );
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: letters.map((l) {
        final used = guessed.contains(l);
        return ElevatedButton(
          onPressed: used || finished
              ? null
              : () => _guess(l),
          child: Text(l),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final display = word
        .split('')
        .map((c) => guessed.contains(c) ? c : '_')
        .join(' ');
    return Scaffold(
      appBar: AppBar(title: const Text('Đoán chữ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              display,
              style: const TextStyle(
                fontSize: 32,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text('Lượt còn lại: $remaining'),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: _buildKeyboard(),
              ),
            ),
            const SizedBox(height: 8),
            if (finished)
              Column(
                children: [
                  Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _newWord,
                    child: const Text('Chơi lại'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
