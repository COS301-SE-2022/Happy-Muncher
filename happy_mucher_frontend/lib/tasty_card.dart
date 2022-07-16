import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tastyInfo.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/pages/individualRecipe.dart';
import 'package:happy_mucher_frontend/pages/tastyRecipeInfo.dart';

class TastyRecipeCard extends StatelessWidget {
  final String name;
  final String images;
  final int recipeid;
  final String totTime;
  final String description;
  final int calories;
  final List<String> ingredients;
  final List<String> instructions;
  //List<Recipe>? recipes;
  TastyRecipeCard(
      {this.name = "",
      this.images = "",
      this.recipeid = 0,
      this.totTime = "",
      this.description = "",
      this.calories = 0,
      this.ingredients = const [''],
      this.instructions = const ['']});
  //List<tastyRecipe> info = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(images),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                name,
                style: TextStyle(fontSize: 19, color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        calories.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(
                        totTime,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
          Align(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    // List<String> ing = [];

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => IndividualRecipe(
                        name: name,
                        description: description,
                        image: images,
                        //id: recipeid,
                        ingredients: ingredients,
                        cookTime: totTime,
                        instructions: instructions,
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                )
              ],
            ),
            alignment: Alignment.topLeft,
          ),
        ],
      ),
    );
  }
}

//  Future<void> getRecipes() async {
//     //recipes = await RecipeAPI.getRecipe();
//     info = await TastyInfoAPI.getTastyApi();
//     if (mounted) {
//       setState(() {
//         loading = false;
//         // recipes.length? len = recipes.length
//       });
//     }

//     //print(tr);
//   }
