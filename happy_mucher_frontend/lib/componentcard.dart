import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';

class ComponentCard extends StatelessWidget {
  final myRecipe recipe;

  const ComponentCard({required this.recipe});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.orange,
          ),
          Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(recipe.name)]),
        ],
      );
}
