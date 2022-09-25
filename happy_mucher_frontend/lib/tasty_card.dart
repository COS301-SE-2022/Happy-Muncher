import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/pages/individualRecipe.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:happy_mucher_frontend/dialogs/add_recipe.dialog.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TastyRecipeCard extends StatelessWidget {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final String name;
  final String images;
  final int recipeid;
  final String totTime;
  final String description;
  final int calories;
  final List<String> ingredients;
  final List<String> instructions;
  //List<Recipe>? recipes;
  TastyRecipeCard(
      {this.name = "",
      this.images = "",
      this.recipeid = 0,
      this.totTime = "",
      this.description = "",
      this.calories = 0,
      this.ingredients = const [''],
      this.instructions = const ['']});

  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _meals =>
      firestore.collection('Users').doc(uid).collection('Meal Planner');

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('recipeCard'),
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(images),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                name,
                style: TextStyle(fontSize: 19, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        calories.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        totTime,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: SpeedDial(
              key: const Key('dots'),
              direction: SpeedDialDirection.down,
              icon: Icons.more_vert,
              backgroundColor: Color.fromARGB(255, 150, 66, 154),
              buttonSize: const Size(45.0, 45.0),
              children: [
                SpeedDialChild(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => IndividualRecipe(
                      name: name,
                      description: description,
                      image: images,
                      id: recipeid,
                      ingredients: ingredients,
                      cookTime: totTime,
                      calories: calories.toDouble(),
                      instructions: instructions,
                    ),
                  )),
                  key: const Key('info'),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color.fromARGB(255, 150, 66, 154),
                  ),
                  backgroundColor: Color.fromARGB(100, 150, 66, 154),
                ),
                SpeedDialChild(
                  onTap: () => showAlertDialog(context),
                  key: const Key('add'),
                  child: const Icon(
                    Icons.add,
                    color: Color.fromARGB(255, 150, 66, 154),
                  ),
                  backgroundColor: Color.fromARGB(100, 150, 66, 154),
                ),
              ],
            ),
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        String ing = "";
        ing = ingredients.join('\n');
        String instruc = "";
        instruc = instructions.join('\n');
        _meals.doc('Place Holder').set({
          'Name': name,
          'Instructions': instruc,
          'Description': description,
          'Calories': calories,
          'CookTime': totTime,
          'Image': images,
          'Ingredients': ing
        });
        Navigator.pop(context);
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MealPage(),
        ));
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
      key: Key('alert'),
      //title: Text("Compare Grocery List to Budget"),
      content: Text("Add " + '"' + name + '"' + " to your Meal Planner?"),
      actions: [yesButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
