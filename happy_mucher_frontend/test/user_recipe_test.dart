import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/createRecipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group(
    'Added testing for list',
    () {
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

      final testApp = MaterialApp(
        home: Scaffold(
          body: Create(
              calories: 0,
              cookTime: '0',
              description: '',
              title: '',
              ingredients: [],
              steps: []),
        ),
      );

      setUp(() async {
        final query = await firestore
            .collection('Users')
            .doc('abc')
            .collection('CustomRecipe')
            .get();
        final futures = query.docs.map((e) {
          return firestore
              .collection('Users')
              .doc('abc')
              .collection('CustomRecipe')
              .doc(e.id)
              .delete();
        });
        return await Future.wait(futures);
      });

      testWidgets(
        'Testing if text fields on starts up correctly',
        (WidgetTester tester) async {
          //test if page starts properly
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final textboxes = find.byType(TextField);
          expect(textboxes, findsNWidgets(4));
        },
      );

      testWidgets(
        'Testing if first buttons on starts up correctly',
        (WidgetTester tester) async {
          //test if page starts properly
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final lastTextField = find.byKey(const Key('entercalories'));

          expect(lastTextField, findsOneWidget);

          await tester.drag(lastTextField, const Offset(0.0, -300));

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final speeddials =
              find.byKey(const Key('speed_dial_button_ingredients'));

          expect(speeddials, findsOneWidget);
        },
      );

      testWidgets(
        'Testing if second buttons on starts up correctly',
        (WidgetTester tester) async {
          //test if page starts properly
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final lastTextField = find.byKey(const Key('entercalories'));

          expect(lastTextField, findsOneWidget);

          await tester.drag(lastTextField, const Offset(0.0, -300));

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final speeddials = find.byKey(const Key('speed_dial_button_steps'));

          expect(speeddials, findsOneWidget);
        },
      );
    },
  );
}
