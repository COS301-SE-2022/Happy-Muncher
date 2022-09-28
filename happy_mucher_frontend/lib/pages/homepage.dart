import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final int index;
  static const routeName = '/home';
  const MyHomePage({Key? key, required this.index}) : super(key: key);
  @override
  State<MyHomePage> createState() => HomePageState();
}

class HomePageState extends State<MyHomePage> {
  int index = 0;

  final screens = [
    GroceryListPage(),
    IventoryPage(),
    MyBudget(),
    MealPage(),
    RecipeBook(),
  ];
  int getIndex() {
    return widget.index;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //drawer: NavBar(),
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: const Color.fromARGB(100, 150, 66, 154),
              labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              )),
          child: NavigationBar(
              height: 60,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              selectedIndex: index,
              animationDuration: const Duration(seconds: 3),
              onDestinationSelected: (index) =>
                  setState(() => this.index = index),
              destinations: const [
                NavigationDestination(
                  key: Key('Grocery List'),
                  icon: Icon(Icons.local_grocery_store_outlined),
                  selectedIcon: Icon(Icons.local_grocery_store),
                  label: 'Grocery List',
                ),
                NavigationDestination(
                  key: Key('Inventory'),
                  icon: Icon(Icons.receipt_outlined),
                  selectedIcon: Icon(Icons.receipt),
                  label: 'Inventory',
                ),
                NavigationDestination(
                  key: Key('Budget'),
                  icon: Icon(Icons.monetization_on_outlined),
                  selectedIcon: Icon(Icons.monetization_on),
                  label: 'Budget',
                ),
                NavigationDestination(
                  key: Key('Meal Planner'),
                  icon: Icon(Icons.edit_calendar_outlined),
                  selectedIcon: Icon(Icons.edit_calendar),
                  label: 'Meal Planner',
                ),
                NavigationDestination(
                  key: Key('Recipe book'),
                  icon: Icon(Icons.book_outlined),
                  selectedIcon: Icon(Icons.book),
                  label: 'Recipe book',
                ),
              ]),
        ));
  }
}
