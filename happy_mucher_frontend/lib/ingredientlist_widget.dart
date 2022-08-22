import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/componentcard.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';

class IngredientListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComponentCard(recipe: myRecipe(name: "my recipe"));
  }
}
