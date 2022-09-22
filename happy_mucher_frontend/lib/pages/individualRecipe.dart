import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

//search resource:
//https://medium.com/@nishkarsh.makhija/implementing-searchable-list-view-in-flutter-using-data-from-network-d3aefffbd964
class IndividualRecipe extends StatefulWidget {
  const IndividualRecipe(
      {Key? key,
      this.recipe,
      this.description = "",
      this.name = "",
      this.image = '',
      this.calories = 0.0,
      this.ingredients = const [""],
      this.cookTime = "0",
      this.instructions = const ['']})
      : super(key: key);
  final List<Recipe>? recipe;
  final String description;
  final String name;
  final String image;
  final double calories;
  final List<String> ingredients;
  final List<String> instructions;
  final String cookTime;
  @override
  State<IndividualRecipe> createState() => IndividualRecipeState();
}

class IndividualRecipeState extends State<IndividualRecipe> {
  final FirebaseFirestore firestore = GetIt.I.get();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _glItems =>
      firestore.collection('Users').doc(uid).collection('GroceryList');
  String ing = "";
  String steps = "";
  String its = '';
  String donts = '';

  List<String> inventory = [];

  List<String> items = [];

  List<String> gl = [];
  getInventory() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Inventory')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print(doc["itemName"]);
        inventory.add(doc["itemName"]);
        //print(inventory);
      });
    });
  }

  @override
  void initState() {
    //
    super.initState();
    getInventory();
    for (int i = 0; i < widget.instructions.length; i++) {
      int x = i + 1;

      steps += x.toString() + ". " + widget.instructions[i] + '\n\n';
    }
    for (int i = 0; i < widget.ingredients.length; i++) {
      ing += "\u2022  " + widget.ingredients[i] + '\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, widget.name),
      body: ListView(padding: const EdgeInsets.all(32), children: [
        Image(image: NetworkImage(widget.image)),
        const SizedBox(height: 24),
        Text("description", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(widget.description),
        const SizedBox(height: 24),
        Text(
          "Calories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.calories.toString()),
        const SizedBox(height: 24),
        Text(
          "Cook Time",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(widget.cookTime + " mins"),
        const SizedBox(height: 24),
        Text(
          "Ingredients",
          style: TextStyle(fontWeight: FontWeight.bold),
          key: Key('ingredients'),
        ),
        Text(ing),
        ElevatedButton(
            onPressed: () {
              CompareInventory();
            },
            child: const Text("Compare to Inventory")),
        const SizedBox(height: 24),
        Text(
          "Instructions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(steps),
      ]),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget glButton = TextButton(
      child: Text("Add missing ingredients to Grocery List"),
      onPressed: () {
        toGL();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("these items are in your inventory "),
      content: Text(its),
      actions: [
        okButton,
        glButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  CompareInventory() {
    //its = "";
    items = [];
    its = '';
    donts = '';

    for (int j = 0; j < widget.ingredients.length; j++) {
      for (int i = 0; i < inventory.length; i++) {
        if (!items.contains(widget.ingredients[j])) {
          if (widget.ingredients[j].contains(inventory[i])) {
            its += "\u2713 " + widget.ingredients[j] + '\n';
            items.add(widget.ingredients[j]);
          }
        }
      }
      if (!items.contains(widget.ingredients[j])) {
        //donts.add(widget.ingredients[j]);
        its += "\u2715 " + widget.ingredients[j] + '\n';
        gl.add(widget.ingredients[j]);
      }
    }

    setState(() {
      showAlertDialog(context);
    });

    //"\u2705" - green tick
    //\u2713 - plain tick
    // 1F5F4  -ballot
    //\u2715  multiplication x
  }

  toGL() async {
    gl.forEach((element) async {
      await _glItems.add({"name": element, "price": 0.0, "bought": false});
    });
  }
}
