// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:object_detection/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: MyApp()));

    // Verify that our counter starts at 0.
    expect(find.text('Real'), findsOneWidget);
    expect(find.text('Imagen'), findsOneWidget);

    await tester.tap(find.text('Real'));
    await tester.pump();
    await tester.tap(find.text('Imagen'));
    await tester.pump();
  });
}
