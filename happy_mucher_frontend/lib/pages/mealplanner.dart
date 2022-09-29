import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
import 'weekday.dart';
import 'package:happy_mucher_frontend/weekcard_widget.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  // var day = DateTime.now();
  var day = DateFormat('EEEE').format(DateTime.now());
  int initial = 0;
  @override
  void initState() {
    if (day == "Monday") {
      initial = 0;
    }
    if (day == "Tuesday") {
      initial = 1;
    }
    if (day == "Wednesday") {
      initial = 2;
    }
    if (day == "Thursday") {
      initial = 3;
    }
    if (day == "Friday") {
      initial = 4;
    }
    if (day == "Saturday") {
      initial = 5;
    }
    if (day == "Sunday") {
      initial = 6;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      key: Key("day"),
      appBar: buildAppBar(context, "Meal Planner"),
      body: SafeArea(
        //padding: const EdgeInsets.all(32),

        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: CarouselSlider(
                  options: CarouselOptions(
                      initialPage: initial,
                      aspectRatio: 0.5,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.vertical,
                      viewportFraction: 0.30), // required

                  items: <Widget>[
                    //Breakfast(),
                    buildCards(),
                    buildCards1(),
                    buildCards2(),
                    buildCards3(),
                    buildCards4(),
                    buildCards5(),
                    buildCards6(),
                    //MealWidget(day: widget.day, meal: "Breakfast"),
                    //const SizedBox(height: 24),
                    // MealWidget(day: widget.day, meal: "Lunch"),
                    // //const SizedBox(height: 24),
                    // MealWidget(day: widget.day, meal: "Supper"),
                  ],
                  //const SizedBox(height: 24) ], // required
                ),
              ),
            ),
          ],
        ),
      ));

  // body: ListView(
  //   padding: EdgeInsets.all(16),
  // children: [
  //   buildCards(),
  //   const SizedBox(height: 12),
  //   buildCards1(),
  //   const SizedBox(height: 12),
  //   buildCards2(),
  //   const SizedBox(height: 12),
  //   buildCards3(),
  //   const SizedBox(height: 12),
  // ],

  Widget buildCards() => Row(
        children: [
          Expanded(child: WeekCard(day: "Monday", inputText: "Monday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Tuesday", inputText: "Tue")),
        ],
      );

  Widget buildCards1() => Row(
        children: [
          Expanded(child: WeekCard(day: "Tuesday", inputText: "Tuesday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Thursday", inputText: "Thu")),
        ],
      );
  Widget buildCards2() => Row(
        children: [
          Expanded(child: WeekCard(day: "Wednesday", inputText: "Wednesday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Saturday", inputText: "Sat")),
        ],
      );
  Widget buildCards3() => Row(
        children: [
          Expanded(child: WeekCard(day: "Thursday", inputText: "Thursday")),
        ],
      );
  Widget buildCards4() => Row(
        children: [
          Expanded(child: WeekCard(day: "Friday", inputText: "Friday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Tuesday", inputText: "Tue")),
        ],
      );
  Widget buildCards5() => Row(
        children: [
          Expanded(child: WeekCard(day: "Saturday", inputText: "Saturday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Tuesday", inputText: "Tue")),
        ],
      );
  Widget buildCards6() => Row(
        children: [
          Expanded(child: WeekCard(day: "Sunday", inputText: "Sunday")),
          // const SizedBox(width: 12),
          // Expanded(child: WeekCard(day: "Tuesday", inputText: "Tue")),
        ],
      );
}
