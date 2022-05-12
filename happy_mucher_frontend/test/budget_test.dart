// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/month.dart';

void main() {
  testWidgets("Test january", ((WidgetTester tester) async {
    final january = find.byKey(ValueKey("jan"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(january);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));
}
