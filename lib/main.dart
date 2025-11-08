import 'package:education/app/app.dart';
import 'package:education/app/config/app_locale.dart';
import 'package:education/app/config/app_primary_color.dart';
import 'package:education/app/config/app_theme.dart';
import 'package:education/core/services/notification_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLocale.load();
  await AppTheme.load();
  await AppPrimaryColor.load();
  await NotificationService.instance.loadConfig();

  runApp(const MyApp());
}
