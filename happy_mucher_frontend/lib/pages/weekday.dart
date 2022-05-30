import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Month extends StatefulWidget {
  const Month({Key? key, required this.month}) : super(key: key);
  final String month;
  @override
  State<Month> createState() => MyMonthState();
}

class MyMonthState extends State<Month> {
  @override
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
        Text("French Toast"),
        const SizedBox(height: 10),
        Text("Ingredients:"),
        Text("Bread, Eggs, Paprika, oil,sauce"),
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
        Text("Burger"),
        const SizedBox(height: 10),
        Text("Ingredients:"),
        Text("Buns, Patty, lettuce, tomato,sauce"),
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
        Text("Burritto"),
        const SizedBox(height: 10),
        Text("Ingredients:"),
        Text("Tortilla, Meat, sauce"),
      ]));
}
