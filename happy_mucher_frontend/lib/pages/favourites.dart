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
  FavouritesBook({Key? key}) : super(key: key);
  @override
  State<FavouritesBook> createState() => FavouritesBookState();
}

class FavouritesBookState extends State<FavouritesBook> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _favourites =>
      firestore.collection('Users').doc(uid).collection('Recipes');
  late List<tastyRecipe> recipes;
  List<tastyRecipe> temp = [];
  List<String> ids = [];
  String query = "";
  //Timer? debouncer;
  //List<tastyRecipe> tr = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getDB(context);

    if (ids.isNotEmpty) {
      print("ids");
      getRecipes();
    }
  }

  void getDB(context) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Recipes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ids.add(doc["ID"]);
        //print(ids);
      });
    });
    for (var i in ids) {
      print(i);
      List<tastyRecipe> tr = await FavouritesAPI.getIDApi(i);
      print(tr[0].name);
    }
    // temp = List.from(recipes);
    // if (mounted) {
    //   setState(() {
    //     loading = false;
    //     this.recipes = recipes;
    //     this.temp = temp;
    //     // recipes.length? len = recipes.length
    //   });
    // }
    if (mounted) {
      setState(() {
        //print(ids);
      });
    }
  }

  Future<void> getRecipes() async {
    //recipes = await RecipeAPI.getRecipe();
    //recipes = await FavouritesAPI.getIDApi(id);

    //print(recipes[0].keywords);
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
