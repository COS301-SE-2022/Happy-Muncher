import 'package:flutter/material.dart';
import 'navbar.dart';
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
      appBar: AppBar(
        title: const Text('Meal Planner'),
        centerTitle: true,
      ),
      drawer: NavBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            buildMoncard(),
            const SizedBox(height: 5),
            buildTuecard(),
            const SizedBox(height: 5),
            buildWedcard(),
            const SizedBox(height: 5),
            buildThurcard(),
            const SizedBox(height: 5),
            buildFricard(),
            const SizedBox(height: 5),
            buildSatcard(),
            const SizedBox(height: 5),
            buildSuncard(),
          ],
        ),
      ),
    );
  }

  Widget buildMoncard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/monday.jpg'),
              child: InkWell(
                key: Key("mon"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Monday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildTuecard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/tuesday.jpg'),
              child: InkWell(
                key: Key("tue"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Tuesday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildWedcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/wednesday.jpg'),
              child: InkWell(
                key: Key("wed"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Wednesday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildThurcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/thursday.jpg'),
              child: InkWell(
                key: Key("thu"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Thursday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildFricard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/friday.jpg'),
              child: InkWell(
                key: Key("fri"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Friday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildSatcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/saturday.jpg'),
              child: InkWell(
                key: Key("sat"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Saturday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildSuncard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/mealplanner/sunday.jpg'),
              child: InkWell(
                key: Key("sun"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Weekday(day: "Sunday"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );
}
