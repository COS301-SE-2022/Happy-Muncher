import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  group('Added testing for grocery list', () {
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
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
    );
    final auth = MockFirebaseAuth(
      mockUser: user,
      signedIn: true,
    );
    GetIt.I.registerSingleton<FirebaseAuth>(auth);
    const testApp = MaterialApp(
      home: Scaffold(
        body: GroceryListPage(),
      ),
    );

    setUp(() async {
      final query = await firestore
          .collection('Users')
          .doc('abc')
          .collection('GroceryList')
          .get();
      await firestore
          .collection('Users')
          .doc('abc')
          .collection('GL totals')
          .doc('Totals')
          .get();
      final futures = query.docs.map((e) {
        return firestore
            .collection('Users')
            .doc('abc')
            .collection('GroceryList')
            .doc(e.id)
            .delete();
      });
      return await Future.wait(futures);
    });
    testWidgets(
      'Testing if page is empty on start up',
      (WidgetTester tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(testApp);

          final inventoryList = find.byKey(const Key('Grocery_ListView'));
          expect(inventoryList, findsNothing);
        });
        //test to see if the list is empty on initial start up
        //runs the app and checks the list to see if it has 0 list tile widgets
        //success if finds 0 widgets
      },
    );

    testWidgets(
      'Testing page filling from database',
      (WidgetTester tester) async {
        await tester.runAsync(
          () async {
            await firestore
                .collection('Users')
                .doc('abc')
                .collection('GroceryList')
                .add({"name": 'juice', "price": 1, "bought": false});
            await firestore
                .collection('Users')
                .doc('abc')
                .collection('GroceryList')
                .add({"name": 'apples', "price": 2, "bought": false});
            await firestore
                .collection('Users')
                .doc('abc')
                .collection('GroceryList')
                .add({"name": 'bread', "price": 3, "bought": false});

            await firestore
                .collection('Users')
                .doc('abc')
                .collection('GL totals')
                .doc('Totals')
                .set({'estimated total': 0, 'shopping total': 6});

            await tester.pumpWidget(testApp);

            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            final listviews = find.byType(CheckboxListTile);

            expect(listviews, findsNWidgets(3));
          },
        );
      },
    );
  });
}

class MockFlutterLocalNotificationsPlugin extends Mock
    with
        MockPlatformInterfaceMixin // ignore: prefer_mixin
    implements
        FlutterLocalNotificationsPlatform {}
