import 'package:flutter/material.dart';
import 'month.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const Budget());
}

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
                  builder: (context) => const Month(month: "January 2022"),
                ));
              },
              child: const Text("January 2022"),
            ),

            //Feb
            ElevatedButton(
              key: Key("feb"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "February 2022"),
                ));
              },
              child: const Text("February 2022"),
            ),

            //March
            ElevatedButton(
              key: Key("mar"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "March 2022"),
                ));
              },
              child: const Text("March 2022"),
            ),

            //April
            ElevatedButton(
              key: Key("apr"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "April 2022"),
                ));
              },
              child: const Text("April 2022"),
            ),

            //May
            ElevatedButton(
              key: Key("may"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "May 2022"),
                ));
              },
              child: const Text("May 2022"),
            ),

            //June
            ElevatedButton(
              key: Key("jun"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "June 2022"),
                ));
              },
              child: const Text("June 2022"),
            ),

            //July
            ElevatedButton(
              key: Key("jul"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "July 2022"),
                ));
              },
              child: const Text("July 2022"),
            ),

            //August
            ElevatedButton(
              key: Key("aug"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "August 2022"),
                ));
              },
              child: const Text("August 2022"),
            ),

            //September
            ElevatedButton(
              key: Key("sept"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "September 2022"),
                ));
              },
              child: const Text("September 2022"),
            ),

            //October
            ElevatedButton(
              key: Key("oct"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "October 2022"),
                ));
              },
              child: const Text("October 2022"),
            ),

            //November
            ElevatedButton(
              key: Key("nov"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "November 2022"),
                ));
              },
              child: const Text("November 2022"),
            ),

            //December
            ElevatedButton(
              key: Key("dec"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "December 2022"),
                ));
              },
              child: const Text("December 2022"),
            ),
          ],
        ));
  }
}
