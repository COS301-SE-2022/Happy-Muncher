import 'dart:convert';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeAPI {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https(
        'yummly2.p.rapidapi.com', '/feeds/list', {"limit": "24", "start": "0"});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": "e21eccea3dmsh34c8d2a63073c33p194216jsn037fbdaff0a1",
      "X-RapidAPI-Host": "yummly2.p.rapidapi.com",
      "useQueryString": 'true'
    });

    Map data = jsonDecode(resp.body);
    List temp = [];

    for (var i in data['feed']) {
      temp.add(i['content']['details']);
      //if (i['type'] == "single recipe") temp.add(i['content']['details']);
    }

    return Recipe.snapshotRecipes(temp);
  }
}
