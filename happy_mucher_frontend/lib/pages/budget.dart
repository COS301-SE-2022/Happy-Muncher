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
          MonthNav(buttonValue)
        ],
      )
      // ListView(
      //   padding: EdgeInsets.all(16),
      //   children: [
      //     buildCards(),
      //     const SizedBox(height: 12),
      //     buildCards1(),
      //     const SizedBox(height: 12),
      //     buildCards2(),
      //     const SizedBox(height: 12),
      //     buildCards3(),
      //     const SizedBox(height: 12),
      //     buildCards4(),
      //     const SizedBox(height: 12),
      //     buildCards5(),
      //   ],
      // )
      );

  Widget buildCards() => Row(
        children: [
          Expanded(child: MonthCard(month: "January", inputText: "Jan")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "February", inputText: "Feb")),
        ],
      );

  Widget buildCards1() => Row(
        children: [
          Expanded(child: MonthCard(month: "March", inputText: "Mar")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "April", inputText: "Apr")),
        ],
      );

  Widget buildCards2() => Row(
        children: [
          Expanded(child: MonthCard(month: "May", inputText: "May")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "June", inputText: "Jun")),
        ],
      );

  Widget buildCards3() => Row(
        children: [
          Expanded(child: MonthCard(month: "July", inputText: "Jul")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "August", inputText: "Aug")),
        ],
      );

  Widget buildCards4() => Row(
        children: [
          Expanded(child: MonthCard(month: "September", inputText: "Sep")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "October", inputText: "Oct")),
        ],
      );

  Widget buildCards5() => Row(
        children: [
          Expanded(child: MonthCard(month: "November", inputText: "Nov")),
          const SizedBox(width: 12),
          Expanded(child: MonthCard(month: "December", inputText: "Dec")),
        ],
      );

  Widget MonthNav(String month) => ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Month(month: month),
        ));
      },
      child: Text(month));
}
