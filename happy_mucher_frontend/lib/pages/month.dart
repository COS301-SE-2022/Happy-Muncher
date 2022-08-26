import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';

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
  final uid = FirebaseAuth.instance.currentUser!.uid;
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

    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Budget');
    var docSnapshot = await collection.doc(widget.month).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:
      totBudget = data['budget'].toDouble();
    }

    //totRem -= totSpent;
    //print(totBudget);
    collection
        .doc(widget.month)
        .collection('Week1')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent1 = doc["amount spent"].toString();
        //print(doc["amount spent"]);
        mybudget = doc["budget"].toString();
        rem1 = doc["amount remaining"].toString();
      });
    });

    collection
        .doc(widget.month)
        .collection('Week2')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent2 = doc["amount spent"].toString();
        rem2 = doc["amount remaining"].toString();
        //print(doc["amount spent"]);
      });
    });

    collection
        .doc(widget.month)
        .collection('Week3')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent3 = doc["amount spent"].toString();
        //print(doc["amount spent"]);
        rem3 = doc["amount remaining"].toString();
      });
    });

    collection
        .doc(widget.month)
        .collection('Week4')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent4 = doc["amount spent"].toString();
        //print(doc["amount spent"]);
        rem4 = doc["amount remaining"].toString();
      });
    });
    //
    //getDB();
    //print('spent set');
    bought = [];
    double update = 0;
    // try {
    //   await FirebaseFirestore.instance
    //       .collection('GroceryList')
    //       .get()
    //       .then((QuerySnapshot qs) {
    //     qs.docs.forEach((doc) {
    //       if (doc["bought"] == true) {
    //         bought.add(doc["price"]);
    //         //print(doc["price"]);
    //       }
    //     });
    //   });
    //   //return bought;
    // } catch (e) {}

    // _groceryList.get().then((QuerySnapshot qs) {
    //   qs.docs.forEach((doc) {
    //     if (doc["bought"] == true) {
    //       bought.add(doc["price"]);
    //       //print(doc["price"]);
    //       //print(bought);
    //     }
    //   });
    // });

    var totals = FirebaseFirestore.instance.collection('GL totals');
    var ds = await totals.doc('Totals').get();
    if (ds.exists) {
      Map<String, dynamic> data = ds.data()!;
      //print(data['shopping total']);
      // You can then retrieve the value from the Map like this:
      //bought.add(data['shopping total']);
      String st = data['shopping total'].toString();
      //String estimates = data['estimated total'].toString();
      update += double.parse(st);
      //est += double.parse(estimates);
      //est
    }

