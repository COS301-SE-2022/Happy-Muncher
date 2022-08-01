import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/month.dart';

class MonthCard extends StatefulWidget {
  const MonthCard({Key? key, required this.month, required this.inputText})
      : super(key: key);
  final String month;
  final String inputText;
  @override
  State<MonthCard> createState() => MonthCardState();
}

class MonthCardState extends State<MonthCard> {
  @override
  Widget build(BuildContext context) {
    return buildMonthcard();
  }

  Widget buildMonthcard() => Card(
      shadowColor: Color.fromARGB(255, 172, 255, 78),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            key: Key(widget.month),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Month(month: widget.month),
              ));
            },
            child: Container(
              height: 120,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  widget.inputText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 172, 255, 78),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
}
