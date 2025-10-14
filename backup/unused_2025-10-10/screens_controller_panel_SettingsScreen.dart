// Bản sao lưu của: lib/screens/controller/panel/SettingsScreen.dart
// Nội dung gốc đã được lưu giữ để đảm bảo an toàn
// ignore_for_file: file_names
export 'package:education/screens/controller/panel/settings_screen.dart';
// settings_screen.dart - compatibility wrapper (giữ tương thích với các import cũ)
import 'package:flutter/material.dart';
import 'package:education/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.t(context, 'settings'))),
      body: Center(child: Text(AppLocalizations.t(context, 'settings'))),
    );
  }
}
