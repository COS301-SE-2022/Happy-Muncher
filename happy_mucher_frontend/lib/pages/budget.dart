import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/monthcard_widget.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'month.dart';
import 'package:table_calendar/table_calendar.dart';

class MyBudget extends StatefulWidget {
  // const MyBudget({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  State<MyBudget> createState() => _MyBudgetState();
}

class _MyBudgetState extends State<MyBudget> {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  DateTime _focusedDay = DateTime.now();
  CalendarFormat format = CalendarFormat.month;
  String buttonValue = "";
  @override
  void initState() {
    print(_focusedDay);
    buttonValue = months[_focusedDay.month - 1];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: Key("months"),
      appBar: buildAppBar(context, "Budget"),
      body: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 150, 66, 154),
                shape: BoxShape.circle,
              ),
            ),
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2050),
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = CalendarFormat.month;
                //print(format);
                print(CalendarFormat.month.name);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              print(_focusedDay.month);
              setState(() {
                buttonValue = months[_focusedDay.month - 1];
              });
            },
          ),
          SizedBox(height: 150),
          MonthNav(buttonValue),
        ],
      ));
  //SizedBox(height: 32),
  Widget MonthNav(String month) => ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Month(month: month),
          ));
        },
        child: const Text("View budget"),
        style: ElevatedButton.styleFrom(
            onPrimary: Color.fromARGB(255, 150, 66, 154),
            padding: EdgeInsets.all(10.0),
            minimumSize: Size(300, 80),
            textStyle: const TextStyle(fontSize: 20),
            side: BorderSide(
                color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
      );
}
