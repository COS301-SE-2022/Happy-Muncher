import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:mockito/mockito.dart';
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
          body: DashboardPage(),
        ),
      );

      setUpAll(() => HttpOverrides.global = null);

      setUp(() async {});

      testWidgets(
        'Testing if page is empty on start up',
        (WidgetTester tester) async {
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final listviews = find.text("Inventory");

          expect(listviews, findsWidgets);
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
