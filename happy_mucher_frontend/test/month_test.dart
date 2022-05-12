// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:happy_mucher_frontend/pages/month.dart';

void main() {
  testWidgets("Test set Budget", ((WidgetTester tester) async {
    final enterBudget = find.byKey(ValueKey("enterBudget"));
    final setBudget = find.byKey(ValueKey("setBudget"));

    //Test
    await tester.pumpWidget(MaterialApp(home: Month(month: "jan")));
    await tester.enterText(enterBudget, "800");
    await tester.tap(setBudget);
    await tester.pump();

    //check
    expect(find.text("800"), findsOneWidget);
  }));

//Test week 1 amount spent input
  testWidgets("Test set amount spent in week", ((WidgetTester tester) async {
    final setSpent = find.byKey(ValueKey("spent1"));
    //Test
    await tester.pumpWidget(MaterialApp(home: Month(month: "jan")));
    await tester.enterText(setSpent, "20");

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    //check
    expect(find.text("20"), findsOneWidget);
  }));
}
