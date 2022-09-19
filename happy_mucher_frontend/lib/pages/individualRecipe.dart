import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/recipebook.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/ingredient_displaycard.dart';
import 'package:happy_mucher_frontend/recipeInstruction_card.dart';
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
  Color RRgreen = Color(0xFFACFF4E);
  Color VSpurple = Color.fromARGB(255, 168, 76, 184);
  Color crPurple = Color(0xFF965BC8);

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
    print(widget.instructions);
    for (int i = 0; i < widget.ingredients.length; i++) {
      ing += "\u2022  " + widget.ingredients[i] + '\n';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: offWhite,
        title: Text(widget.name,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: offWhite, fontSize: 25)),
        // centerTitle: true,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 168, 76, 184)),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print(widget.id);
            },
            icon: Icon(Icons.favorite),
            color: Color.fromARGB(255, 83, 61, 207),
          )
        ],
      ),
      backgroundColor: darkGrey,
      body: ListView(padding: const EdgeInsets.all(32), children: [
        //const SizedBox(height: 12),
        Text(widget.name,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: offWhite, fontSize: 25)),
        const SizedBox(height: 12),
        Image(image: NetworkImage(widget.image)),
        //const SizedBox(height: 24),
        if (widget.description != "") Description(),
        const SizedBox(height: 24),
        Container(
            padding: const EdgeInsets.all(15),
            //color: lightGrey,
            decoration: BoxDecoration(
                border: Border.all(color: llGrey), color: lightGrey),
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
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        //Text(ing),

        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              return ingredientCard(ingredient: widget.ingredients[index]);
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
              primary: lightGrey,
              side: BorderSide(
                  width: 2, // the thickness
                  color: lightGrey // the color of the border
                  )),
        ),
        const SizedBox(height: 24),
        Text(
          "Instructions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: offWhite,
          ),
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

  Widget Description() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 24),
        Text(
          "Description",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: offWhite,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: llGrey), color: lightGrey),
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
}
