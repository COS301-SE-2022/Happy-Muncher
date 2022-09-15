import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  const MyHomePage({Key? key}) : super(key: key);
  //static List<GroceryListItem> inventoryList = [];
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
    TastyBook(),
  ];
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _products =>
      firestore.collection('Users').doc(uid).collection('Inventory');
  CollectionReference get _lunch => firestore
      .collection('Users')
      .doc(uid)
      .collection('Meal Planner')
      .doc(DateFormat('EEEE').format(DateTime.now()))
      .collection('Lunch');

  CollectionReference get _breakfast => firestore
      .collection('Users')
      .doc(uid)
      .collection('Meal Planner')
      .doc(DateFormat('EEEE').format(DateTime.now()))
      .collection('Breakfast');

  CollectionReference get _supper => firestore
      .collection('Users')
      .doc(uid)
      .collection('Meal Planner')
      .doc(DateFormat('EEEE').format(DateTime.now()))
      .collection('Supper');

  List<charts.Series<Values, String>> _seriesBarData = [];
  List<Values> mydata = [];
  _generateData(mydata) {
    _seriesBarData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Values budgetVal, _) => budgetVal.month,
        measureFn: (Values budgetVal, _) => (budgetVal.budget),
        colorFn: (Values budgetVal, _) {
          if (budgetVal.budget > 5000) {
            first = false;
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 252, 95, 13));
          } else {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 55, 190, 15));
          }
          ;
        },
        id: 'Dashboard',
        data: mydata,
        labelAccessorFn: (Values row, _) => "${row.budget}",
      ),
    );
  }

  List<charts.Series<GLValues, String>> _seriesPieData = [];
  List<GLValues> mypiedata = [];
  bool first = true;

  _generatePieData(mypiedata) {
    _seriesPieData = [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (GLValues estimatedVal, _) => estimatedVal.type,
        measureFn: (GLValues totalVal, _) => (totalVal.total),
        colorFn: (GLValues estimatedVal, _) {
          if (estimatedVal.total < 50) {
            first = false;
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 55, 190, 15));
          } else {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 252, 95, 13));
          }
          ;
        },
        id: 'Dashboard',
        data: mypiedata,
        labelAccessorFn: (GLValues row, _) => "${row.type}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HAPPY MUNCHER'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        drawer: NavBar(),
        body: PageView(
          children: <Widget>[
            ListView(children: <Widget>[
              Row(children: <Widget>[
                buildMealPlanner(context),
                buildGLcard(context),
              ]),
              buildInventoryCard(context),
              buildBudgetcard(context),
            ]),
            screens[index],
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.orange.shade100,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )),
          child: NavigationBar(
              height: 60,
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

  Widget buildMealPlanner(BuildContext context) {
    return Container(
        width: 250,
        height: 300,
        margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
        child: Card(
            //margin: EdgeInsets.fromLTRB(10, 10, 250, 0),
            key: const ValueKey("Meal Planner"),
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(
                  'Meal Planner',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MealPage()));
                },
                child: Container(
                  height: 300,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        StreamBuilder(
                          stream: _breakfast.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                key: const Key('Inventory_ListView'),
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];

                                  DateTime dateToday = new DateTime.now();
                                  String date =
                                      dateToday.toString().substring(0, 10);
                                  if (index == 0) {
                                    return ListTile(
                                      title: Text("Breakfast: " +
                                          documentSnapshot['Name'].toString() +
                                          "\n"),
                                      minVerticalPadding: 60,
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text(""),
                                    );
                                  }
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        SizedBox(
                          height: 500,
                        ),
                        StreamBuilder(
                          stream: _lunch.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                key: const Key('Inventory_ListView'),
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];

                                  DateTime dateToday = new DateTime.now();
                                  String date =
                                      dateToday.toString().substring(0, 10);
                                  if (index == 0) {
                                    return ListTile(
                                      title: Text("Lunch: " +
                                          documentSnapshot['Name'].toString() +
                                          "\n"),
                                      minVerticalPadding: 130,
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text(""),
                                    );
                                  }
                                },
                              );
                            }
                            return Text("No Meals were added for today.");
                          },
                        ),
                        StreamBuilder(
                          stream: _supper.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                key: const Key('Inventory_ListView'),
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];

                                  DateTime dateToday = new DateTime.now();
                                  String date =
                                      dateToday.toString().substring(0, 10);
                                  if (index == 0) {
                                    return ListTile(
                                      title: Text("Supper: " +
                                          documentSnapshot['Name'].toString() +
                                          "\n"),
                                      minVerticalPadding: 200,
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text(""),
                                    );
                                  }
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }

  Widget buildBudgetcard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Budget')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<Values> sales = snapshot.data!.docs
              .map((content) => Values.fromMap(content))
              .toList();
          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Values> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Container(
        width: 250,
        height: 300,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Card(
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 50,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.center, children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyBudget()));
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  //width: 50,
                  height: 300,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Monthly budget',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesBarData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            /*behaviors: [
                          new charts.DatumLegend(
                            entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 18),
                          )
                        ],*/
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }

  Widget buildGLcard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('GL Totals')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<GLValues> sales = snapshot.data!.docs
              .map((content) => GLValues.fromMap(content))
              .toList();
          return _buildPieChart(context, sales);
        }
      },
    );
  }

  Widget _buildPieChart(BuildContext context, List<GLValues> saledata) {
    mypiedata = saledata;
    _generatePieData(mypiedata);

    return Container(
        width: 280,
        height: 300,
        margin: EdgeInsets.fromLTRB(10, 20, 20, 0),
        child: Card(
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.center, children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroceryListPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  //width: 50,
                  height: 300,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Grocery List',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.PieChart<String>(_seriesPieData,
                              animate: true,
                              animationDuration: Duration(seconds: 1),
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.inside)
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }

  Widget buildInventoryCard(BuildContext context) {
    return Container(
        width: 400,
        height: 200,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Card(
            key: const ValueKey("Meal Planner"),
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(
                  'Inventory',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IventoryPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: StreamBuilder(
                        stream: _products.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            bool exp = false;
                            return ListView.builder(
                                key: const Key('Inventory_ListView'),
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];

                                  DateTime dateToday = new DateTime.now();
                                  String date =
                                      dateToday.toString().substring(0, 10);

                                  if (documentSnapshot['expirationDate'] ==
                                      date) {
                                    exp = true;
                                    return ListTile(
                                      title: Text(documentSnapshot['quantity']
                                              .toString() +
                                          ' \u{00D7} ' +
                                          documentSnapshot['itemName'] +
                                          ' ' +
                                          'expires today!'),
                                    );
                                  } else if (index ==
                                          streamSnapshot.data!.docs.length -
                                              1 &&
                                      exp == false) {
                                    return ListTile(
                                      title: Text("No items expire today"),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                });
                          }
                          return Text("No items expire today.");
                        },
                      ),
                    ),
                  ))
            ])));
  }
}
