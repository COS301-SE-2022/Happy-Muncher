import 'dart:convert';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TastyRecipeAPI {
  static Future<List<tastyRecipe>> getTastyApi() async {
    //dotenv.env['JUWI_API_KEY'];
    await dotenv.load(fileName: "secrets.env");

    String key = dotenv.get('JUWI_API_KEY');

    var uri = Uri.https(
        'tasty.p.rapidapi.com', '/recipes/list', {"from": "0", "size": "20"});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": key,
      "X-RapidAPI-Host": "tasty.p.rapidapi.com",
      "useQueryString": 'true'
    });
    //if (resp.statusCode == 200) {
    Map data = jsonDecode(utf8.decode(resp.bodyBytes));
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

    // if (query == '') {
    //   print('empty');
    return tastyRecipe.snapshotRecipes(temp);
    // } else {
    //   print('searching');
    //   return tastyRecipe.snapshotRecipes(temp).where((element) {
    //     String keys =
    //         element.keywords.reduce((value, str) => value + ',' + str);
    //     String ings =
    //         element.ingredients.reduce((value, str) => value + ',' + str);
    //     final nameLower = element.name.toLowerCase();
    //     final keyLower = keys.toLowerCase();
    //     final ingredsLower = ings.toLowerCase();
    //     final queryLower = query.toLowerCase();
    //     //print(keys);

    //     return nameLower.contains(queryLower) ||
    //         keyLower.contains(queryLower) ||
    //         ingredsLower.contains(queryLower);
    //   }).toList();
    //}
    // } else {
    //   throw Exception();
    // }
  }
}
