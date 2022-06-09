import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/loginpage.dart';
import 'pages/signuppage.dart';
import 'models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:happy_mucher_frontend/provider/google_sign_in.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
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
      child: MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          SignupScreen.routeName: (ctx) => SignupScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MyHomePage.routeName: (ctx) => MyHomePage()
        },
      ),
    );
  }
}
