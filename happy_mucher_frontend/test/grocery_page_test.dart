import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';

void main() {
  group(
    'Added testing for grocery list',
    () {
      const testApp = MaterialApp(
        home: Scaffold(
          body: GroceryListPage(),
        ),
      );
      testWidgets(
        'Testing if page is empty on start up',
        (WidgetTester tester) async {
          //test to see if the list is empty on initial start up
          //runs the app and checks the list to see if it has 0 list tile widgets
          //success if finds 0 widgets
          await tester.pumpWidget(testApp);

          final inventoryList = find.byKey(const Key('Grocery_ListView'));
          expect(inventoryList, findsOneWidget);

          final listTiles = find.byType(ListTile);
          expect(listTiles, findsNothing);
        },
      );

      testWidgets(
        'Testing if an item is added after entering on dialog box',
        (WidgetTester tester) async {
          //test to see if the adding functionality works
          //adds the object ['apples', '10']
          await tester.pumpWidget(testApp);

          //finds the add button so that it can be pressed to open dialog
          final dialogEnterButton =
              find.byKey(const Key('addToGroceryListButton'));
          expect(dialogEnterButton, findsOneWidget);

          await tester.tap(dialogEnterButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          //finds all buttons on the dialog page
          //then adds text to the text fields and selects current date
          //then clicks OK
          //then checks if the list contains a list tile
          final dialogReturnName =
              find.byKey(const Key('groceryListDialogNameField'));
          expect(dialogReturnName, findsOneWidget);

          final dialogReturnQuantity =
              find.byKey(const Key('groceryListDialogPriceField'));
          expect(dialogReturnQuantity, findsOneWidget);

          await tester.enterText(dialogReturnName, 'Apples');
          await tester.enterText(dialogReturnQuantity, '10');

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final dialogReturnButton =
              find.byKey(const Key('groceryListDialogAddButton'));
          expect(dialogReturnButton, findsOneWidget);

          await tester.tap(dialogReturnButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final inventoryList = find.byKey(const Key('Grocery_ListView'));
          expect(inventoryList, findsOneWidget);
          final listTiles = find.byType(CheckboxListTile);
          expect(listTiles, findsOneWidget);
        },
      );
    },
  );
}
