import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_inventory.dialog.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/dialogs/add_ingredient_dialog.dart';
import 'package:happy_mucher_frontend/ingredientlist_widget.dart';
import 'package:happy_mucher_frontend/componentcard.dart';

//import 'package:http/http.dart' as http;

class Create extends StatefulWidget {
  Create({Key? key}) : super(key: key);
  @override
  State<Create> createState() => CreateState();
}

class CreateState extends State<Create> {
  //Recipe recipe = Recipe();
  myRecipe recipe = myRecipe(name: '');
  String title = "my Recipe";
  int selectedIndex = 0;
  static List<String> ingredients = [];
  // final tabs = [
  //   IngredientListWidget(
  //     ingredient: ingredients,
  //   ),
  //   Column(
  //     children: [
  //       IconButton(
  //           onPressed: () {
  //             print(ingredients[0]);
  //           },
  //           icon: Icon(Icons.search))
  //     ],
  //   ),
  // ];
  bool ingEdit = false;

  final ingController = TextEditingController();
  //final List<String> ingredients = <String>[];
  final titleController = TextEditingController();
  final cooktimeController = TextEditingController();
  final caloriesController = TextEditingController();
  final preptimeController = TextEditingController();

  String cookTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create Recipe'),
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              recipe = myRecipe(
                name: title,
                //navigate back to other page
              );
            },
            child: Text("Done"),
          ),
          backgroundColor: Color.fromARGB(255, 252, 95, 13)),

      body: Column(
        children: [
          Text('Enter your Recipe Title ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),

          TextField(
              key: Key("enterTitle"),
              controller: titleController,
              decoration: const InputDecoration(
                hintText: ('Title'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                title = titleController.text;
                print(title);
              })
              // autofocus: true,
              ),
          Text('Enter your Ingredients ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: ingredients.map((String item) {
                return ComponentCard(
                  ingredient: item,
                );
              }).toList(),
            ),
          ),
          // ListView(
          //   padding: EdgeInsets.symmetric(vertical: 8.0),
          //   children: ingredients.map((String item) {
          //     return ComponentCard(
          //       ingredient: item,
          //     );
          //   }).toList(),
          // ),

          FloatingActionButton(
            heroTag: "ingbutton",
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddIngredientDialog(
                  ingredients: ingredients,
                );
              },

              //useRootNavigator: true,
            ),
            child: Icon(Icons.add),
          ),
          Text('Enter your Instructions ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          FloatingActionButton(
            heroTag: "insbutton",
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddIngredientDialog(
                  ingredients: ingredients,
                );
              },

              //useRootNavigator: true,
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
      // StreamBuilder(builder: (context, snapshot) {
      //   return ListView.builder(
      //     itemCount: ingredients.length,
      //     itemBuilder: (context, index) {
      //       return ComponentCard(
      //         ingredient: ingredients[index],
      //       );
      //     },
      //   );
      // }),

      // ListView.builder(
      //   itemCount: ingredients.length,
      //   itemBuilder: (context, index) {
      //     return IngredientListWidget(
      //       ingredient: ingredients[index],
      //     );
      //   },
      // ),
      //tabs[selectedIndex],
      //Column(
      //   children: [

      //     //IngredientListWidget(),

      //     // IconButton(
      //     //     onPressed: () {
      //     //       print(ingredients);
      //     //     },
      //     //     icon: Icon(Icons.search))
      //   ],
      // ),
      // floatingActionButton:
      // FloatingActionButton(
      //   onPressed: () => showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AddIngredientDialog(
      //         ingredients: ingredients,
      //       );
      //     },

      //     //useRootNavigator: true,
      //   ),
      //   child: Icon(Icons.add),
      // ),

      // FloatingActionButton(
      //   onPressed: () {},r
      //   child: Icon(Icons.add)
      // ),
    );
    // Column(
    //   children: [
    //     Text("Ingredients"),
    //     Flexible(
    //         child: !ingEdit
    //             ? Text(ingredients)
    //             : TextField(
    //                 textAlign: TextAlign.left,
    //                 controller: ingController,
    //                 textInputAction: TextInputAction.done,
    //                 onSubmitted: (value) {
    //                   setState(() {
    //                     ingredients = ingController.text;
    //                   });
    //                   ingEdit = false;
    //                 })),
    //     IconButton(
    //       alignment: Alignment.bottomRight,
    //       //color: Colors.green,
    //       //hoverColor: Colors.green,
    //       icon: Icon(Icons.edit),
    //       onPressed: () {
    //         setState(() => {
    //               ingEdit = true,
    //             });
    //       },
    //     ),
    //   ],
    // ));
  }
}
