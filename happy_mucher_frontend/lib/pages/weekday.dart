import 'package:flutter/material.dart';

class Month extends StatefulWidget {
  const Month({Key? key, required this.month}) : super(key: key);
  final String month;
  @override
  State<Month> createState() => MyMonthState();
}

class MyMonthState extends State<Month> {
  @override
  final breakfastController = TextEditingController();
  String meal1 = "Enter your breakfast";
  bool editOne = false;

  final lunchController = TextEditingController();
  String meal2 = "Enter your lunch";
  bool editTwo = false;

  final dinnerController = TextEditingController();
  String meal3 = "Enter your dinner";
  bool editThree = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.month}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          const SizedBox(height: 24),
          Breakfast(),
          const SizedBox(height: 24),
          Lunch(),
          const SizedBox(height: 24),
          Dinner(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget Breakfast() => Container(
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
                'Breakfast',
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: !editOne
                  ? Text(meal1)
                  : TextField(
                      key: Key("meal1"),
                      textAlign: TextAlign.center,
                      controller: breakfastController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your meal',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {
                          meal1 = breakfastController.text;
                          editOne = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
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

  Widget Lunch() => Container(
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
                'Lunch',
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: !editTwo
                  ? Text(meal2)
                  : TextField(
                      key: Key("meal2"),
                      textAlign: TextAlign.center,
                      controller: lunchController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your meal',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {
                          meal2 = lunchController.text;
                          editTwo = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
      ]));

  Widget Dinner() => Container(
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
                'Dinner',
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: !editThree
                  ? Text(meal3)
                  : TextField(
                      key: Key("meal3"),
                      textAlign: TextAlign.center,
                      controller: dinnerController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your meal',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {
                          meal3 = dinnerController.text;
                          editThree = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
      ]));
}
