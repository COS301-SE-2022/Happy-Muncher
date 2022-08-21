import 'package:flutter/cupertino.dart';

class recipeField {
  //static const createdTime = 'createdTime';
}

class myRecipe {
  String name;
  String images;
  double calories;
  String totalTime;
  String description;
  List<String> ingredients;

  myRecipe({
    this.name = "",
    this.images = "",
    this.calories = 0,
    this.totalTime = "",
    this.description = "",
    this.ingredients = const [""],
  });
}
