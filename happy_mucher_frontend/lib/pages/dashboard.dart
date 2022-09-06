import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:happy_mucher_frontend/pages/values.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  //static List<GroceryListItem> inventoryList = [];
  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
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

  String mealsForDay = " ";
  void getMeals() async {
    //mealsForDay = "";
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Meal Planner');

    collection
        .doc('Monday')
        .collection("Breakfast")
        .doc('Recipe')
        .get()
        .then((value) {
      if (value.exists) {
        Meal("Breakfast: " + value.data()?["Name"]);
      } else {
        Meal("Breakfast: No meal added");
      }
    });

    collection
        .doc('Monday')
        .collection("Lunch")
        .doc('Recipe')
        .get()
        .then((value) {
      if (value.exists) {
        Meal("Lunch: " + value.data()?["Name"]);
      } else {
        Meal("Lunch: No meal added");
      }
    });

    collection
        .doc('Monday')
        .collection("Supper")
        .doc('Recipe')
        .get()
        .then((value) {
      if (value.exists) {
        Meal("Supper: " + value.data()?["Name"]);
      } else {
        Meal("Supper: No meal added");
      }
    });
  }

  void Meal(String s) {
    mealsForDay += s + " \n";
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
          buildGL(),
          const SizedBox(height: 10),
          // buildInventorycard(),
          const SizedBox(height: 10),
          buildBudgetcard(context),
          const SizedBox(height: 10),
          //buildMealcard(),
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

  Widget buildGL() {
    getMeals();
    String meals = mealsForDay;
    mealsForDay = "";
    print(meals);
    return Card(
        key: const ValueKey("Meal Planner"),
        shadowColor: Color.fromARGB(255, 172, 255, 78),
        elevation: 25,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(alignment: Alignment.center, children: [
          InkWell(
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MealPage()));
              },
              child: Container(
                height: 160,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                  child: RichText(
                      text: TextSpan(
                          text: "Meal Planner \n\n",
                          style: TextStyle(
                              color: Color.fromARGB(255, 3, 3, 3),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                        TextSpan(
                          text: meals,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 86, 83, 83),
                              fontSize: 21),
                        )
                      ])),
                ),
              ))
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
                          color: charts.MaterialPalette.purple.shadeDefault,
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
}
