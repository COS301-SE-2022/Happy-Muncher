import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/componentcard.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';

class IngredientListWidget extends StatelessWidget {
  final String ingredient;
  IngredientListWidget({required this.ingredient});
  @override
  Widget build(BuildContext context) {
    return ComponentCard(ingredient: ingredient,);
  }
}
