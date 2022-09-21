import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:happy_mucher_frontend/dailymeal_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => DashboardState();
}

class DashboardState extends State<DashboardPage> {
  final FirebaseFirestore firestore = GetIt.I.get();
  final uid = FirebaseAuth.instance.currentUser!.uid;

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

  String getTimeofDay() {
    int h = DateTime.now().hour;
    print(DateTime.now().hour);
    if (h >= 0 && h < 12) {
      return 'Breakfast';
    } else if (h >= 12 && h < 17) {
      return 'Lunch';
    } else {}
    return 'Supper';
  }

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
          if (estimatedVal.total <= 50) {
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
          title: Text('Happy Muncher'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        drawer: NavBar(),
        body: PageView(
          children: <Widget>[
            ListView(children: <Widget>[
              buildMealPlanner(context),
              buildInventoryCard(context),
              buildProgressIndicator(),
              buildBudgetcard(context),
            ]),
            //MyHomePage()
          ],
        ),
        floatingActionButton: FloatingActionButton(
            // isExtended: true,
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ));
            }));
  }

  Widget buildMealPlanner(BuildContext context) {
    return Container(
        width: 180,
        height: 360,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),

        //margin: EdgeInsets.fromLTRB(10, 10, 250, 0),
        key: const ValueKey("Meal Planner"),
        /* shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),*/
        child: Stack(alignment: Alignment.topCenter, children: [
          Container(
              /*child: Text(
                  'Meal Planner',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),*/
              ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MealPage()));
            },
          ),
          MealWidget(
              day: DateFormat('EEEE').format(DateTime.now()),
              meal: getTimeofDay()),
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
            elevation: 25,
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
                            vertical: false,
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
          .collection('GL totals')
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
        width: 400,
        height: 250,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          child: charts.PieChart<String>(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              new charts.DatumLegend(
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontFamily: 'Georgia',
                                    fontSize: 18),
                                position: charts.BehaviorPosition.start,
                              )
                            ],
                            /*defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition:
                                            charts.ArcLabelPosition.inside)
                                  ])*/
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }

  double total = 0;
  Widget buildProgressIndicator() {
    return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Card(
            key: const ValueKey("Meal Planner"),
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text('Grocery List',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroceryListPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    height: 100,
                    width: 400,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('GL totals')
                            .snapshots(),
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
                                  total = documentSnapshot['estimated total'] +
                                      documentSnapshot['shopping total'];

                                  if (index == 0) {
                                    //print(documentSnapshot['total']);
                                    return LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                210,
                                        animation: true,
                                        lineHeight: 22.0,
                                        animationDuration: 2000,
                                        leading: new Text("estimated \n total"),
                                        trailing: new Text("shopping\n total"),
                                        percent: documentSnapshot[
                                                'estimated total'] /
                                            total,
                                        // center: Text(percentageRemaining.toString() + "% remaining"),

                                        backgroundColor:
                                            Color.fromARGB(255, 252, 95, 13),
                                        progressColor:
                                            Color.fromARGB(255, 55, 190, 15));
                                  } else {
                                    total +=
                                        int.parse(documentSnapshot['total']);
                                    return Text("");
                                  }
                                });
                          }
                          return Text("No items expire today.",
                              textAlign: TextAlign.center);
                        },
                      ),
                    ),
                  ))
            ])));
  }

  Widget buildInventoryCard(BuildContext context) {
    return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Card(
            key: const ValueKey("Meal Planner"),
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text('Inventory',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IventoryPage()));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 45, 10, 0),
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
                                      subtitle: Text(
                                          documentSnapshot['quantity']
                                                  .toString() +
                                              ' \u{00D7} ' +
                                              documentSnapshot['itemName'],
                                          textAlign: TextAlign.center),
                                    );
                                  } else if (index ==
                                          streamSnapshot.data!.docs.length -
                                              1 &&
                                      exp == false) {
                                    return ListTile(
                                      subtitle: Text("No items expire today",
                                          textAlign: TextAlign.center),
                                    );
                                  } else {
                                    return Text("");
                                  }
                                });
                          }
                          return Text("No items expire today.",
                              textAlign: TextAlign.center);
                        },
                      ),
                    ),
                  ))
            ])));
  }
}
