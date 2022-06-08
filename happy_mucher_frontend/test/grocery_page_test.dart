import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';

void main() {
  group(
    'Added testing for grocery list',
    () {
      final firestore = FakeFirebaseFirestore();
      GetIt.I.registerSingleton<FirebaseFirestore>(firestore);
      const testApp = MaterialApp(
        home: Scaffold(
          body: GroceryListPage(),
        ),
      );

      setUp(() async {
        final query = await firestore.collection('GroceryList').get();
        final futures = query.docs.map((e) {
          return firestore.collection('GroceryList').doc(e.id).delete();
        });
        return await Future.wait(futures);
      });
      testWidgets(
        'Testing if page is empty on start up',
        (WidgetTester tester) async {
          //test to see if the list is empty on initial start up
          //runs the app and checks the list to see if it has 0 list tile widgets
          //success if finds 0 widgets
          await tester.pumpWidget(testApp);

          final inventoryList = find.byKey(const Key('Grocery_ListView'));
          expect(inventoryList, findsNothing);
        },
      );

      testWidgets(
        'Testing page filling from database',
        (WidgetTester tester) async {
          await firestore
              .collection('GroceryList')
              .add({"name": 'juice', "price": '1', "bought": false});
          await firestore
              .collection('GroceryList')
              .add({"name": 'apples', "price": '2', "bought": false});
          await firestore
              .collection('GroceryList')
              .add({"name": 'bread', "price": '3', "bought": false});

          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final listviews = find.byType(ListTile);

          expect(listviews, findsNWidgets(3));
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
