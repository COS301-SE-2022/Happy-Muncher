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
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
            child: const Text("Done"),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 95, 13)),
      body: Column(
        children: [
          const Text('Enter your Recipe Title ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          TextField(
              key: const Key("enterTitle"),
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
          const Text('Enter your Ingredients ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: ingredients.map((String item) {
                return ComponentCard(
                  ingredient: item,
                );
              }).toList(),
            ),
          ),
          SpeedDial(
            key: const Key('speed_dial_button'),
            icon: Icons.add,
            children: [
              SpeedDialChild(
                onTap: () => {},
                key: const Key('addToInventoryButtonText'),
                child: const Icon(
                  Icons.abc,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              ),
              SpeedDialChild(
                key: const Key('addToInventoryButtonGallery'),
                onTap: () async {},
                child: const Icon(
                  Icons.collections,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              ),
              SpeedDialChild(
                key: const Key('addToInventoryButtonCamera'),
                onTap: () async {},
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              )
            ],
          ),
          const Text('Enter your Instructions ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          SpeedDial(
            //key: const Key('speed_dial_button'),
            icon: Icons.add,
            children: [
              SpeedDialChild(
                onTap: () => {},
                //key: const Key('addToInventoryButtonText'),
                child: const Icon(
                  Icons.abc,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              ),
              SpeedDialChild(
                //key: const Key('addToInventoryButtonGallery'),
                onTap: () async {},
                child: const Icon(
                  Icons.collections,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              ),
              SpeedDialChild(
                //key: const Key('addToInventoryButtonCamera'),
                onTap: () async {},
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 172, 255, 78),
              )
            ],
          ),
        ],
      ),
    );
  }
}
