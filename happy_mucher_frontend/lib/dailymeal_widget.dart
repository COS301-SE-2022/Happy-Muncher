import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealWidget extends StatefulWidget {
  const MealWidget({Key? key, required this.day, required this.meal})
      : super(key: key);
  final String day;
  final String meal;
  @override
  State<MealWidget> createState() => MealWidgetState();
}

class MealWidgetState extends State<MealWidget> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _meals =>
      firestore.collection('Users').doc(uid).collection('Meal Planner');
  String image = '';
  String title = 'Add recipe from recipe book';
  String cookTime = '';
  int calories = 0;
  String description = '';
  String ing = '';
  String instr = '';
  List<String> instructions = [];
  List<String> ingredients = [];
  //breafast controoller
  bool hasrecipe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMeals();
    print("Description");
    print(description);
  }

  @override
  Widget build(BuildContext context) {
    return Meal();
  }

  Future<void> getMeals() async {
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Meal Planner');
    var docSnapshot = await collection
        .doc(widget.day)
        .collection(widget.meal)
        .doc('Recipe')
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      // You can then retrieve the value from the Map like this:

      image = data['ImageURL'];
      ing = data['Ingredients'];
      title = data['Name'];
      cookTime = data['CookTime'];
      description = data['Description'];
      calories = data['Calories'];
      instr = data['Instructions'];
      print(title);
    }

    var docSnapshot2 = await collection
        .doc(widget.day)
        .collection(widget.meal)
        .doc('hasRecipe')
        .get();
    if (docSnapshot2.exists) {
      Map<String, dynamic> data = docSnapshot2.data()!;

      // You can then retrieve the value from the Map like this:

      hasrecipe = data['has'];
    }
    if (mounted) {
      setState(() {
        ingredients = (ing.split('\n'));
        instructions = (instr.split('\n'));
        print(title);
      });
    }

    //print(tr);
  }

  Widget Meal() {
    return Container(
        // width: 200,
        height: 400,
        child: Card(
            //shadowColor: Color.fromARGB(255, 180, 181, 179),
            elevation: 25,
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //surfaceTintColor: Colors.grey,
            child: Column(children: [
              Container(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Center(
                    child: Text(
                      widget.meal,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TastyRecipeCard(
                name: title,
                totTime: cookTime,
                calories: 0,
                images: image,
                description: description,
                ingredients: ingredients,
                instructions: instructions,
              ),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Flexible(
              //       child: !editOne
              //           ? Text(meal1)
              //           : TextField(
              //               key: Key("meal1"),
              //               textAlign: TextAlign.center,
              //               controller: breakfastController,
              //               decoration: const InputDecoration(
              //                 hintText: 'Enter your meal',
              //               ),
              //               keyboardType: TextInputType.text,
              //               textInputAction: TextInputAction.done,
              //               onSubmitted: (value) {
              //                 setState(() {
              //                   meal1 = breakfastController.text;
              //                   editOne = false;
              //                 });
              //               },
              //             )),
              // ]),
              const SizedBox(height: 10),
              IconButton(
                alignment: Alignment.center,
                //color: Colors.green,
                //hoverColor: Colors.green,
                icon: !hasrecipe ? Icon(Icons.add_circle) : Icon(Icons.delete),
                iconSize: 44.0,
                onPressed: () async {
                  if (hasrecipe == false) {
                    var collection = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(uid)
                        .collection('Meal Planner');
                    var docSnapshot =
                        await collection.doc('Place Holder').get();
                    if (docSnapshot.exists) {
                      Map<String, dynamic> data = docSnapshot.data()!;

                      // You can then retrieve the value from the Map like this:
                      image = data['Image'];
                      ing = data['Ingredients'];
                      title = data['Name'];
                      cookTime = data['CookTime'];
                      description = data['Description'];
                      calories = data['Calories'];
                      instr = data['Instructions'];
                    }
                    ingredients = (ing.split('\n'));
                    instructions = (instr.split('\n'));
                    //print(instr);
                    _meals
                        .doc(widget.day)
                        .collection(widget.meal)
                        .doc('Recipe')
                        .set({
                      'Name': title,
                      'Instructions': instr,
                      'Description': description,
                      'Calories': calories,
                      'CookTime': cookTime,
                      'ImageURL': image,
                      'Ingredients': ing,
                    });
                    hasrecipe = true;
                    _meals
                        .doc(widget.day)
                        .collection(widget.meal)
                        .doc('hasRecipe')
                        .set({
                      'has': hasrecipe,
                      'Name': 'add recipe from recipe book'
                    });
                    //print(ingrd[0]); // return ["one"
                    //ingredients.addAll(ing);
                    getMeals();
                    setState(() => {
                          //editOne = true,
                        });
                  }
                  //to remove recipe
                  else {
                    ingredients = (ing.split('\n'));
                    instructions = (instr.split('\n'));
                    //print(instr);
                    _meals
                        .doc(widget.day)
                        .collection(widget.meal)
                        .doc('Recipe')
                        .set({
                      'Name': "add recipe from recipe book",
                      'Instructions': "none",
                      'Description': "none",
                      'Calories': 0,
                      'CookTime': "none",
                      'ImageURL': "",
                      'Ingredients': "none",
                    });
                    hasrecipe = false;
                    _meals
                        .doc(widget.day)
                        .collection(widget.meal)
                        .doc('hasRecipe')
                        .set({
                      'has': hasrecipe,
                      'Name': 'add recipe from recipe book'
                    });
                    //print(ingrd[0]); // return ["one"
                    //ingredients.addAll(ing);
                    getMeals();
                    setState(() => {
                          //editOne = false,
                        });
                  }
                },
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
            ])));
  }
}
