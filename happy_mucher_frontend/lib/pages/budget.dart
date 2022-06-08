import 'package:flutter/material.dart';
import 'month.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(const Budget());
// }

class Budget extends StatelessWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Budget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          key: Key("months"),
          children: <Widget>[
            //Jan
            ElevatedButton(
              key: Key("jan"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "January"),
                ));
              },
              child: const Text("January "),
            ),

            //Feb
            ElevatedButton(
              key: Key("feb"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "February"),
                ));
              },
              child: const Text("February "),
            ),

            //March
            ElevatedButton(
              key: Key("mar"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "March"),
                ));
              },
              child: const Text("March "),
            ),

            //April
            ElevatedButton(
              key: Key("apr"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "April"),
                ));
              },
              child: const Text("April "),
            ),

            //May
            ElevatedButton(
              key: Key("may"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "May"),
                ));
              },
              child: const Text("May "),
            ),

            //June
            ElevatedButton(
              key: Key("jun"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "June"),
                ));
              },
              child: const Text("June "),
            ),

            //July
            ElevatedButton(
              key: Key("jul"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "July"),
                ));
              },
              child: const Text("July "),
            ),

            //August
            ElevatedButton(
              key: Key("aug"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "August"),
                ));
              },
              child: const Text("August "),
            ),

            //September
            ElevatedButton(
              key: Key("sept"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "September"),
                ));
              },
              child: const Text("September "),
            ),

            //October
            ElevatedButton(
              key: Key("oct"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "October"),
                ));
              },
              child: const Text("October "),
            ),

            //November
            ElevatedButton(
              key: Key("nov"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "November"),
                ));
              },
              child: const Text("November "),
            ),

            //December
            ElevatedButton(
              key: Key("dec"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "December"),
                ));
              },
              child: const Text("December "),
            ),
          ],
        ));
  }
}
