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

  testWidgets("Test February", ((WidgetTester tester) async {
    final february = find.byKey(ValueKey("feb"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(february);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test march", ((WidgetTester tester) async {
    final march = find.byKey(ValueKey("mar"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(march);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test April", ((WidgetTester tester) async {
    final february = find.byKey(ValueKey("apr"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(february);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test May", ((WidgetTester tester) async {
    final may = find.byKey(ValueKey("may"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(may);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test June", ((WidgetTester tester) async {
    final june = find.byKey(ValueKey("jun"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(june);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test July", ((WidgetTester tester) async {
    final July = find.byKey(ValueKey("jul"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(July);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test August", ((WidgetTester tester) async {
    final August = find.byKey(ValueKey("aug"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(August);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test September", ((WidgetTester tester) async {
    final September = find.byKey(ValueKey("sept"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(September);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test October", ((WidgetTester tester) async {
    final October = find.byKey(ValueKey("oct"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(October);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));

  testWidgets("Test November", ((WidgetTester tester) async {
    final November = find.byKey(ValueKey("nov"));

    await tester.pumpWidget(MaterialApp(home: Budget()));

    await tester.tap(November);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final setBudget = find.byKey(ValueKey("setBudget"));
    expect(setBudget, findsOneWidget);
  }));
}
