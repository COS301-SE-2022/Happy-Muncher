import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HAPPY MUNCHER'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[Text('Logout'), Icon(Icons.logout)],
            ),
            textColor: Colors.white,
            onPressed: () async => {
              await FirebaseAuth.instance.signOut(),
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName)
            },
          ),
        ],
      ),
      drawer: NavBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroceryListPage()));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "View Grocery List",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IventoryPage()));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "View Inventory",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Budget()));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "Create Your Budget",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MealPage()));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "Plan a meal",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TastyBook()));
                },
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  "Recipe Book",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // SizedBox(
            //   width: 200,
            //   height: 50,
            //   child: RaisedButton(
            //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            //     onPressed: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => RecipeBook()));
            //     },
            //     color: Colors.blue,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(30))),
            //     child: Text(
            //       "Other recipe card",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
