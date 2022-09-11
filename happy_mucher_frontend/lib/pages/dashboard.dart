import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  //static List<GroceryListItem> inventoryList = [];
  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
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
        colorFn: (Values budgetVal, _) =>
            charts.ColorUtil.fromDartColor(Colors.orange),
        id: 'Dashboard',
        data: mydata,
        labelAccessorFn: (Values row, _) => "${row.budget}",
      ),
    );
  }

  List<charts.Series<GLValues, String>> _seriesPieData = [];
  List<GLValues> mypiedata = [];
  _generatePieData(mypiedata) {
    bool first = true;
    _seriesPieData = [];
    _seriesPieData.add(
      charts.Series(
        domainFn: (GLValues estimatedVal, _) => estimatedVal.type,
        measureFn: (GLValues totalVal, _) => (totalVal.shoppingTotal),
        colorFn: (GLValues estimatedVal, _) {
          
          if (first == true) {
            first = false;
            return charts.ColorUtil.fromDartColor(Color.fromARGB(255, 14, 157, 200));
            
          } else {
            return charts.ColorUtil.fromDartColor(Color.fromARGB(255, 222, 236, 27));
          }
          ;
        },
        id: 'Dashboard',
        data: mypiedata,
        labelAccessorFn: (GLValues row, _) => "${row.shoppingTotal}",
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
      //drawer: NavBar(),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          buildMealPlanner(context),
          const SizedBox(height: 10),
          buildGLcard(context),
          const SizedBox(height: 10),
          buildBudgetcard(context),
          const SizedBox(height: 10),
          buildInventoryCard(context),
          const SizedBox(height: 10),
          // buildRecipecard(),
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

  /*Future<List> getMeals() async {
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Meal Planner')
        .doc('Monday');
    List meals = [];
    String str = "";
    for (int i = 0; i < 3; i++) {
      if (i == 0) {
        str = "Breakfast";
      }
      if (i == 1) {
        str = "Lunch";
      }
      if (i == 2) {
        str = "Supper";
      }
      var docSnapshot = await collection.collection(str).get();
      if (docSnapshot!=null) {
        Map<String, dynamic> data = docSnapshot.;
        String title = data['Name'];
        meals.add("title");
      } else {
        meals.add("None");
      }

      //print(tr);
    }
    return meals;
  }*/

  Widget buildMealPlanner(BuildContext context) {
    return Card(
        key: const ValueKey("Meal Planner"),
        shadowColor: Color.fromARGB(255, 172, 255, 78),
        elevation: 25,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(alignment: Alignment.center, children: [
          Text(
            'Meal Planner',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MealPage()));
            },
            child: Container(
              height: 160,
              width: 400,
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
                                  minVerticalPadding: 20,
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
                                  minVerticalPadding: 40,
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
                  ],
                ),
              ),
            ),
          )
        ]));
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
          return LinearProgressIndicator();
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

    return Card(
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
        ]));
  }

  Widget buildGLcard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('GL totals').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
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

    return Card(
        shadowColor: Color.fromARGB(255, 172, 255, 78),
        elevation: 25,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(alignment: Alignment.center, children: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroceryListPage()));
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
                          behaviors: [
                            new charts.DatumLegend(
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
                                  fontFamily: 'Georgia',
                                  fontSize: 18),
                            )
                          ],
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
        ]));
  }

  Widget buildInventoryCard(BuildContext context) {
    return Card(
        key: const ValueKey("Meal Planner"),
        shadowColor: Color.fromARGB(255, 172, 255, 78),
        elevation: 25,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(alignment: Alignment.center, children: [
          Text(
            'Inventory',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          InkWell(
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IventoryPage()));
              },
              child: Container(
                height: 160,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: StreamBuilder(
                    stream: _products.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                          key: const Key('Inventory_ListView'),
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            DateTime dateToday = new DateTime.now();
                            String date = dateToday.toString().substring(0, 10);

                            if (documentSnapshot['expirationDate'] == date) {
                              return ListTile(
                                title: Text(
                                    documentSnapshot['quantity'].toString() +
                                        ' \u{00D7} ' +
                                        documentSnapshot['itemName'] +
                                        ' ' +
                                        'expires today!'),
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
                ),
              ))
        ]));
  }
}
