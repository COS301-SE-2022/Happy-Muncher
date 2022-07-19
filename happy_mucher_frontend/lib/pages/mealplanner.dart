import 'package:flutter/material.dart';
import 'weekday.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          key: Key("days"),
          children: <Widget>[
            //Mon
            ElevatedButton(
              key: Key("mon"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Monday"),
                ));
              },
              child: const Text("Monday"),
            ),

            //Tue
            ElevatedButton(
              key: Key("tue"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Tuesday"),
                ));
              },
              child: const Text("Tuesday"),
            ),

            //Wed
            ElevatedButton(
              key: Key("wed"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Wednesday"),
                ));
              },
              child: const Text("Wednesday"),
            ),

            //Thurs
            ElevatedButton(
              key: Key("thu"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Thursday"),
                ));
              },
              child: const Text("Thursday"),
            ),

            //Fri
            ElevatedButton(
              key: Key("fri"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Friday"),
                ));
              },
              child: const Text("Friday"),
            ),

            //Sat
            ElevatedButton(
              key: Key("sat"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Saturday"),
                ));
              },
              child: const Text("Saturday"),
            ),

            //Sun
            ElevatedButton(
              key: Key("sun"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Weekday(day: "Sunday"),
                ));
              },
              child: const Text("Sunday"),
            ),
          ],
        ));
  }
}
