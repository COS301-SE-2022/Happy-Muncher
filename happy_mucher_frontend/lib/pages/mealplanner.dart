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
  Widget build(BuildContext context) => ListView(
        key: Key("day"),
        padding: EdgeInsets.all(16),
        children: [
          buildCards(),
          const SizedBox(height: 12),
          buildCards1(),
          const SizedBox(height: 12),
          buildCards2(),
          const SizedBox(height: 12),
          buildCards3(),
          const SizedBox(height: 12),
        ],
      );

  Widget buildCards() => Row(
        children: [
          Expanded(child: WeekCard(day: "Monday", inputText: "Mon")),
          const SizedBox(width: 12),
          Expanded(child: WeekCard(day: "Tuesday", inputText: "Tue")),
        ],
      );

  Widget buildCards1() => Row(
        children: [
          Expanded(child: WeekCard(day: "Wednesday", inputText: "Wed")),
          const SizedBox(width: 12),
          Expanded(child: WeekCard(day: "Thursday", inputText: "Thu")),
        ],
      );
  Widget buildCards2() => Row(
        children: [
          Expanded(child: WeekCard(day: "Friday", inputText: "Fri")),
          const SizedBox(width: 12),
          Expanded(child: WeekCard(day: "Saturday", inputText: "Sat")),
        ],
      );
  Widget buildCards3() => Row(
        children: [
          Expanded(child: WeekCard(day: "Sunday", inputText: "Sun")),
        ],
      );
}
