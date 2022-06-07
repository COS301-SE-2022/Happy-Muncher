import 'package:flutter/material.dart';

void main() {
  runApp(const Profile());
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BudgetPage(title: 'Profile'),
    );
  }
}

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: ListView(
          key: Key("profile"),
          children: <Widget>[
            Icon(
              Icons.person_rounded,
              color: Colors.black,
              size: 70.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            ElevatedButton(
              key: Key("history"),
              onPressed: () {},
              child: const Text("Spending History"),
            ),
          ],
        ));
  }
}
