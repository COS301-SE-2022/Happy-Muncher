import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as mPrefix;
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/settings_page.dart';
import 'package:provider/provider.dart';

import 'pages/loginpage.dart';
import 'pages/signuppage.dart';
import 'pages/profile.dart';

import 'models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
//import 'package:dcdg/dcdg.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:happy_mucher_frontend/provider/google_sign_in.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mPrefix.Settings.init(cacheProvider: mPrefix.SharePreferenceCache());
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  GetIt.I.registerSingleton(firestore);
  GetIt.I.registerSingleton(firebaseAuth);

  runApp(MyApp());
  //runApp(MyMain());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        )
      ],
      child: MyMain(),
      /*child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: SettingsPage(),*/
      /*routes: {
          SignupScreen.routeName: (ctx) => SignupScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MyHomePage.routeName: (ctx) => MyHomePage(),
          Profile.routeName: (ctx) => Profile(),
        },
      ),*/
    );
  }

  /*Widget theme(BuildContext context) {
    return mPrefix.ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        //title: MyMain.title,
        theme: isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.teal,
                scaffoldBackgroundColor: Color(0xFF170635),
                canvasColor: Color(0xFF170635),
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
              )
            : ThemeData.light().copyWith(
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
        //home: LoginScreen(),
      ),
    );
  }*/
}

class MyMain extends StatefulWidget {
  static final String title = 'Settings';
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyMain> {
  @override
  Widget build(BuildContext context) {
    return mPrefix.ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyMain.title,
        theme: isDarkMode
            ? ThemeData.dark().copyWith(
                primaryColor: Colors.teal,
                scaffoldBackgroundColor: Color(0xFF170635),
                canvasColor: Color(0xFF170635),
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
              )
            : ThemeData.light().copyWith(
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.black)),
        home: LoginScreen(),
        routes: {
          SignupScreen.routeName: (ctx) => SignupScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MyHomePage.routeName: (ctx) => MyHomePage(),
          Profile.routeName: (ctx) => Profile(),
          // SettingsPage.routeName: (ctx) => SettingsPage(),
        },
      ),
    );
  }
}
