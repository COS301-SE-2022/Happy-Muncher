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

  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  User? get user => firebaseAuth.currentUser;

  CollectionReference get _products =>
      firestore.collection('Users').doc(uid).collection('Inventory');

  CollectionReference get _gltotals =>
      firestore.collection('Users').doc(uid).collection('GL totals');

  CollectionReference get _budget =>
      firestore.collection('Users').doc(uid).collection('Budget');

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

  bool first = true;

  @override
  Widget build(BuildContext context) {
    var profile = user?.photoURL;
    if (profile == null) {
      profile ??=
          'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png';
    }
    return Scaffold(
      appBar: AppBar(
          title: new Text(
            "Dashboard",
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(index: 0)));
                  },
                  child: Icon(
                    Icons.arrow_forward_outlined,
                    size: 30.0,
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
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            index: 3,
                          )));
            },
            child: MealWidget(
                day: DateFormat('EEEE').format(DateTime.now()),
                meal: getTimeofDay()),
          ),
        ]));
  }

  dynamic total = 0;
  Widget buildProgressIndicator() {
    return Container(
        width: 150,
        height: 150,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Card(
            key: const ValueKey("Meal Planner Dashboard"),
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
                            builder: (context) => MyHomePage(
                                  index: 0,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    height: 100,
                    width: 400,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: StreamBuilder(
                        stream: _gltotals.snapshots(),
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
                                  double percentage =
                                      documentSnapshot['estimated total'] /
                                          total;
                                  if (percentage < 0 || percentage > 1) {
                                    percentage = 0;
                                  }
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
                                      percent: percentage,
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
            key: const ValueKey("Inventory Dashboard"),
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
                            builder: (context) => MyHomePage(
                                  index: 1,
                                )));
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

  Widget buildPercentagendicator() {
    return Container(
        width: 400,
        height: 150,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 60),
        child: Card(
            key: const ValueKey("Carousel 1"),
            shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Stack(alignment: Alignment.topCenter, children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(DateFormat('MMMM').format(DateTime.now()),
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                index: 2,
                              )));
                },
                /*margin: EdgeInsets.fromLTRB(20, 50, 10, 0),
                    height: 100,
                    width: 400,*/
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 130, 0, 50),
                  child: StreamBuilder(
                    stream: _budget.snapshots(),
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
                              double percentageSpent =
                                  documentSnapshot['total spent'] /
                                      documentSnapshot['budget'];
                              double percentageRem =
                                  documentSnapshot['total remaining'] /
                                      documentSnapshot['budget'] *
                                      100;
                              if (percentageSpent < 0 || percentageSpent > 1) {
                                percentageSpent = 0;
                              }
                              if (percentageRem > 0 || percentageRem < 1) {
                                percentageRem = 0;
                              }

                              if (documentSnapshot.id ==
                                  DateFormat('MMMM').format(DateTime.now())) {
                                return LinearPercentIndicator(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  animation: true,
                                  lineHeight: 25.0,
                                  animationDuration: 2000,
                                  barRadius: const Radius.circular(16),
                                  percent: percentageSpent,
                                  center: Text(
                                      percentageRem.toString() + "% remaining"),
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

  Widget buildBudgetcard(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _budget.snapshots(),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                index: 2,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  //width: 50,
                  height: 500,
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text('Shopping Sprees',
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
}
