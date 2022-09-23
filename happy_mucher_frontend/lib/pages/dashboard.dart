import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/navbar.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:happy_mucher_frontend/dailymeal_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        measureFn: (Values budgetVal, _) => (budgetVal.totalSpent),
        colorFn: (Values budgetVal, _) {
          if (budgetVal.totalSpent / budgetVal.budget < 0.25) {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 72, 216, 29));
          } else if (budgetVal.totalSpent / budgetVal.budget >= 0.25 &&
              budgetVal.totalSpent / budgetVal.budget < 0.5) {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 239, 255, 12));
          } else if (budgetVal.totalSpent / budgetVal.budget >= 0.5 &&
              budgetVal.totalSpent / budgetVal.budget < 0.75) {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 248, 141, 10));
          } else {
            return charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 236, 17, 2));
          }
          ;
        },
        id: 'Dashboard',
        data: mydata,
        labelAccessorFn: (Values row, _) => "${row.month}",
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

  Widget buildPercentagendicator() {
    return Container(
        width: 400,
        height: 150,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
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
                child: Text(
                    'Shopping Sprees for ' +
                        DateFormat('MMMM').format(DateTime.now()),
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyBudget()));
                },
                /*margin: EdgeInsets.fromLTRB(20, 50, 10, 0),
                    height: 100,
                    width: 400,*/
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 130, 0, 50),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uid)
                        .collection('Budget')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.hasData) {
                        bool exp = false;
                        return ListView.builder(
                            key: const Key('Inventory_ListView'),
                            itemCount: streamSnapshot.data?.size,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];

                              if (documentSnapshot.id ==
                                  DateFormat('MMMM').format(DateTime.now())) {
                                return LinearPercentIndicator(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  animation: true,
                                  lineHeight: 25.0,
                                  animationDuration: 2000,
                                  barRadius: const Radius.circular(16),
                                  percent: documentSnapshot['total spent'] /
                                      documentSnapshot['budget'],
                                  center: Text(
                                      (documentSnapshot['total remaining'] /
                                                  documentSnapshot['budget'] *
                                                  100)
                                              .toString() +
                                          "% remaining"),
                                  progressColor: documentSnapshot[
                                                  'total remaining'] /
                                              documentSnapshot['budget'] >=
                                          0.75
                                      ? Color.fromARGB(255, 52, 108, 35)
                                      : documentSnapshot['total remaining'] /
                                                      documentSnapshot[
                                                          'budget'] <
                                                  0.75 &&
                                              documentSnapshot['total remaining'] /
                                                      documentSnapshot[
                                                          'budget'] >=
                                                  0.50
                                          ? Color.fromARGB(255, 239, 255, 12)
                                          : documentSnapshot['total remaining'] /
                                                          documentSnapshot[
                                                              'budget'] <
                                                      0.5 &&
                                                  documentSnapshot['total remaining'] /
                                                          documentSnapshot[
                                                              'budget'] >=
                                                      0.25
                                              ? Color.fromARGB(255, 238, 150, 19)
                                              : Color.fromARGB(255, 250, 27, 11),
                                );
                              } else {
                                return SizedBox(
                                  height: 0,
                                );
                              }
                            });
                      }
                      return Text("No items expire today.",
                          textAlign: TextAlign.center);
                    },
                  ),
                ),
              )
            ])));
  }

  @override
  Widget build(BuildContext context) {
    var profile = FirebaseAuth.instance.currentUser?.photoURL;
    if (profile == null) {
      profile ??=
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
    }
    return Scaffold(
      appBar: AppBar(
          title: new Text(
            "Dashboard",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xFF965BC8),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(profile) as ImageProvider,
                    radius: 50,
                    child: InkWell(onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    })),
              )),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Icon(
                    Icons.arrow_forward_outlined,
                    size: 30.0,
                    color: Colors.black,
                  ),
                ))
          ]),
      body: PageView(
        children: <Widget>[
          ListView(children: <Widget>[
            buildMealPlanner(context),
            buildInventoryCard(context),
            buildProgressIndicator(),
            CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: <Widget>[
                  buildPercentagendicator(),
                  buildBudgetcard(context),
                ])
          ]),
          //MyHomePage()
        ],
      ),
    );
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
            child: MealWidget(
                day: DateFormat('EEEE').format(DateTime.now()),
                meal: getTimeofDay()),
          ),
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
        width: 400,
        height: 300,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  height: 500,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('Total spent each month',
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                            'The colour of each bar varies accroding to the percentage spent of your total budget',
                            style: TextStyle(
                                fontSize: 10.0, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesBarData,
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            vertical: false,
                            defaultRenderer: new charts.BarRendererConfig(
                                cornerStrategy:
                                    const charts.ConstCornerStrategy(30)),
                            /*behaviors: [
                              new charts.DatumLegend(
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts
                                        .MaterialPalette.purple.shadeDefault,
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

  dynamic total = 0;
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
                                      width: MediaQuery.of(context).size.width -
                                          210,
                                      animation: true,
                                      lineHeight: 22.0,
                                      barRadius: const Radius.circular(16),
                                      animationDuration: 2000,
                                      leading: new Text("estimated \n total"),
                                      trailing: new Text("shopping\n total"),
                                      percent:
                                          documentSnapshot['estimated total'] /
                                              total,
                                      // center: Text(percentageRemaining.toString() + "% remaining"),

                                      progressColor:
                                          Color.fromARGB(255, 167, 104, 223),
                                    );
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
                                    return SizedBox(height: 0);
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
