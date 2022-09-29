import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Month extends StatefulWidget {
  const Month({Key? key, this.month = "", this.price = 0, this.glSpent = 0})
      : super(key: key);
  final String month;
  final int price; //total Gl price estimate
  final int glSpent; //GL amount spent after shopping
  @override
  State<Month> createState() => MyMonthState();
}

class MyMonthState extends State<Month> {
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final budgetController = TextEditingController();
  double bud = 0;
  String input = "0"; //input taken for budget
  String mybudget = ""; // budget amount per month
  double totRem = 0; //total amount remaining for the entire month
  double totSpent = 0; //total amount spent for the entire month
  double totBudget = 0; //total budget for the entire month
  bool budgetSet = false;

  String compMessage = "";

  //variables for week 1
  final spentOneController = TextEditingController();
  String spent1 = "0.0";
  String rem1 = "0";
  bool editOne = false;

  //variables for week 2
  final spentTwoController = TextEditingController();
  String spent2 = "0.0";
  String rem2 = "0";
  bool editTwo = false;

  //variables for week 3
  final spentThreeController = TextEditingController();
  String spent3 = "0.0";
  String rem3 = "0";
  bool editThree = false;

  //variables for week 4
  final spentFourController = TextEditingController();
  String spent4 = "0.0";
  String rem4 = "0";
  bool editFour = false;
  String buttonMsg = "";
  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _budget =>
      firestore.collection('Users').doc(uid).collection('Budget');
  CollectionReference get _groceryList =>
      firestore.collection('Users').doc(uid).collection('GroceryList');

  CollectionReference get _frequent =>
      firestore.collection('Users').doc(uid).collection('Frequency');
  List<String> frequentItems = [];
  List<int> frequency = [];
  double current = 0.0;
  double actual = 0.0;
  List<double> cpi = [];
  List<String> dates = [];
  double suggested = 0;
  List<String> items = [];

  List<int> bought = [];
  List<String> estimate = [];
  List<double> budgetM = [];
  double est = 0;
  //DateTime today = DateTime.now();

  void getDB(context) async {
    print("today");
    bought = [];
    //print("");
    totSpent = 0;
    totBudget = 0;
    //print("START");

    var collection =
        firestore.collection('Users').doc(uid).collection('Budget');
    var docSnapshot = await collection.doc(widget.month).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      totBudget = data['budget'].toDouble();
    }

