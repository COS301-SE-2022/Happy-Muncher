import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'pages/loginpage.dart';
import 'pages/signuppage.dart';
import 'models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
//import 'package:dcdg/dcdg.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:happy_mucher_frontend/provider/google_sign_in.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;


  GetIt.I.registerSingleton(firestore);
  GetIt.I.registerSingleton(firebaseAuth);

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
