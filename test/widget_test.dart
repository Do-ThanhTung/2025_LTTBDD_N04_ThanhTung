// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:education/main.dart';

void main() {
  testWidgets('App builds and shows bottom navigation',
      (WidgetTester tester) async {
    // Build the app and settle animations
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // The app uses a BottomNavigationBar in BaseScreen; assert it's present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
