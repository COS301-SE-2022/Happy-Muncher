import 'package:flutter/material.dart';

class Month extends StatefulWidget {
  const Month({Key? key, required this.month}) : super(key: key);
  final String month;
  @override
  State<Month> createState() => MyMonthState();
}

class MyMonthState extends State<Month> {
  //static const IconData money = IconData(0xe3f8, fontFamily: 'MaterialIcons');
  final budgetController = TextEditingController();

  double bud = 0;
  String input = "0";
  String budget = "";
  double totRem = 0;
  double totSpent = 0;

  //variables for week 1
  final spentOneController = TextEditingController();
  String spent1 = "0.0";
  String rem1 = "0";
  bool editOne = false;

  //variables for week 2
  final spentTwoController = TextEditingController();
  String spent2 = "0.0";
  String rem2 = "0";

  //variables for week 3
  final spentThreeController = TextEditingController();
  String spent3 = "0.0";
  String rem3 = "0";

  //variables for week 4
  final spentFourController = TextEditingController();
  String spent4 = "0.0";
  String rem4 = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('${widget.month}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          Text('Enter Your budget for ' + '${widget.month}',
              style: TextStyle(height: 1.2)),
          enterBudget(),
          MaterialButton(
            key: Key("setBudget"),
            onPressed: () {
              setState(() {
                input = budgetController.text;
                bud = double.parse(input);
                totRem = bud;
                bud = bud / 4;
                budget = bud.toString();

                totSpent = 0;
                rem1 = budget;
                rem2 = budget;
                rem3 = budget;
                rem4 = budget;
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
          Totals()
        ],
      ),
    );
  }

  Widget enterBudget() => TextField(
        key: Key("enterBudget"),
        controller: budgetController,
        decoration: const InputDecoration(
          hintText: 'R',
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
            children: [const Text("Budget"), Text("R " + budget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
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
                          left = bud - left;
                          rem1 = left.toString();
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
            children: [const Text("Budget"), Text("R" + budget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: TextField(
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
              });
            },
          ))
        ]),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text("R " + rem2)]),
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
            children: [const Text("Budget"), Text("R" + budget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: TextField(
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
              });
            },
          ))
        ]),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text("R " + rem3)]),
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
            children: [const Text("Budget"), Text("R" + budget)]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Amount Spent"),
          Flexible(
              child: TextField(
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
              });
            },
          ))
        ]),
        const SizedBox(height: 10),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Amount Remaining"), Text(rem4)]),
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
}