    //totRem -= totSpent;
    //print(totBudget);
    firestore
        .collection('Users')
        .doc(uid)
        .collection('Budget')
        .doc(widget.month)
        .collection('Week1')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent1 = doc["amount spent"].toStringAsFixed(2);
        //print(doc["amount spent"]);
        mybudget = doc["budget"].toStringAsFixed(2);
        rem1 = doc["amount remaining"].toStringAsFixed(2);
      });
    });

    firestore
        .collection('Users')
        .doc(uid)
        .collection('Budget')
        .doc(widget.month)
        .collection('Week2')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent2 = doc["amount spent"].toStringAsFixed(2);
        rem2 = doc["amount remaining"].toStringAsFixed(2);
        //print(doc["amount spent"]);
      });
    });

    firestore
        .collection('Users')
        .doc(uid)
        .collection('Budget')
        .doc(widget.month)
        .collection('Week3')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent3 = doc["amount spent"].toStringAsFixed(2);
        //print(doc["amount spent"]);
        rem3 = doc["amount remaining"].toStringAsFixed(2);
      });
    });

    firestore
        .collection('Users')
        .doc(uid)
        .collection('Budget')
        .doc(widget.month)
        .collection('Week4')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent4 = doc["amount spent"].toStringAsFixed(2);
        //print(doc["amount spent"]);
        rem4 = doc["amount remaining"].toStringAsFixed(2);
      });
    });

    bought = [];
    double update = 0;
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "November",
      "December"
    ];
    var totals = firestore.collection('Users').doc(uid).collection('GL totals');
    var ds = await totals.doc('Totals').get();
    DateTime _focusedDay = DateTime.now();
    String currMonth = months[_focusedDay.month - 1];
    print(currMonth);
    if (currMonth.toLowerCase() == widget.month.toLowerCase()) {
      if (ds.exists) {
        Map<String, dynamic> data = ds.data()!;
        //print(data['shopping total']);
        // You can then retrieve the value from the Map like this:
        //bought.add(data['shopping total']);
        String st = data['estimated total'].toStringAsFixed(2);
        //String estimates = data['estimated total'].toString();

        update += double.parse(st);
        //est += double.parse(estimates);
        //est
      }
    }

    totSpent = 0;
    totSpent += double.parse(spent1) +
        double.parse(spent2) +
        double.parse(spent3) +
        double.parse(spent4) +
        update;

    if (mounted) {
      setState(() {
        //totRem -= totSpent;
        totRem = 0;
        totRem = totBudget;
        totRem -= totSpent;
        if (totRem != null) {
          _budget.doc(widget.month).set({
            'budget': totBudget,
            'total remaining': totRem,
            'total spent': totSpent,
            'month': widget.month
          });
        }
      });
    }
    //setState(() => {});
    //return;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDB(context);
  }

  percentIndicator(double spent, double rem, String budget, String w) {
    if (budget != "") {
      double b = double.parse(budget);
      percentageSpent = spent / b;
      percentageRemaining = rem / b * 100;
      percentageSpent = double.parse(percentageSpent.toStringAsFixed(2));
      percentageRemaining =
          double.parse(percentageRemaining.toStringAsFixed(2));
    }
    if (percentageSpent > 1 || percentageRemaining == double.negativeInfinity) {
      percentageSpent = 0;
      percentageRemaining = 100;
    }

    return Container(
        width: 400,
        height: 250,
        //margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                child: Column(children: [
              Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: Text(
                      '${w}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 65),
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 150,
                animation: true,
                lineHeight: 25.0,
                animationDuration: 2000,
                barRadius: const Radius.circular(16),
                percent: double.parse(percentageSpent.toStringAsFixed(2)),
                center: Text(percentageRemaining.toString() + "% remaining"),
                progressColor: percentageRemaining >= 60
                    ? Color.fromARGB(255, 72, 216, 29)
                    : percentageRemaining < 60 && percentageRemaining >= 30
                        ? Color.fromARGB(255, 248, 141, 10)
                        : Color.fromARGB(255, 236, 17, 2),
              )
            ]))));
  }

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => getDB(context));

    return Scaffold(
      appBar: buildAppBar(context, widget.month),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          if (budgetSet) setBudget() else viewBudget(),
          const SizedBox(height: 24),
          //WeekOne(),
          Container(
              child: CarouselSlider(
                  key: Key('Week1 carousel'),
                  options: CarouselOptions(
                    aspectRatio: 1.4,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: <Widget>[
                Indicator(spent1, rem1, mybudget, 'Week 1'),
                WeekOne(),
              ])),
          const SizedBox(height: 24),
          Container(
              child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.4,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: <Widget>[
                Indicator(spent2, rem2, mybudget, 'Week 2'),
                WeekTwo(),
              ])),

          const SizedBox(height: 24),
          Container(
              child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.4,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: <Widget>[
                Indicator(spent3, rem3, mybudget, 'Week 3'),
                WeekThree(),
              ])),
          const SizedBox(height: 24),
          Container(
              child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.4,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: <Widget>[
                Indicator(spent4, rem4, mybudget, 'Week 4'),
                WeekFour(),
              ])),
          const SizedBox(height: 32),
          Container(
              child: CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.5,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: <Widget>[
                Indicator(totSpent.toString(), totRem.toString(),
                    totBudget.toString(), 'Totals'),
                Totals(),
              ])),
          const SizedBox(height: 32),
          EstTotal(),

          /*Container(
              child: CarouselSlider(
                  options: CarouselOptions(
                    disableCenter: true,
                  ),
                  items: <Widget>[
                if (budgetSet) setBudget() else viewBudget(),
                const SizedBox(height: 24),
                WeekTwo(),
                const SizedBox(height: 24),
                Indicator(spent2, rem2),
              ])),*/

          //Comparison(),
          //showAlertDialog(context)
        ],
      ),
    );
  }

  Widget viewBudget() => Column(
        children: [
          Text('Your Budget for ' + '${widget.month}' + ' is: ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 25),
          Container(
            height: 60,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.money,
                  color: Colors.grey,
                ),
                Text(
                  '   R ' + totBudget.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 25),
          ElevatedButton(
            key: const Key("editBudget"),
            onPressed: () async => {
              setState(() {
                budgetSet = true;
              })
            },
            child: const Text(
              'Edit Budget',
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              shape: const StadiumBorder(),
              onPrimary: const Color.fromARGB(255, 150, 66, 154),
              side: BorderSide(
                  color: const Color.fromARGB(255, 150, 66, 154), width: 3.0),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      );

  Widget setBudget() => Column(
        children: [
          Text('Enter Your budget for ' + '${widget.month}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 25,
          ),
          TextField(
            key: const Key("enterBudget"),
            controller: budgetController,
            decoration: const InputDecoration(
              hintText: ('R '),
              labelText: 'Budget',
              prefixIcon: Icon(Icons.money),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            // autofocus: true,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            key: const Key("setBudget"),
            onPressed: () {
              setState(() {
                //totSpent = 0;

                budgetSet = false;
                input = budgetController.text;
                if (input.length > 0) {
                  bud = double.parse(input);
                } else
                  () {
                    bud = totBudget;
                  };

                //total budget for entire month = input from enterBudget textfield
                totBudget = bud;
                totRem = totBudget;

                _budget.doc(widget.month).set({
                  'budget': totBudget,
                  'total remaining': totRem,
                  'total spent': totSpent,
                  'month': widget.month
                });

                double updateSpent = 0;

                bud = bud / 4;
                mybudget = bud.toStringAsFixed(2);
                rem1 = mybudget;
                updateSpent = double.parse(rem1);
                updateSpent -= double.parse(spent1);
                rem1 = updateSpent.toStringAsFixed(2);
                // print("rem1");
                // print(rem1);
                //update DB for week 1
                _budget.doc(widget.month).collection('Week1').doc('Week1').set({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem1),
                  'amount spent': double.parse(spent1)
                });

                rem2 = mybudget;
                updateSpent = double.parse(rem2);
                updateSpent -= double.parse(spent2);
                rem2 = updateSpent.toStringAsFixed(2);
                //update DB for week 2
                _budget.doc(widget.month).collection('Week2').doc('Week2').set({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem2),
                  'amount spent': double.parse(spent2)
                });
                rem3 = mybudget;
                updateSpent = double.parse(rem3);
                updateSpent -= double.parse(spent3);
                rem3 = updateSpent.toStringAsFixed(2);
                //update DB for week 3
                _budget.doc(widget.month).collection('Week3').doc('Week3').set({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem3),
                  'amount spent': double.parse(spent3)
                });
                rem4 = mybudget;
                updateSpent = double.parse(rem4);
                updateSpent -= double.parse(spent4);
                rem4 = updateSpent.toStringAsFixed(2);
                //update DB for week 4
                _budget.doc(widget.month).collection('Week4').doc('Week4').set({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem4),
                  'amount spent': double.parse(spent4)
                });

                if (totRem != null) {
                  _budget.doc(widget.month).set({
                    'budget': totBudget,
                    'total remaining': totRem,
                    'total spent': totSpent,
                    'month': widget.month
                  });
                }
              });
            },
            child: const Text("Set Budget"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              shape: const StadiumBorder(),
              onPrimary: const Color.fromARGB(255, 150, 66, 154),
              side: BorderSide(
                  color: const Color.fromARGB(255, 150, 66, 154), width: 3.0),
            ),
          ),
          TextButton(
              onPressed: () {
                //suggested = 0.0;

                getMostFrequent(items);
                //print(items);

                setState(() {
                  //print(suggested);
                  budgetController.text = suggested.toString();
                });
              },
              child: Text("Suggest",
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 150, 66, 154),
                  )))
        ],
      );
  double percentageSpent = 0;
  double percentageRemaining = 0;

  getMostFrequent(List<String> items) async {
    var ds = await _frequent.doc('items').get();
    if (ds.exists) {
      Map<String, dynamic> data = ds.data() as Map<String, dynamic>;

      frequentItems = data['itemNames'].cast<String>();
      frequency = data['frequency'].cast<int>();
      List<int> indexes = [];
      //get indexes of items with a frequency greater than 2
      for (int i = 0; i < frequency.length; i++) {
        if (frequency[i] > 2) {
          indexes.add(i);
        }
      }
      for (int i = 0; i < indexes.length; i++) {
        indexes[i] = indexes[i] - 1;
      }
      //print(indexes);
      //print(frequentItems);
      //get items with frequency greater than 2 using the indexes.
      for (int i = 0; i < indexes.length; i++) {
        //print(frequentItems[indexes[i]]);
        items.add(frequentItems[indexes[i]]);
      }

      setState(() {
        this.items = items;
        for (int i = 0; i < items.length; i++) {
          //print(items[i]);

          getSuggestion(items[i]);
        }
      });
    }
  }

  getSuggestion(String item) {
    current = 0;

    String date = DateTime.now().month.toString();
    if (date.length == 1) {
      String temp = '0' + date;
      date = temp;
    }
    //print(date);
    //print("item " + item + " for: " + date);
    firestore
        .collection('Prices')
        .doc(item)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print('Document data: ${documentSnapshot.data()}');
        //print('Document data: ${documentSnapshot.data()}');
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        actual = data['actual'];
        //print("actual: " + actual.toString());
        cpi = [];
        for (var i in data['cpi']) {
          cpi.add(i as double);
        }
        dates = [];
        for (var i in data['dates']) {
          String date = i as String;
          final splitted = date.split('-');
          date = splitted[1];
          //date += "/";
          //date += splitted[0];
          //dates.add(new DateFormat('MM/yyyy').parse(date) as String);
          dates.add(date);
        }
        int index = getToday(date);
        //print('index ' + index.toString());
        double prev = 0;
        if (index > 0) {
          prev = cpi[index - 1];
        }
        double now = cpi[index];

        double change = now - prev; //get the percentage change

        double c = change / 100;
        print(prev);
        print(now);
        //print("cpi: ");
        //print(cpi);
        current = (c * actual) + actual;
        print(item + "  current: " + current.toString());
        setState(() {
          suggested += current;
          //print(suggested);
          this.suggested = suggested;
          budgetController.text = suggested.toStringAsFixed(2);
        });
        //return current;
      } else {
        print('Document does not exist on the database');
        //return current;
      }
    });
  }

  int getToday(String today) {
    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == today) {
        return i;
      }
    }
    return (dates.length + 1);
  }

  Widget Indicator(String s, String r, String b, String week) => Container(
      child: Center(
          child: percentIndicator(double.parse(s), double.parse(r), b, week)));

  Widget WeekOne() => Container(
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: const Center(
                  child: Text(
                    'Week 1',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Budget"),
              Text("R " + mybudget + "   ")
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Spent"),
              Flexible(
                  child: !editOne
                      ? Text('R' + spent1 + "   ")
                      : TextField(
                          key: const Key("spent1"),
                          textAlign: TextAlign.right,
                          controller: spentOneController,
                          decoration: const InputDecoration(
                            hintText: 'R 0',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            setState(() {
                              if (double.parse(spent1) !=
                                  double.parse(spentOneController.text)) {
                                print("same");
                                totSpent -= double.parse(spent1);
                                totRem += double.parse(spent1);
                                spent1 = spentOneController.text;
                                totRem -= double.parse(spent1);
                                double left = double.parse(spent1);

                                totSpent += double.parse(spent1);
                                left = double.parse(mybudget) -
                                    double.parse(spent1);

                                rem1 = left.toString();
                                _budget
                                    .doc(widget.month)
                                    .collection('Week1')
                                    .doc('Week1')
                                    .set({
                                  'budget': mybudget,
                                  'amount spent': double.parse(spent1),
                                  'amount remaining': rem1
                                });
                              }
                              spent1 = spentOneController.text;

                              editOne = false;
                            });
                          },
                        )),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Remaining"),
              Text("R " + rem1 + "   "),
            ]),
            IconButton(
              key: Key('Week1 edit'),
              alignment: Alignment.bottomRight,
              //color: Colors.green,
              //hoverColor: Colors.green,
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => {
                      editOne = true,
                    });
              },
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            /*Padding(
            padding: const EdgeInsets.all(15.0),
            child: percentIndicator(
                double.parse(spent1), double.parse(rem1), mybudget))*/
          ])));

  Widget WeekTwo() => Container(
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              child: Column(children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: const Center(
                  child: Text(
                    'Week 2',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Budget"),
              Text("R" + mybudget + "   ")
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Spent"),
              Flexible(
                  child: !editTwo
                      ? Text('R' + spent2 + "   ")
                      : TextField(
                          key: const Key("spent2"),
                          textAlign: TextAlign.right,
                          controller: spentTwoController,
                          decoration: const InputDecoration(
                            hintText: 'R 0',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            setState(() {
                              if (double.parse(spent2) !=
                                  double.parse(spentTwoController.text)) {
                                print("same");
                                totSpent -= double.parse(spent2);
                                totRem += double.parse(spent2);
                                spent2 = spentTwoController.text;
                                totRem -= double.parse(spent2);
                                double left = double.parse(spent2);

                                totSpent += double.parse(spent2);
                                left = double.parse(mybudget) -
                                    double.parse(spent2);

                                rem2 = left.toString();
                                _budget
                                    .doc(widget.month)
                                    .collection('Week2')
                                    .doc('Week2')
                                    .set({
                                  'budget': mybudget,
                                  'amount spent': double.parse(spent2),
                                  'amount remaining': rem2
                                });
                              }
                              spent2 = spentTwoController.text;
                              // if (totRem != null) {
                              //   _budget
                              //       .doc(widget.month)
                              //       .update({'total remaining': totRem});
                              // }
                              // if (totSpent != null) {
                              //   _budget
                              //       .doc(widget.month)
                              //       .update({'total spent': totSpent});
                              // }
                              editTwo = false;
                            });
                          },
                        ))
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Remaining"),
              Text("R " + rem2 + "   ")
            ]),
            IconButton(
              alignment: Alignment.bottomRight,
              //color: Colors.green,
              //hoverColor: Colors.green,
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => {
                      editTwo = true,
                    });
              },
            ),
            const SizedBox(height: 10),
          ]))));

  Widget WeekThree() => Container(
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              child: Column(children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: const Center(
                  child: Text(
                    'Week 3',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Budget"),
              Text("R" + mybudget + "   ")
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Spent"),
              Flexible(
                  child: !editThree
                      ? Text('R' + spent3 + "   ")
                      : TextField(
                          key: const Key("spent3"),
                          textAlign: TextAlign.right,
                          controller: spentThreeController,
                          decoration: const InputDecoration(
                            hintText: 'R 0',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            setState(() {
                              if (double.parse(spent3) !=
                                  double.parse(spentThreeController.text)) {
                                print("same");
                                totSpent -= double.parse(spent3);
                                totRem += double.parse(spent3);
                                spent3 = spentThreeController.text;
                                totRem -= double.parse(spent3);
                                double left = double.parse(spent3);

                                totSpent += double.parse(spent3);
                                left = double.parse(mybudget) -
                                    double.parse(spent3);

                                rem3 = left.toString();
                                _budget
                                    .doc(widget.month)
                                    .collection('Week3')
                                    .doc('Week3')
                                    .set({
                                  'budget': mybudget,
                                  'amount spent': double.parse(spent3),
                                  'amount remaining': rem3
                                });
                              }
                              spent3 = spentThreeController.text;
                              // if (totRem != null) {
                              //   _budget
                              //       .doc(widget.month)
                              //       .update({'total remaining': totRem});
                              // }
                              // if (totSpent != null) {
                              //   _budget
                              //       .doc(widget.month)
                              //       .update({'total spent': totSpent});
                              // }
                              editThree = false;
                            });
                          },
                        ))
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Remaining"),
              Text("R " + rem3 + "   ")
            ]),
            IconButton(
              alignment: Alignment.bottomRight,
              //color: Colors.green,
              //hoverColor: Colors.green,
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => {
                      editThree = true,
                    });
              },
            ),
            const SizedBox(height: 10),
          ]))));

  Widget WeekFour() => Container(
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              child: Column(children: [
            Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: const Center(
                  child: Text(
                    'Week 4',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Budget"),
              Text("R" + mybudget + "   ")
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Spent"),
              Flexible(
                  child: !editFour
                      ? Text('R' + spent4 + "   ")
                      : TextField(
                          key: const Key("spent4"),
                          textAlign: TextAlign.right,
                          controller: spentFourController,
                          decoration: const InputDecoration(
                            hintText: 'R 0',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            setState(() {
                              if (double.parse(spent4) !=
                                  double.parse(spentFourController.text)) {
                                print("same");
                                totSpent -= double.parse(spent4);
                                totRem += double.parse(spent4);
                                spent4 = spentFourController.text;
                                totRem -= double.parse(spent4);
                                double left = double.parse(spent4);

                                totSpent += double.parse(spent4);
                                left = double.parse(mybudget) -
                                    double.parse(spent4);

                                rem4 = left.toString();
                                _budget
                                    .doc(widget.month)
                                    .collection('Week4')
                                    .doc('Week4')
                                    .set({
                                  'budget': mybudget,
                                  'amount spent': double.parse(spent4),
                                  'amount remaining': rem4
                                });
                              }
                              editFour = false;
                            });
                          },
                        ))
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("   Amount Remaining"),
              Text(rem4 + "   ")
            ]),
            IconButton(
              alignment: Alignment.bottomRight,
              //color: Colors.green,
              //hoverColor: Colors.green,
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() => {
                      editFour = true,
                    });
              },
            ),
            const SizedBox(height: 10),
          ]))));

  Widget Totals() => Container(
      child: Card(
          elevation: 10,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
              key: const Key("totals"),
              child: Column(children: [
                Container(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: const Center(
                      child: Text(
                        'Totals',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  key: const Key("totSpent"),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 3),
                  )),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "   Total Amount Spent:  " + totSpent.toString())),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 3),
                  )),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("   Total Amount Remaining:  " +
                          totRem.toString() +
                          "   ")),
                ),
                const SizedBox(height: 10),
              ]))));

  //double update = 0;
  Widget EstTotal() => ElevatedButton(
        key: Key("Compare"),
        onPressed: () async {
          est = 0;
          var totals =
              firestore.collection('Users').doc(uid).collection('GL totals');
          var ds = await totals.doc('Totals').get();
          if (ds.exists) {
            Map<String, dynamic> data = ds.data()!;

            String estimates = data['shopping total'].toString();

            est += double.parse(estimates);
            //est
          }
          double tr = 0;
          var collection =
              firestore.collection('Users').doc(uid).collection('Budget');
          var docSnapshot = await collection.doc(widget.month).get();
          if (docSnapshot.exists) {
            Map<String, dynamic> data = docSnapshot.data()!;

            // You can then retrieve the value from the Map like this:
            tr = data['total remaining'].toDouble();
          }
          print(tr);

          String message = "";
          double comp = 0;
          comp += est;
          compMessage = " Your estimated total is R " + comp.toString() + ". ";
          if (comp < tr) {
            message = "Your Grocery List is within budget. ";
            comp = tr - comp;
            message += "You will have R " +
                comp.toStringAsFixed(2) +
                " remaining after shopping.";
          } else {
            comp = comp - tr;
            message = "You are " + comp.toString() + " over budget.";
          }
          setState(() {
            compMessage += message;
          });
          showAlertDialog(context);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50),
          shape: const StadiumBorder(),
          onPrimary: const Color.fromARGB(255, 150, 66, 154),
          side: BorderSide(
              color: const Color.fromARGB(255, 150, 66, 154), width: 3.0),
        ),
        child: const Text("Compare to Grocery List"),
      );

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      key: Key("okbutton"),
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Compare Grocery List to Budget"),
      content: Text(compMessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
