import 'package:flutter/material.dart';
import 'navbar.dart';
import 'weekday.dart';
import 'package:happy_mucher_frontend/weekcard_widget.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Meal Planner'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        body: ListView(
          key: Key("day"),
          children: <Widget>[
            const SizedBox(height: 10),
            WeekCard(
              day: "Monday",
              inputText: "Monday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Tuesday",
              inputText: "Tuesday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Wednesday",
              inputText: "Wednesday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Thursday",
              inputText: "Thursday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Friday",
              inputText: "Friday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Saturday",
              inputText: "Saturday",
            ),
            const SizedBox(height: 5),
            WeekCard(
              day: "Sunday",
              inputText: "Sunday",
            ),
            const SizedBox(height: 5),
          ],
        ));
  }
}
