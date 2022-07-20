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
    recipes = await RecipeAPI.getRecipe();
    tr = await TastyRecipeAPI.getTastyApi();
    if (mounted) {
      setState(() {
        loading = false;
        // recipes.length? len = recipes.length
      });
    }

    print(tr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recipe Book'),
          centerTitle: true,
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return TastyRecipeCard(
                    name: recipes[index].name,
                    totTime: recipes[index].totalTime,
                    calories: recipes[index].calories.toInt(),
                    images: recipes[index].images,
                    description: recipes[index].description,
                    ingredients: recipes[index].ingredients,
                    //recipes: recipes,
                  );
                }));
  }
}
