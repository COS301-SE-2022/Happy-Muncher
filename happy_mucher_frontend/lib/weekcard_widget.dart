import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/weekday.dart';

class WeekCard extends StatefulWidget {
  const WeekCard({Key? key, required this.day, required this.inputText})
      : super(key: key);
  final String day;
  final String inputText;
  @override
  State<WeekCard> createState() => WeekCardState();
}

class WeekCardState extends State<WeekCard> {
  @override
  Widget build(BuildContext context) {
    return buildWeekcard();
  }

  Widget buildWeekcard() => Card(
      shadowColor: Color.fromARGB(255, 150, 66, 154),
      elevation: 25,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
            color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
      ),
      child: Stack(alignment: Alignment.center, children: [
        InkWell(
            key: Key(widget.day),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Weekday(day: widget.day),
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
                    color: Color.fromARGB(255, 150, 66, 154),
                    fontSize: 35,
                  ),
                ),
              ),
            ))
      ]));
}
