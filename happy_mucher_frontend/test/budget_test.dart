// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get_it/get_it.dart';

// import 'package:happy_mucher_frontend/pages/budget.dart';

// void main() {
//   group('Tests for budget', () {
//     final firestore = FakeFirebaseFirestore();
//     GetIt.I.registerSingleton<FirebaseFirestore>(firestore);
//     const testApp = MaterialApp(
//       home: Scaffold(
//         body: MyBudget(),
//       ),
//     );

//     testWidgets("Test january", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final january = find.byKey(ValueKey("jan"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(january);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test February", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final february = find.byKey(ValueKey("feb"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(february);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test march", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final march = find.byKey(ValueKey("mar"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(march);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test April", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final february = find.byKey(ValueKey("apr"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(february);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test May", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final may = find.byKey(ValueKey("may"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(may);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test June", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final june = find.byKey(ValueKey("jun"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(june);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test July", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final July = find.byKey(ValueKey("jul"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(July);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test August", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final August = find.byKey(ValueKey("aug"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(August);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test September", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final September = find.byKey(ValueKey("sept"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(September);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test October", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final October = find.byKey(ValueKey("oct"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(October);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));

//     testWidgets("Test November", ((WidgetTester tester) async {
//       await tester.pumpWidget(testApp);
//       final November = find.byKey(ValueKey("nov"));

//       await tester.pumpWidget(MaterialApp(home: MyBudget()));

//       await tester.tap(November);
//       await tester.pumpAndSettle(const Duration(milliseconds: 300));
//       final setBudget = find.byKey(ValueKey("setBudget"));
//       expect(setBudget, findsOneWidget);
//     }));
//   });
// }
