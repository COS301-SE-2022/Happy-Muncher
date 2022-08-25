import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/monthcard_widget.dart';
import 'month.dart';

class MyBudget extends StatefulWidget {
  // const MyBudget({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  State<MyBudget> createState() => _MyBudgetState();
}

class _MyBudgetState extends State<MyBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Budget'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        body: ListView(
          key: Key("months"),
          children: <Widget>[
            const SizedBox(height: 10),
            MonthCard(
              month: "January",
              inputText: "January",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "February",
              inputText: "February",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "March",
              inputText: "March",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "April",
              inputText: "April",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "May",
              inputText: "May",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "June",
              inputText: "June",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "July",
              inputText: "July",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "August",
              inputText: "August",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "September",
              inputText: "September",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "October",
              inputText: "October",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "November",
              inputText: "November",
            ),
            const SizedBox(height: 5),
            MonthCard(
              month: "December",
              inputText: "December",
            ),
            const SizedBox(height: 5),
          ],
        ));
  }
}
