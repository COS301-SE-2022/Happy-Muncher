import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/changeprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/month.dart';
import 'package:happy_mucher_frontend/pages/weekday.dart';
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
          body: Weekday(day: "Monday"),
        ),
      );

      setUpAll(() => HttpOverrides.global = null);

      setUp(() async {
        final query = await firestore
            .collection('Users')
            .doc('abc')
            .collection('Meal Planner')
            .doc('Place Holder')
            .get();
      });

      testWidgets(
        'Testing page buttons',
        (WidgetTester tester) async {
          await firestore
              .collection('Users')
              .doc('abc')
              .collection('Meal Planner')
              .doc('Place Holder')
              .set({
            "Calories": 0,
            "CookTime": "1",
            "Description": "q",
            "Image":
                "https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png",
            "Ingredients": "q",
            "Instructions": "q",
            "Name": "test"
          });
          await tester.pumpWidget(testApp);

          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final listviews = find.byType(CarouselSlider);

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
