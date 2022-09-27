import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/ingredient_displaycard.dart';
import 'package:happy_mucher_frontend/recipeInstruction_card.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _favourites =>
      firestore.collection('Users').doc(uid).collection('Recipes');

  CollectionReference get _glItems =>
      firestore.collection('Users').doc(uid).collection('GroceryList');
  String ing = "";
  String steps = "";
  String its = '';
  String donts = '';

  Color llGrey = Color(0xFF555555);
  Color lightGrey = Color(0xFF2D2C31); //ingredients block
  Color darkGrey = Color(0xFF212025); //ingredients background
  Color mediumGrey = Color(0xFF39383D);
  Color offWhite = Color(0xFFDFDEE3);
  Color RRgreen = Color(0xFFACFF4E);
  Color VSpurple = Color.fromARGB(255, 168, 76, 184);
  Color crPurple = Color(0xFF965BC8);

  List<String> inventory = [];

  List<String> items = [];

  List<String> gl = [];
  getInventory() {
    firestore
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
    print(widget.instructions);
    for (int i = 0; i < widget.ingredients.length; i++) {
      ing += "\u2022  " + widget.ingredients[i] + '\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, widget.name),
      // centerTitle: true,
      body: ListView(padding: const EdgeInsets.all(32), children: [
        IconButton(
          onPressed: () async {
            final String id = widget.id.toString();
            if (id != null) {
              await _favourites.add({
                "ID": id,
              });
              showFavouritesDialog(context);
            }
          },
          alignment: Alignment.topRight,
          icon: Icon(Icons.favorite),
          color: Color.fromARGB(255, 150, 66, 154),
        ),

        //const SizedBox(height: 12),
        Text(widget.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 12),
        if (widget.image != "")
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image(
              image: NetworkImage(widget.image),
            ),
          ),
        //const SizedBox(height: 24),
        if (widget.description != "") Description(),
        const SizedBox(height: 24),
        Container(
            padding: const EdgeInsets.all(15),
            //color: lightGrey,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color.fromARGB(255, 150, 66, 154),
                  width: 3.0,
                )),
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
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.calories.toString(),
                      style: TextStyle(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Cook Time:  ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.cookTime + " mins",
                      style: TextStyle(),
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
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        //Text(ing),

        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              return ingredientCard(
                ingredient: widget.ingredients[index],
              );
            }),
        const SizedBox(height: 18),

        ElevatedButton(
          onPressed: () {
            CompareInventory();
          },
          child: Text(
            "Compare to Inventory",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: offWhite,
              fontSize: 18,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 150, 66, 154),
            shape: const StadiumBorder(),
            minimumSize: const Size(300, 50),
            onPrimary: Colors.white,
            side: const BorderSide(
                color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Instructions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),

        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.instructions.length,
            itemBuilder: (context, index) {
              return InstructionCard(
                instruction: widget.instructions[index],
                step: index,
              );
            }),
      ]),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      style: TextButton.styleFrom(
        primary: Color.fromARGB(255, 150, 66, 154),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget glButton = TextButton(
      style: TextButton.styleFrom(
        primary: Color.fromARGB(255, 150, 66, 154),
      ),
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

  Widget Description() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 24),
        Text(
          "Description",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Color.fromARGB(255, 150, 66, 154),
          )),
          padding: const EdgeInsets.all(15),
          //color: Color(0xFF2D2C31),
          //color: lightGrey,
          child: Text(
            widget.description,
            style: TextStyle(color: offWhite, fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(height: 24)
      ]);

  showFavouritesDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Liked!"),
      content: Text(widget.name + " has been added to your favourites"),
      actions: [
        okButton,
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
}
