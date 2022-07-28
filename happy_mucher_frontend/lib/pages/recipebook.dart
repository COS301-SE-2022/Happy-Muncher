import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
//import 'package:http/http.dart' as http;

class RecipeBook extends StatefulWidget {
  RecipeBook({Key? key}) : super(key: key);
  @override
  State<RecipeBook> createState() => RecipeBookState();
}

class RecipeBookState extends State<RecipeBook> {
  List<Recipe> recipes = [];
  List<tastyRecipe> tr = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    tr = await TastyRecipeAPI.getTastyApi();
    // tr = await TastyRecipeAPI.getTastyApi(search);

    setState(() {
      loading = false;
      // recipes.length? len = recipes.length
    });

    //print(tr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('rbPage'),
      // appBar: AppBar(
      //   title: const Text('Recipe Book'),
      //   centerTitle: true,
      // ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          :  RecipeCard(
                  recipes: tr,
                )
              
    );
  }
}
