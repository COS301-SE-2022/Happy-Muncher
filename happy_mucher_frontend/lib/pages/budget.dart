import 'package:flutter/material.dart';
import 'month.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          title: Text(widget.title),
        ),
        body: ListView(
          key: Key("months"),
          children: <Widget>[
            const SizedBox(height: 10),
            buildJancard(),
            const SizedBox(height: 5),
            buildFebcard(),
            const SizedBox(height: 5),
            buildMarcard(),
            const SizedBox(height: 5),
            buildAprcard(),
            const SizedBox(height: 5),
            buildMaycard(),
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
