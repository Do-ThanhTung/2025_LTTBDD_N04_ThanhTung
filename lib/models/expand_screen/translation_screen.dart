import 'package:flutter/material.dart';
import 'package:translator_plus/translator_plus.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key})
    : super(key: key);

  @override
  State<TranslationScreen> createState() =>
      _TranslationScreenState();
}

class _TranslationScreenState
    extends State<TranslationScreen> {
  final TextEditingController _controller =
      TextEditingController();
  final translator = GoogleTranslator();
  String _result = '';
  String from = 'auto';
  String to = 'vi';

  Future<void> _translate() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;
    final res = await translator.translate(
      input,
      from: from,
      to: to,
    );
    setState(() {
      _result = res.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dịch văn bản'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: from,
                    items: const [
                      DropdownMenuItem(
                        value: 'auto',
                        child: Text('Tự động'),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'vi',
                        child: Text('Tiếng Việt'),
                      ),
                    ],
                    onChanged: (v) => setState(
                      () => from = v ?? 'auto',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: to,
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'vi',
                        child: Text('Tiếng Việt'),
                      ),
                    ],
                    onChanged: (v) =>
                        setState(() => to = v ?? 'vi'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập văn bản',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _translate,
              child: const Text('Dịch'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
