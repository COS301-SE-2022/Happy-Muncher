import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  group(
    'Added testing for list',
    () {
      TestWidgetsFlutterBinding.ensureInitialized();
      final MockFlutterLocalNotificationsPlugin mock =
          MockFlutterLocalNotificationsPlugin();
      FlutterLocalNotificationsPlatform.instance = mock;

      final firestore = FakeFirebaseFirestore();
      GetIt.I.registerSingleton<FirebaseFirestore>(firestore);
      final user = MockUser(
        isAnonymous: false,
        uid: 'abc',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
        photoURL:
            'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png',
      );
      final auth = MockFirebaseAuth(
        mockUser: user,
        signedIn: true,
      );
      GetIt.I.registerSingleton<FirebaseAuth>(auth);
      const testApp = MaterialApp(
        home: Scaffold(
          body: IventoryPage(),
        ),
      );

      setUpAll(() => HttpOverrides.global = null);

      setUp(() async {
        final query = await firestore
            .collection('Users')
            .doc('abc')
            .collection('Inventory')
            .get();
        final futures = query.docs.map((e) {
          return firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .doc(e.id)
              .delete();
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

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final listviews = find.byType(ListTile);

          expect(listviews, findsNWidgets(0));
        },
      );

      testWidgets(
        'Testing page filling from database',
        (WidgetTester tester) async {
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .add({
            "itemName": 'juice',
            "quantity": 1,
            "expirationDate": DateTime.now().toString(),
          });
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .add({
            "itemName": 'apple',
            "quantity": 2,
            "expirationDate": DateTime.now().toString(),
          });
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .add({
            "itemName": 'grape',
            "quantity": 3,
            "expirationDate": DateTime.now().toString(),
          });

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
          //adds the object ['apples', '10', Current date]
          await tester.pumpWidget(testApp);

          //finds the add button so that it can be pressed to open dialog
          final dialogEnterButton =
              find.byKey(const Key('addToInventoryButton'));
          expect(dialogEnterButton, findsOneWidget);

          await tester.tap(dialogEnterButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final dialogEnterButtonText =
              find.byKey(const Key('addToInventoryButtonText'));
          expect(dialogEnterButtonText, findsOneWidget);

          await tester.tap(dialogEnterButtonText);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          //finds all buttons on the dialog page
          //then adds text to the text fields and selects current date
          //then clicks OK
          //then checks if the list contains a list tile
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

      testWidgets(
        'Testing deleting',
        (WidgetTester tester) async {
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .add({
            "itemName": 'juice',
            "quantity": 1,
            "expirationDate": DateTime.now().toString(),
          });

          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final itemListTile = find.byType(ListTile);

          await tester.drag(itemListTile, const Offset(200, 0));

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final deleteButton = find.byType(SlidableAction).first;
          await tester.tap(deleteButton);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(itemListTile, findsNothing);
        },
      );

      testWidgets(
        'Testing editing',
        (WidgetTester tester) async {
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Inventory')
              .add({
            "itemName": 'juice',
            "quantity": 1,
            "expirationDate": DateTime.now().toString(),
          });

          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final itemListTile = find.byType(ListTile);

          await tester.drag(itemListTile, const Offset(200, 0));

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final editButton = find.byType(SlidableAction).last;
          await tester.tap(editButton);

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

          // await tester.tap(dialogReturnDate);
          // await tester.pumpAndSettle(const Duration(milliseconds: 300));
          // await tester.tap(find.text('OK'));

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

class MockFlutterLocalNotificationsPlugin extends Mock
    with
        MockPlatformInterfaceMixin // ignore: prefer_mixin
    implements
        FlutterLocalNotificationsPlatform {}
