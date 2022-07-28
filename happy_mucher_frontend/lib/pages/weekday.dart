import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/dailymeal_widget.dart';

class Weekday extends StatefulWidget {
  const Weekday({Key? key, required this.day}) : super(key: key);
  final String day;
  @override
  State<Weekday> createState() => MyWeekdayState();
}

class MyWeekdayState extends State<Weekday> {
  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _meals => firestore.collection('Meal Planner');
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

  Future<void> getMeals() async {
    var collection = FirebaseFirestore.instance.collection('Meal Planner');
    var docSnapshot = await collection
        .doc(widget.day)
        .collection('Breakfast')
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
      print(image);
    }

    var docSnapshot2 = await collection
        .doc(widget.day)
        .collection('Breakfast')
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
        print(image);
      });
    }

    //print(tr);
  }

  final breakfastController = TextEditingController();
  String meal1 = "Enter your breakfast";
  bool editOne = false;

  final lunchController = TextEditingController();
  String meal2 = "Enter your lunch";
  bool editTwo = false;

  final dinnerController = TextEditingController();
  String meal3 = "Enter your dinner";
  bool editThree = false;

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => getMeals(context));
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.day}'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 95, 13),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          const SizedBox(height: 24),
          //Breakfast(),
          MealWidget(day: widget.day, meal: "Breakfast"),
          const SizedBox(height: 24),
          MealWidget(day: widget.day, meal: "Lunch"),
          const SizedBox(height: 24),
          MealWidget(day: widget.day, meal: "Supper"),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget Breakfast() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 172, 255, 78)),
            child: const Center(
              child: Text(
                'Breakfast',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
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
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: !hasrecipe ? Icon(Icons.add_circle) : Icon(Icons.delete),
          iconSize: 44.0,
          onPressed: () async {
            if (hasrecipe == false) {
              var collection =
                  FirebaseFirestore.instance.collection('Meal Planner');
              var docSnapshot = await collection.doc('Place Holder').get();
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
                  .collection('Breakfast')
                  .doc('Recipe')
                  .update({
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
                  .collection('Breakfast')
                  .doc('hasRecipe')
                  .update({
                'has': hasrecipe,
              });
              //print(ingrd[0]); // return ["one"
              //ingredients.addAll(ing);
              getMeals();
              setState(() => {
                    editOne = true,
                  });
            }
            //to remove recipe
            else {
              ingredients = (ing.split('\n'));
              instructions = (instr.split('\n'));
              //print(instr);
              _meals
                  .doc(widget.day)
                  .collection('Breakfast')
                  .doc('Recipe')
                  .update({
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
                  .collection('Breakfast')
                  .doc('hasRecipe')
                  .update({
                'has': hasrecipe,
              });
              //print(ingrd[0]); // return ["one"
              //ingredients.addAll(ing);
              getMeals();
              setState(() => {
                    editOne = false,
                  });
            }
          },
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ]));

  Widget Lunch() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 172, 255, 78)),
            child: const Center(
              child: Text(
                'Lunch',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: !editTwo
                  ? Text(meal2)
                  : TextField(
                      key: Key("meal2"),
                      textAlign: TextAlign.center,
                      controller: lunchController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your meal',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {
                          meal2 = lunchController.text;
                          editTwo = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.add_circle),
          iconSize: 44.0,
          onPressed: () {
            setState(() => {
                  editTwo = true,
                });
          },
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ]));

  Widget Dinner() => Container(
          child: Column(children: [
        Container(
          child: Container(
            width: 600.0,
            height: 42.0,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 172, 255, 78)),
            child: const Center(
              child: Text(
                'Dinner',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18,
                  color: Colors.white,
                  height: 1,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: !editThree
                  ? Text(meal3)
                  : TextField(
                      key: Key("meal3"),
                      textAlign: TextAlign.center,
                      controller: dinnerController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your meal',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        setState(() {
                          meal3 = dinnerController.text;
                          editThree = false;
                        });
                      },
                    )),
        ]),
        const SizedBox(height: 10),
        IconButton(
          alignment: Alignment.bottomRight,
          //color: Colors.green,
          //hoverColor: Colors.green,
          icon: Icon(Icons.add_circle),
          iconSize: 44.0,
          onPressed: () {
            setState(() => {
                  editThree = true,
                });
          },
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ]));
}
