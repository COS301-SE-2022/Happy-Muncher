import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
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
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 95, 13),
      ),
      drawer: NavBar(),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          buildGrocerycard(),
          const SizedBox(height: 10),
          buildInventorycard(),
          const SizedBox(height: 10),
          buildBudgetcard(),
          const SizedBox(height: 10),
          buildMealcard(),
          const SizedBox(height: 10),
          buildRecipecard(),
          //   SizedBox(
          //     width: 200,
          //     height: 50,
          //     child: RaisedButton(
          //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
          //       onPressed: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => RecipeBook()));
          //       },
          //       color: Colors.blue,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(30))),
          //       child: Text(
          //         "Other recipe card",
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget buildGrocerycard() => Card(
      key: const ValueKey("Grocery List"),
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            key: Key('gbutton'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroceryListPage()));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  "Grocery List",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));

  Widget buildInventorycard() => Card(
      key: const ValueKey("Inventory"),
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IventoryPage()));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  "Inventory",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
  Widget buildBudgetcard() => Card(
      key: const ValueKey("Budget"),
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyBudget()));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  "Budget Planner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
  Widget buildMealcard() => Card(
      key: const ValueKey("Meal Planner"),
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MealPage()));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  "Meal Planner",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
  Widget buildRecipecard() => Card(
      key: Key('toRecipeBook'),
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecipeBook()));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  "Recipe Book",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
}
