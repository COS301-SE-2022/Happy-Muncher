import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart'
    as mPrefix;
import 'package:happy_mucher_frontend/pages/settings_page.dart';

import 'pages/loginpage.dart';
import 'pages/signuppage.dart';
import 'models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
//import 'package:dcdg/dcdg.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:happy_mucher_frontend/provider/google_sign_in.dart';

import 'package:happy_mucher_frontend/provider/dark_theme_provider.dart';
import 'package:happy_mucher_frontend/models/styles.dart';

Future main() async {
  await mPrefix.Settings.init(cacheProvider: mPrefix.SharePreferenceCache());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  GetIt.I.registerSingleton(firestore);
  GetIt.I.registerSingleton(firebaseAuth);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final isDarkMode = mPrefix.Settings.getValue<bool>(SettingsPage.keyDarkMode,
      defaultValue: false);

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.devFestPreferences.getTheme();
  }

  void checkDarkMode() {
    print(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
// Define a widget
    Widget firstWidget;

// Assign widget based on availability of currentUser
    if (firebaseUser != null) {
      firstWidget = MyHomePage();
    } else {
      firstWidget = LoginScreen();
    }
    checkDarkMode();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        )
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (_, value, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: firstWidget,
          routes: {
            SignupScreen.routeName: (ctx) => SignupScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            MyHomePage.routeName: (ctx) => MyHomePage()
          },
        ),
      ),
      /*child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(primaryColor: Colors.blue),
        home: LoginScreen(),
        routes: {
          SignupScreen.routeName: (ctx) => SignupScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MyHomePage.routeName: (ctx) => MyHomePage()
        },
      ),*/

      /*child: mPrefix.ValueChangeObserver<bool>(
          cacheKey: SettingsPage.keyDarkMode,
          defaultValue: false,
          builder: (_, isDarkMode, __) => MaterialApp(
                debugShowCheckedModeBanner: true,
                title: 'Happy Muncher',
                theme: isDarkMode
                    ? ThemeData.dark().copyWith(
                        primaryColor: Colors.teal,
                        scaffoldBackgroundColor: Colors.black12,
                        canvasColor: Colors.black12,
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.white),
                      )
                    : ThemeData.light().copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: Colors.black)),
                home: LoginScreen(),
                routes: {
                  SignupScreen.routeName: (ctx) => SignupScreen(),
                  LoginScreen.routeName: (ctx) => LoginScreen(),
                  MyHomePage.routeName: (ctx) => MyHomePage()
                },
              )),*/
    );
  }
}
