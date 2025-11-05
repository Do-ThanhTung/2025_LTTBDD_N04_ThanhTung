// Bản sao lưu của: lib/screens/controller/panel/MyLearningScreen.dart
// Nội dung gốc đã được lưu giữ để đảm bảo an toàn
// ignore_for_file: file_names
export 'package:education/screens/controller/panel/my_learning_screen.dart';
import 'package:flutter/material.dart';
import 'package:education/l10n/app_localizations.dart';

class MyLearningScreen extends StatelessWidget {
  const MyLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.t(
              context, 'my_learning'))),
      body: Center(
          child: Text(AppLocalizations.t(
              context, 'my_learning'))),
    );
  }
}
