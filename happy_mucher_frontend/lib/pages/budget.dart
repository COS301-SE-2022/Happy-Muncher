import 'package:flutter/material.dart';
import 'month.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          children: <Widget>[
            //Jan
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "January 2020"),
                ));
              },
              child: const Text("January 2020"),
            ),

            //Feb
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "February 2020"),
                ));
              },
              child: const Text("February 2020"),
            ),

            //March
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "March 2020"),
                ));
              },
              child: const Text("March 2020"),
            ),

            //April
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Month(month: "April 2020"),
                ));
              },
              child: const Text("April 2020"),
            ),

            // //May
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "May 2020"),
            //     ));
            //   },
            //   child: const Text("May 2020"),
            // ),

            // //June
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "June 2020"),
            //     ));
            //   },
            //   child: const Text("June 2020"),
            // ),

            // //July
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "July 2020"),
            //     ));
            //   },
            //   child: const Text("July 2020"),
            // ),

            // //August
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "August 2020"),
            //     ));
            //   },
            //   child: const Text("August 2020"),
            // ),

            // //September
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "September 2020"),
            //     ));
            //   },
            //   child: const Text("September 2020"),
            // ),

            // //October
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "October 2020"),
            //     ));
            //   },
            //   child: const Text("October 2020"),
            // ),

            // //November
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "November 2020"),
            //     ));
            //   },
            //   child: const Text("November 2020"),
            // ),

            // //December
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => const Month(month: "December 2020"),
            //     ));
            //   },
            //   child: const Text("December 2020"),
            // ),
          ],
        ));
  }
}
