import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';

void main() {
  group(
    'Added testing for list',
    () {
      final firestore = FakeFirebaseFirestore();
      GetIt.I.registerSingleton<FirebaseFirestore>(firestore);
      const testApp = MaterialApp(
        home: Scaffold(
          body: IventoryPage(),
        ),
      );

      setUp(() async {
        final query = await firestore.collection('Inventory').get();
        final futures = query.docs.map((e) {
          return firestore.collection('Inventory').doc(e.id).delete();
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

          final inventoryList = find.byKey(const Key('Inventory_ListView'));
          expect(inventoryList, findsNothing);
        },
      );

      testWidgets(
        'Testing page filling from database',
        (WidgetTester tester) async {
          await firestore.collection('Inventory').add({
            "itemName": 'juice',
            "quantity": 1,
            "expirationDate": DateTime.now().toString(),
          });
          await firestore.collection('Inventory').add({
            "itemName": 'apple',
            "quantity": 2,
            "expirationDate": DateTime.now().toString(),
          });
          await firestore.collection('Inventory').add({
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
    },
  );
}
