import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
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
        'Testing if text boxes are empty on start up',
        (WidgetTester tester) async {
          //test to see if the list is empty on initial start up
          //runs the app and checks the list to see if it has 0 list tile widgets
          //success if finds 0 widgets
          await tester.pumpWidget(testApp);
        },
      );
    },
  );
}