// bought.forEach((element) {
//       update += double.parse(element.to);
//     });
    // print("got update");
    // print(update);
    totSpent = 0;
    totSpent += double.parse(spent1) +
        double.parse(spent2) +
        double.parse(spent3) +
        double.parse(spent4) +
        update;

    //print(totSpent);
    // print("totspent");
    // print(totSpent);
    if (mounted) {
      setState(() {
        //totRem -= totSpent;
        totRem = 0;
        totRem = totBudget;
        totRem -= totSpent;
        /*if (totRem != null) {
          _budget.doc(widget.month).update({'total remaining': totRem});
        }
        if (totSpent != null) {
          _budget.doc(widget.month).update({'total spent': totSpent});
        }*/
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

  ///figure out how to display info on page startup

  // @override
  // void initState() => getDB(context);

  //get current month
  //DocumentReference get _currentMonth => _budget.doc(widget.month);
  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => getDB(context));
// WidgetsBinding.instance.addPostFrameCallback((_) => yourFunc(context));

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('${widget.month}'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 95, 13),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          if (budgetSet) setBudget() else viewBudget(),
          const SizedBox(height: 24),
          WeekOne(),
          const SizedBox(height: 24),
          WeekTwo(),
          const SizedBox(height: 24),
          WeekThree(),
          const SizedBox(height: 24),
          WeekFour(),
          const SizedBox(height: 32),
          Totals(),
          EstTotal(),
          //Comparison(),
          //showAlertDialog(context)
        ],
      ),
    );
  }

  Widget viewBudget() => Column(
        children: [
          Text('Your Budget for ' + '${widget.month}' + ' is: ',
              style: TextStyle(height: 1.2)),
          Container(
            height: 60,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.zero,
            ),
            //child: Text('R ' + totBudget.toString()),
            child: Row(
              children: [
                Icon(
                  Icons.money,
                  color: Colors.grey,
                ),
                Text(
                  '   R ' + totBudget.toString(),
                ),
              ],
            ),
            alignment: Alignment.centerLeft,
          ),
          MaterialButton(
            key: Key("editBudget"),
            onPressed: () {
              setState(() {
                budgetSet = true;
              });
            },
            color: Color.fromARGB(255, 172, 255, 78),
            child: Text("Edit Budget", style: TextStyle(color: Colors.white)),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      );

  Widget setBudget() => Column(
        children: [
          Text('Enter Your budget for ' + '${widget.month}',
              style: TextStyle(height: 1.2)),
          TextField(
            key: Key("enterBudget"),
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
          MaterialButton(
            key: Key("setBudget"),
            onPressed: () async {
              var collection = FirebaseFirestore.instance.collection('Budget');

              var docSnapshot = await collection.doc(widget.month).get();

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
                if (totBudget != null) {
                  _budget.doc(widget.month).update({'budget': totBudget});
                }

                double updateSpent = 0;

                bud = bud / 4;
                mybudget = bud.toString();
                rem1 = mybudget;
                updateSpent = double.parse(rem1);
                updateSpent -= double.parse(spent1);
                rem1 = updateSpent.toString();
                // print("rem1");
                // print(rem1);
                //update DB for week 1

                _budget.doc(widget.month).collection('Week1').add({
                  'budget': double.parse(mybudget),
                  'amount spent': 0.0,
                  'amount remaining': double.parse(rem1),
                });

                rem2 = mybudget;
                updateSpent = double.parse(rem2);
                updateSpent -= double.parse(spent2);
                rem2 = updateSpent.toString();
                //update DB for week 2
                _budget.doc(widget.month).collection('Week2').add({
                  'budget': double.parse(mybudget),
                  'amount spent': 0.0,
                  'amount remaining': double.parse(rem2),
                });
                rem3 = mybudget;
                updateSpent = double.parse(rem3);
                updateSpent -= double.parse(spent3);
                rem3 = updateSpent.toString();
                //update DB for week 3
                _budget.doc(widget.month).collection('Week3').add({
                  'budget': double.parse(mybudget),
                  'amount spent': 0.0,
                  'amount remaining': double.parse(rem3),
                });
                rem4 = mybudget;
                updateSpent = double.parse(rem4);
                updateSpent -= double.parse(spent4);
                rem4 = updateSpent.toString();
                //update DB for week 4
                _budget.doc(widget.month).collection('Week4').add({
                  'budget': double.parse(mybudget),
                  'amount spent': 0.0,
                  'amount remaining': double.parse(rem4),
                });

                _budget
                    .doc(widget.month)
                    .collection('Totals')
                    .add({'total remaining': totRem});

                _budget
                    .doc(widget.month)
                    .collection('Totals')
                    .add({'total spent': totSpent});
              });
            },
            color: Color.fromARGB(255, 172, 255, 78),
            child: Text("Set Budget", style: TextStyle(color: Colors.white)),
          ),
        ],
      );

  Widget WeekOne() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 172, 255, 78),
            ),
            child: const Center(
              child: Text(
                'Week 1',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Budget"), Text("R " + mybudget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Amount Spent"),
          Flexible(
              child: !editOne
                  ? Text('R' + spent1)
                  : TextField(
                      key: Key("spent1"),
                      textAlign: TextAlign.right,
                      controller: spentOneController,
                      decoration: const InputDecoration(
                        hintText: 'R 0',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) async {
                        var collection = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Budget');
                        var docSnapshot = await collection
                            .doc(widget.month)
                            .collection('Week1')
                            .get();
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
                            left = bud - left;

                            rem1 = left.toString();

                            _budget
                                .doc(widget.month)
                                .collection('Week1')
                                .doc(docSnapshot.docs.first.id)
                                .update({
                              'amount spent': double.parse(spent1),
                              'amount remaining': rem1
                            });
                          }
                          spent1 = spentOneController.text;

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
                          editOne = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text("R " + rem1)]),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() => {
                  editOne = true,
                });
          },
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ]));

  Widget WeekTwo() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 172, 255, 78),
            ),
            child: const Center(
              child: Text(
                'Week 2',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Budget"), Text("R" + mybudget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: !editTwo
                  ? Text('R' + spent2)
                  : TextField(
                      key: Key("spent2"),
                      textAlign: TextAlign.right,
                      controller: spentTwoController,
                      decoration: const InputDecoration(
                        hintText: 'R 0',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) async {
                        var collection = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Budget');
                        var docSnapshot = await collection
                            .doc(widget.month)
                            .collection('Week2')
                            .get();
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
                            left = bud - left;

                            rem2 = left.toString();

                            _budget
                                .doc(widget.month)
                                .collection('Week2')
                                .doc(docSnapshot.docs.first.id)
                                .update({
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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text("R " + rem2)]),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() => {
                  editTwo = true,
                });
          },
        ),
        const SizedBox(height: 10),
      ]));

  Widget WeekThree() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 172, 255, 78),
            ),
            child: const Center(
              child: Text(
                'Week 3',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Budget"), Text("R" + mybudget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: !editThree
                  ? Text('R' + spent3)
                  : TextField(
                      key: Key("spent3"),
                      textAlign: TextAlign.right,
                      controller: spentThreeController,
                      decoration: const InputDecoration(
                        hintText: 'R 0',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) async {
                        var collection = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Budget');
                        var docSnapshot = await collection
                            .doc(widget.month)
                            .collection('Week3')
                            .get();
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
                            left = bud - left;

                            rem3 = left.toString();
                            _budget
                                .doc(widget.month)
                                .collection('Week3')
                                .doc(docSnapshot.docs.first.id)
                                .update({
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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text("R " + rem3)]),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() => {
                  editThree = true,
                });
          },
        ),
        const SizedBox(height: 10),
      ]));

  Widget WeekFour() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 172, 255, 78),
            ),
            child: const Center(
              child: Text(
                'Week 4',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Budget"), Text("R" + mybudget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: !editFour
                  ? Text('R' + spent4)
                  : TextField(
                      key: Key("spent4"),
                      textAlign: TextAlign.right,
                      controller: spentFourController,
                      decoration: const InputDecoration(
                        hintText: 'R 0',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) async {
                        var collection = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('Budget');
                        var docSnapshot = await collection
                            .doc(widget.month)
                            .collection('Week4')
                            .get();
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
                            left = bud - left;

                            rem4 = left.toString();
                            _budget
                                .doc(widget.month)
                                .collection('Week4')
                                .doc(docSnapshot.docs.first.id)
                                .update({
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
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text(rem4)]),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.edit),
          onPressed: () {
            setState(() => {
                  editFour = true,
                });
          },
        ),
        const SizedBox(height: 10),
      ]));

  void storeTotals() async {
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Budget');

    var docSnapshot =
        await collection.doc(widget.month).collection('Totals').get();

    _budget
        .doc(widget.month)
        .collection('Totals')
        .doc(docSnapshot.docs.first.id)
        .update({'total remaining': totRem});

    _budget
        .doc(widget.month)
        .collection('Totals')
        .doc(docSnapshot.docs.first.id)
        .update({'total spent': totSpent});
  }

  Widget Totals() {
    storeTotals();
    return Container(
        key: Key("totals"),
        child: Column(children: [
          Container(
            child: Container(
              width: 600.0,
              height: 42.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 172, 255, 78),
              ),
              child: const Center(
                child: Text(
                  'Totals',
                  style: TextStyle(
                    //fontFamily: 'Arial',
                    fontSize: 18,
                    color: Colors.white,
                    height: 1,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            key: Key("totSpent"),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey, width: 3),
            )),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Total Amount Spent:  " + totSpent.toString())),
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
                child: Text("Total Amount Remaining:  " + totRem.toString())),
          ),
        ]));
  }

  //double update = 0;
  Widget EstTotal() => ElevatedButton(
        onPressed: () async {
          est = 0;
          var totals = FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('GL totals');
          var ds = await totals.doc('Totals').get();
          if (ds.exists) {
            Map<String, dynamic> data = ds.data()!;

            String estimates = data['estimated total'].toString();

            est += double.parse(estimates);
            //est
          }
          double tr = 0;
          var collection = FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Budget');
          var docSnapshot = await collection.doc(widget.month).get();
          if (docSnapshot.exists) {
            Map<String, dynamic> data = docSnapshot.data()!;

            // You can then retrieve the value from the Map like this:
            tr = data['total remaining'].toDouble();
          }

          // print(totRem);
          print(tr);
          //getGL();
          // FirebaseFirestore.instance
          //     .collection('GroceryList')
          //     .get()
          //     .then((QuerySnapshot qs) {
          //   qs.docs.forEach((doc) {
          //     estimate.add(doc["price"]);
          //   });
          //   // print("estimate");
          //   // print(estimate);
          // });
          // // print("getGL called");
          // // print(estimate);
          // if (estimate.isEmpty) {
          //   //print("values not set");
          // }
          // estimate.forEach((element) {
          //   est += double.parse(element);
          //   // print("got estimates");
          //   // print(est);
          // });

          String message = "";
          double comp = 0;
          comp += est;
          compMessage = " Your estimated total is R " + comp.toString() + ". ";
          if (comp < tr) {
            message = "Your Grocery List is within budget. ";
            comp = tr - comp;
            message += "You will have R " +
                comp.toString() +
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
          primary: Color.fromARGB(255, 172, 255, 78),
        ),
        child: Text("Compare to Grocery List"),
      );

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Compare Grocery List to Budget"),
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
