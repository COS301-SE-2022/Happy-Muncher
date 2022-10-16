import 'dart:io';

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
import 'package:happy_mucher_frontend/pages/recipebook.dart';
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
          'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png',
    );
    final auth = MockFirebaseAuth(
      mockUser: user,
      signedIn: true,
    );
    GetIt.I.registerSingleton<FirebaseAuth>(auth);
    final testApp = MaterialApp(
      home: Scaffold(
        body: RecipeBook(),
      ),
    );
    setUpAll(() => HttpOverrides.global = null);

    setUp(() async {
      final query = await firestore
          .collection('Users')
          .doc('abc')
          .collection('Recipes')
          .get();
      final futures = query.docs.map((e) {
        return firestore
            .collection('Users')
            .doc('abc')
            .collection('Recipes')
            .doc(e.id)
            .delete();
      });
      return await Future.wait(futures);
    });
    testWidgets(
      'Testing page has buttons',
      (WidgetTester tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final button = find.byType(ElevatedButton);
          expect(button, findsNWidgets(3));
        });
      },
    );
  });
}

class MockFlutterLocalNotificationsPlugin extends Mock
    with
        MockPlatformInterfaceMixin // ignore: prefer_mixin
    implements
        FlutterLocalNotificationsPlatform {}
