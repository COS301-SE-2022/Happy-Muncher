import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/createRecipe.dart';
//import 'package:http/http.dart' as http;

class MyRecipeBook extends StatefulWidget {
  MyRecipeBook({Key? key}) : super(key: key);
  @override
  State<MyRecipeBook> createState() => MyRecipeBookState();
}

class MyRecipeBookState extends State<MyRecipeBook> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Grocery List'),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 252, 95, 13)),
        body: Column(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Create()));
                },
                icon: Icon(Icons.add))
          ],
        ));
  }
}
