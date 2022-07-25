import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/search_widget.dart';
//import 'package:http/http.dart' as http;

class TastyBook extends StatefulWidget {
  TastyBook({Key? key}) : super(key: key);
  @override
  State<TastyBook> createState() => TastyBookState();
}

class TastyBookState extends State<TastyBook> {
  late List<tastyRecipe> recipes;
  List<tastyRecipe> temp = [];
  String query = "";
  //Timer? debouncer;
  //List<tastyRecipe> tr = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async {
    //recipes = await RecipeAPI.getRecipe();
    recipes = await TastyRecipeAPI.getTastyApi(query);
    temp = List.from(recipes);
    if (mounted) {
      setState(() {
        loading = false;
        this.recipes = recipes;
        this.temp = temp;
        // recipes.length? len = recipes.length
      });
    }

    //print(recipes[0].keywords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        centerTitle: true,
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
