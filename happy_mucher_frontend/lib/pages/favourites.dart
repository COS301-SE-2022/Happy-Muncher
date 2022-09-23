import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/search_widget.dart';
import 'package:happy_mucher_frontend/models/favourites.api.dart';
//import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class FavouritesBook extends StatefulWidget {
  FavouritesBook({Key? key, required this.ids}) : super(key: key);
  final List<String> ids;
  @override
  State<FavouritesBook> createState() => FavouritesBookState();
}

class FavouritesBookState extends State<FavouritesBook> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _favourites =>
      firestore.collection('Users').doc(uid).collection('Recipes');
  List<tastyRecipe> recipes = [];
  List<tastyRecipe> temp = [];
  List<String> idee = [];
  String query = "";
  //Timer? debouncer;
  //List<tastyRecipe> tr = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();

    for (var i in widget.ids) {
      getRecipes(i);
    }
  }

  // void getDB(context) async {
  //   FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(uid)
  //       .collection('Recipes')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       //widget.ids.add(doc["ID"]);
  //       idee.add(doc["ID"]);
  //       //print(idee);
  //       getRecipes(doc["ID"]);
  //     });
  //   });
  // }

  FutureOr<void> getRecipes(String id) async {
    List<tastyRecipe> tr = await FavouritesAPI.getIDApi(id);
    print(tr);
    recipes.add(tr[0]);
    temp.add(tr[0]);
    setState(() {
      loading = false;
      this.recipes = recipes;
      this.temp = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 95, 13),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SearchBox(),
          loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return TastyRecipeCard(
                      name: recipes[index].name,
                      recipeid: recipes[index].recipeid,
                      images: recipes[index].images,
                      totTime: recipes[index].totTime.toString(),
                      description: recipes[index].description,
                      calories: recipes[index].calories,
                      ingredients: recipes[index].ingredients,
                      instructions: recipes[index].instructions,
                    );
                  })
        ],
      )),
    );
  }

  Widget SearchBox() => SearchWidget(
        hintText: "search by ingredient or keyword",
        text: query,
        onChanged: searchRecipe,
      );

  void searchRecipe(String query) {
    //final rec = await TastyRecipeAPI.getTastyApi(query);
    print('searching');
    final recipes = this.temp.where((element) {
      String keys = element.keywords.reduce((value, str) => value + ',' + str);
      String ings =
          element.ingredients.reduce((value, str) => value + ',' + str);
      final nameLower = element.name.toLowerCase();
      final keyLower = keys.toLowerCase();
      final ingredsLower = ings.toLowerCase();
      final queryLower = query.toLowerCase();
      //print(ingredsLower);

      return nameLower.contains(queryLower) ||
          keyLower.contains(queryLower) ||
          ingredsLower.contains(queryLower);
    }).toList();
    //if (!mounted) return;

    setState(() {
      this.query = query;
      this.recipes = recipes;
    });
  }
  // void Reset() async {
  //   // recipes = List.from(temp);
  //   initState();
  //   //setState(() {});
  // }
}
