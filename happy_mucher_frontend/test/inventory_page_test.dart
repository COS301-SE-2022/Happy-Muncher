import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';

void main() {
  group(
    'Added testing for list',
    () {
      const testApp = MaterialApp(
        home: Scaffold(
          body: IventoryPage(),
        ),
      );
      testWidgets(
        'Testing if page is empty on start up',
        (WidgetTester tester) async {
          await tester.pumpWidget(testApp);

          final inventoryList = find.byKey(const Key('Inventory_ListView'));
          expect(inventoryList, findsOneWidget);

          final listTiles = find.byType(ListTile);
          expect(listTiles, findsNothing);
        },
      );

      testWidgets(
        'Testing if an item is added after entering on dialog box',
        (WidgetTester tester) async {
          await tester.pumpWidget(testApp);

          final dialogEnterButton =
              find.byKey(const Key('addToInventoryButton'));
          expect(dialogEnterButton, findsOneWidget);

          await tester.tap(dialogEnterButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final dialogReturnName =
              find.byKey(const Key('inventoryDialogNameField'));
          expect(dialogReturnName, findsOneWidget);

          final dialogReturnQuantity =
              find.byKey(const Key('inventoryDialogQuantityField'));
          expect(dialogReturnQuantity, findsOneWidget);

          final dialogReturnDate =
              find.byKey(const Key('inventoryDialogCalendarPickButton'));
          expect(dialogReturnDate, findsOneWidget);

          await tester.enterText(dialogReturnName, 'Apples');
          await tester.enterText(dialogReturnQuantity, '10');

          await tester.tap(dialogReturnDate);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
          await tester.tap(find.text('OK'));

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final dialogReturnButton =
              find.byKey(const Key('inventoryDialogAddButton'));
          expect(dialogReturnButton, findsOneWidget);

          await tester.tap(dialogReturnButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final inventoryList = find.byKey(const Key('Inventory_ListView'));
          expect(inventoryList, findsOneWidget);
          final listTiles = find.byType(ListTile);
          expect(listTiles, findsOneWidget);
        },
      );
    },
  );
}
