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
    },
  );
}
