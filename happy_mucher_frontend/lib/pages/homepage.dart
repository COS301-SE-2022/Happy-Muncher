import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  final screens = [
<<<<<<< HEAD
    DashboardPage(),
=======
>>>>>>> b8947abfed2d7f2b7e4a644b694556e33e1a9bc7
    GroceryListPage(),
    IventoryPage(),
    MyBudget(),
    MealPage(),
    TastyBook(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HAPPY MUNCHER'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        drawer: NavBar(),
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.orange.shade100,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )),
          child: NavigationBar(
<<<<<<< HEAD
              height: 40,
=======
              height: 60,
>>>>>>> b8947abfed2d7f2b7e4a644b694556e33e1a9bc7
              selectedIndex: index,
              animationDuration: Duration(seconds: 3),
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.local_grocery_store_outlined),
                  selectedIcon: Icon(Icons.local_grocery_store),
                  label: 'Grocery List',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_outlined),
                  selectedIcon: Icon(Icons.receipt),
                  label: 'Inventory',
                ),
                NavigationDestination(
                  icon: Icon(Icons.monetization_on_outlined),
                  selectedIcon: Icon(Icons.monetization_on),
                  label: 'Budget',
                ),
                NavigationDestination(
                  icon: Icon(Icons.edit_calendar_outlined),
                  selectedIcon: Icon(Icons.edit_calendar),
                  label: 'Meal-Plan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: 'Recipe book',
                ),
              ]),
        ));
  }
}
