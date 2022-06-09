// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/weekday.dart';

void main() {
  testWidgets("Test monday", ((WidgetTester tester) async {
    final monday = find.byKey(ValueKey("mon"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(monday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));

  testWidgets("Test tuesday", ((WidgetTester tester) async {
    final tuesday = find.byKey(ValueKey("tue"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(tuesday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
  testWidgets("Test wednesday", ((WidgetTester tester) async {
    final wednesday = find.byKey(ValueKey("wed"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(wednesday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
  testWidgets("Test thursday", ((WidgetTester tester) async {
    final thursday = find.byKey(ValueKey("thu"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(thursday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
  testWidgets("Test friday", ((WidgetTester tester) async {
    final friday = find.byKey(ValueKey("fri"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(friday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
  testWidgets("Test saturday", ((WidgetTester tester) async {
    final saturday = find.byKey(ValueKey("sat"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(saturday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
  testWidgets("Test sunday", ((WidgetTester tester) async {
    final sunday = find.byKey(ValueKey("sun"));

    await tester.pumpWidget(MaterialApp(home: MealPage()));

    await tester.tap(sunday);
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
  }));
}
