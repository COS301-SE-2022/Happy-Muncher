import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String ing = "";
  String steps = "";

  List<String> inventory = [];
  
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
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
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
        ),
        Text(ing),
        const SizedBox(height: 24),
        Text(
          "Instructions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(steps),
      ]),
    );
  }
}
