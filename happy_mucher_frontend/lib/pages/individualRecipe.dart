import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//search resource:
//https://medium.com/@nishkarsh.makhija/implementing-searchable-list-view-in-flutter-using-data-from-network-d3aefffbd964
class IndividualRecipe extends StatefulWidget {
  const IndividualRecipe(
      {Key? key,
      this.id = 0,
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
  final int id;
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

  CollectionReference get _glItems => firestore.collection('GroceryList');
  String ing = "";
  String steps = "";
  String its = '';
  String donts = '';

  Color llGrey = Color(0xFF555555);
  Color lightGrey = Color(0xFF2D2C31); //ingredients block
  Color darkGrey = Color(0xFF212025); //ingredients background
  Color mediumGrey = Color(0xFF39383D);
  Color offWhite = Color(0xFFDFDEE3);

  List<String> inventory = [];

  List<String> items = [];

  List<String> gl = [];
  getInventory() {
    FirebaseFirestore.instance
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
    print(widget.ingredients);
    for (int i = 0; i < widget.ingredients.length; i++) {
      ing += "\u2022  " + widget.ingredients[i] + '\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.name),
        // centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print(widget.id);
              },
              icon: Icon(Icons.heart_broken))
        ],
      ),
      backgroundColor: darkGrey,
      body: ListView(padding: const EdgeInsets.all(32), children: [
        const SizedBox(height: 24),
        Text(widget.name,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: offWhite, fontSize: 25)),
        Image(image: NetworkImage(widget.image)),
        //const SizedBox(height: 24),

        const SizedBox(height: 24),
        Container(
            padding: const EdgeInsets.all(15),
            color: lightGrey,
            //Color(0xFF2D2C31),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Calories:  ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: offWhite,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.calories.toString(),
                      style: TextStyle(
                        color: offWhite,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Cook Time:  ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: offWhite,
                      ),
                    ),
                    Text(
                      widget.cookTime + " mins",
                      style: TextStyle(
                        color: offWhite,
                      ),
                    ),
                  ],
                )
              ],
            )),

        const SizedBox(height: 24),
        Text(
          "Ingredients",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: offWhite,
          ),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: offWhite,
          ),
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
      await _glItems.add({"name": element, "price": 0, "bought": false});
    });
  }
}
