import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final budgetController = TextEditingController();
  double bud = 0;
  String input = "0";
  String mybudget = "";
  double totRem = 0;
  double totSpent = 0;
  double totBudget = 0;

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

  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _budget => firestore.collection('Budget');
  CollectionReference get _groceryList => firestore.collection('GroceryList');

  // setSpent() async {
  //   //var _collection = FirebaseFirestore.instance.collection('Budget');
  //   var snapshot =
  //       await _budget.doc(widget.month).collection('Week1').doc('Week1').get();
  //   if (snapshot.exists) {
  //     Map<String, dynamic> data = snapshot.data()!;
  //     spent1 = data['amount spent'].toString();
  //     print(spent1);
  //   }
  // }

  List<String> bought = [];
  List<String> estimate = [];

  Future<void> setSpent() async {
    // Get docs from collection reference
    //QuerySnapshot querySnapshot = await _budget.get();
    firestore
        .collection('Budget')
        .doc(widget.month)
        .collection('Week1')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent1 = doc["amount spent"].toString();
        print(doc["amount spent"]);
      });
    });

    firestore
        .collection('Budget')
        .doc(widget.month)
        .collection('Week2')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent2 = doc["amount spent"].toString();
        print(doc["amount spent"]);
      });
    });

    firestore
        .collection('Budget')
        .doc(widget.month)
        .collection('Week3')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent3 = doc["amount spent"].toString();
        print(doc["amount spent"]);
      });
    });

    firestore
        .collection('Budget')
        .doc(widget.month)
        .collection('Week4')
        .get()
        .then((QuerySnapshot qs) {
      qs.docs.forEach((doc) {
        spent4 = doc["amount spent"].toString();
        print(doc["amount spent"]);
      });
    });
  }

  ///figure out how to display info on page startup
  @override
  void initState() {
    super.initState();

    setSpent();
    print("set");
  }

  //get current month
  //DocumentReference get _currentMonth => _budget.doc(widget.month);
  @override
  Widget build(BuildContext context) {
    //print("total spent" + totSpent.toString());
    //getsp();
    // FirebaseFirestore.instance
    //     .collection('Budget')
    //     .doc(widget.month)
    //     .collection('Week2')
    //     .get()
    //     .then((QuerySnapshot qs) {
    //   qs.docs.forEach((doc) {
    //     print("Here");S
    //     //spent1 = doc["amount spent"].toString();
    //     print(doc["amount spent"]);
    //     print("done");
    //   });
    // });
    setSpent();
    setState(() {});
    print("calling");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('${widget.month}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          IconButton(
            alignment: Alignment.topCenter,
            //color: Colors.green,
            //hoverColor: Colors.green,
            icon: Icon(Icons.refresh),
            onPressed: () {
              totSpent = 0;
              setSpent();
              print('spent set');
              totSpent += double.parse(spent1) +
                  double.parse(spent2) +
                  double.parse(spent3) +
                  double.parse(spent4);

              double update = 0;

              _groceryList.get().then((QuerySnapshot qs) {
                qs.docs.forEach((doc) {
                  if (doc["bought"] == true) {
                    bought.add(doc["price"]);
                  }
                });
                //print("bought");
              });
              bought.forEach((element) {
                update += double.parse(element);
              });
              //print("got update");
              //print(update);
              totSpent += update;
              setState(() => {});
            },
          ),
          Text('Enter Your budget for ' + '${widget.month}',
              style: TextStyle(height: 1.2)),

          // setSpent(),

          enterBudget(),
          MaterialButton(
            key: Key("setBudget"),
            onPressed: () {
              setState(() {
                //totSpent = 0;
                input = budgetController.text;
                if (input.length > 0) {
                  bud = double.parse(input);
                } else
                  () {
                    bud = 0;
                  };

                totBudget = bud;
                if (totBudget != null) {
                  _budget.doc(widget.month).update({'budget': totBudget});
                }
                double updateSpent = 0;
                totRem = bud;

                bud = bud / 4;
                mybudget = bud.toString();

                //totSpent = 0;
                //totSpent += widget.glSpent.toDouble();

                //print("spent update");
                // print(totSpent);
                totRem -= totSpent;
                print("rem");
                rem1 = mybudget;
                updateSpent = double.parse(rem1);
                updateSpent -= double.parse(spent1);
                rem1 = updateSpent.toString();
                // print("rem1");
                // print(rem1);
                //update DB for week 1
                _budget
                    .doc(widget.month)
                    .collection('Week1')
                    .doc('Week1')
                    .update({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem1),
                });

                rem2 = mybudget;
                updateSpent = double.parse(rem2);
                updateSpent -= double.parse(spent2);
                rem2 = updateSpent.toString();
                //update DB for week 2
                _budget
                    .doc(widget.month)
                    .collection('Week2')
                    .doc('Week2')
                    .update({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem2),
                });
                rem3 = mybudget;
                updateSpent = double.parse(rem3);
                updateSpent -= double.parse(spent3);
                rem3 = updateSpent.toString();
                //update DB for week 3
                _budget
                    .doc(widget.month)
                    .collection('Week3')
                    .doc('Week3')
                    .update({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem3),
                });
                rem4 = mybudget;
                updateSpent = double.parse(rem4);
                updateSpent -= double.parse(spent4);
                rem4 = updateSpent.toString();
                //update DB for week 4
                _budget
                    .doc(widget.month)
                    .collection('Week4')
                    .doc('Week4')
                    .update({
                  'budget': double.parse(mybudget),
                  'amount remaining': double.parse(rem4),
                });
              });
            },
            color: Colors.green,
            child:
                const Text("Set Budget", style: TextStyle(color: Colors.white)),
          ),
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

  Widget enterBudget() => TextFormField(
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
      );

  Widget WeekOne() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Colors.green,
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
                      onSubmitted: (value) {
                        setState(() {
                          spent1 = spentOneController.text;
                          totRem -= double.parse(spent1);
                          double left = double.parse(spent1);
                          totSpent += double.parse(spent1);
                          //setSpent();
                          print("set");
                          left = bud - left;
                          rem1 = left.toString();
                          _budget
                              .doc(widget.month)
                              .collection('Week1')
                              .doc('Week1')
                              .update({
                            'amount spent': double.parse(spent1),
                            'amount remaining': rem1
                          });

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
              color: Colors.green,
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
                      onSubmitted: (value) {
                        setState(() {
                          spent2 = spentTwoController.text;
                          totRem -= double.parse(spent2);
                          double left = double.parse(spent2);
                          totSpent += double.parse(spent2);
                          left = bud - left;
                          rem2 = left.toString();
                          _budget
                              .doc(widget.month)
                              .collection('Week2')
                              .doc('Week2')
                              .update({
                            'amount spent': double.parse(spent2),
                            'amount remaining': rem2
                          });
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
              color: Colors.green,
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
                      onSubmitted: (value) {
                        setState(() {
                          spent3 = spentThreeController.text;
                          totRem -= double.parse(spent3);
                          double left = double.parse(spent3);
                          totSpent += double.parse(spent3);
                          left = bud - left;
                          rem3 = left.toString();
                          _budget
                              .doc(widget.month)
                              .collection('Week3')
                              .doc('Week3')
                              .update({
                            'amount spent': double.parse(spent3),
                            'amount remaining': rem3
                          });
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
              color: Colors.green,
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
                      onSubmitted: (value) {
                        setState(() {
                          spent4 = spentFourController.text;
                          totRem -= double.parse(spent4);
                          double left = double.parse(spent4);
                          totSpent += double.parse(spent4);
                          left = bud - left;
                          rem4 = left.toString();
                          _budget
                              .doc(widget.month)
                              .collection('Week4')
                              .doc('Week4')
                              .update({
                            'amount spent': double.parse(spent4),
                            'amount remaining': rem4
                          });
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

  Widget Totals() => Container(
      key: Key("totals"),
      child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration: const BoxDecoration(
              color: Colors.green,
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
  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _groceryList.get();
  //   FirebaseFirestore.instance
  //       .collection('GroceryList')
  //       .get()
  //       .then((QuerySnapshot qs) {
  //     qs.docs.forEach((doc) {
  //       if (doc["bought"] == true) {
  //         bought.add(doc["price"]);
  //       }
  //       estimate.add(doc["price"]);
  //       print("bought");
  //       print(bought);
  //       print("estimate");
  //       print(estimate);
  //     });
  //   });
  // }
  getGL() {
    // bought.clear();
    //estimate.clear();
    //QuerySnapshot querySnapshot = await _budget.get();
  }

  double est = 0;
  double update = 0;
  Widget EstTotal() => ElevatedButton(
        onPressed: () {
          //getGL();
          FirebaseFirestore.instance
              .collection('GroceryList')
              .get()
              .then((QuerySnapshot qs) {
            qs.docs.forEach((doc) {
              // if (doc["bought"] == true) {
              //   bought.add(doc["price"]);
              // }
              estimate.add(doc["price"]);
            });
            // print("bought");
            // print(bought);
            print("estimate");
            print(estimate);
          });
          print("getGL called");
          print(estimate);
          if (estimate.isEmpty) {
            print("values not set");
          }
          estimate.forEach((element) {
            est += double.parse(element);
            print("got estimates");
            print(est);
          });

          String message = "";
          double comp = 0;
          comp += est;
          compMessage = " Your estimated total is R " + comp.toString() + ". ";
          if (comp < totBudget) {
            message = "Your Grocery List is within budget. ";
            comp = totBudget - comp;
            message += "You will have R " +
                comp.toString() +
                " remaining after shopping.";
          } else {
            comp = comp - totBudget;
            message = "You are " + comp.toString() + " over budget.";
          }
          setState(() {
            compMessage += message;
          });
          showAlertDialog(context);
        },
        child: Text("Compare to Grocery List"),
      );

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
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
