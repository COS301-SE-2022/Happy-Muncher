import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/monthcard_widget.dart';
import 'month.dart';

// void main() {
//   runApp(const Budget());
// }

class Budget extends StatelessWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Budget'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  Widget buildJancard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/months/january.jpg'),
              child: InkWell(
                key: Key("jan"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Month(month: "January"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildFebcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/months/february.jpg'),
              child: InkWell(
                key: Key("feb"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Month(month: "February"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildMarcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/months/march.jpg'),
              child: InkWell(
                key: Key("mar"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Month(month: "March"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildAprcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/months/april.jpg'),
              child: InkWell(
                key: Key("apr"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Month(month: "April"),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );

  Widget buildMaycard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage('assets/images/months/may.jpg'),
              child: InkWell(
                key: Key("may"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Month(month: "May"),
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
