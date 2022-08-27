import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<RecipeItemParams?> addRecipeDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const AddRecipe());
}

class AddRecipe extends StatefulWidget {
  const AddRecipe({
    Key? key,
  });

  @override
  State<AddRecipe> createState() => AddRecipeState();
}

class AddRecipeState extends State<AddRecipe> {
  final FirebaseFirestore firestore = GetIt.I.get();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference get _mealPlanner =>
      firestore.collection('Users').doc(uid).collection('Meal Planner');
  @override
  Widget build(BuildContext context) {
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Compare Grocery List to Budget"),
      content: Text("nn"),
      actions: [yesButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return alert;
  }
}

class RecipeItemParams {
  final String name;
  final String images;
  final int recipeid;
  final String totTime;
  final String description;
  final int calories;
  final List<String> ingredients;
  final List<String> instructions;
  RecipeItemParams(
      {this.name = "",
      this.images = "",
      this.recipeid = 0,
      this.totTime = "",
      this.description = "",
      this.calories = 0,
      this.ingredients = const [''],
      this.instructions = const ['']});
}
