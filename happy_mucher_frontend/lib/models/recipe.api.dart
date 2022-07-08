import 'dart:convert';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeAPI {
  static Future<List<Recipe>> getRecipe() async {
    //API keys:
    //u20435780: a3e79709c3mshd3559dbe7ea46a2p11b5b5jsnd4fd34ff55d0
    var uri = Uri.https(
        'yummly2.p.rapidapi.com', '/feeds/list', {"limit": "24", "start": "0"});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": "a3e79709c3mshd3559dbe7ea46a2p11b5b5jsnd4fd34ff55d0",
      "X-RapidAPI-Host": "yummly2.p.rapidapi.com",
      "useQueryString": 'true'
    });

    Map data = jsonDecode(resp.body);
    List temp = [];
    //List cals = [];

    for (var i in data['feed']) {
      //temp.add(i['content']['details']);

      if (i['type'] == "single recipe") {
        temp.add(i['content']);
      }

      //if (i['type'] == "single recipe") cals.add(i['content']['nutrition']);
    }
    //print(temp[0]);

    return Recipe.snapshotRecipes(temp);
  }
}
