import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:http/http.dart' as http;

class RecipeBook extends StatefulWidget {
  const RecipeBook({Key? key}) : super(key: key);

  @override
  State<RecipeBook> createState() => RecipeBookState();
}

class RecipeBookState extends State<RecipeBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        centerTitle: true,
      ),
      body: RecipeCard(
          title: "Recipe",
          cookTime: "30 min",
          rating: "2",
          thumbnailUrl:
              'https://lh3.googleusercontent.com/ei5eF1LRFkkcekhjdR_8XgOqgdjpomf-rda_vvh7jIauCgLlEWORINSKMRR6I6iTcxxZL9riJwFqKMvK0ixS0xwnRHGMY4I5Zw=s360'),
    );
  }
}
