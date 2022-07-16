import 'dart:convert';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:http/http.dart' as http;

class TastyRecipeAPI {
  static Future<List<tastyRecipe>> getTastyApi() async {
    //API keys:
    //u20435780: a3e79709c3mshd3559dbe7ea46a2p11b5b5jsnd4fd34ff55d0
    var uri = Uri.https(
        'tasty.p.rapidapi.com', '/recipes/list', {"from": "0", "size": "20"});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": "a3e79709c3mshd3559dbe7ea46a2p11b5b5jsnd4fd34ff55d0",
      "X-RapidAPI-Host": "tasty.p.rapidapi.com",
      "useQueryString": 'true'
    });

    Map data = jsonDecode(resp.body);
    List temp = [];
    //List cals = [];

    for (var i in data['results']) {
      if (i.length == 50) {
        temp.add(i);
      } else if (i.length == 28) {
        for (var j in i['recipes']) temp.add(j);
      }

      //if (i['type'] == "single recipe") cals.add(i['content']['nutrition']);
    }
    //print(temp);

    return tastyRecipe.snapshotRecipes(temp);
  }
}
