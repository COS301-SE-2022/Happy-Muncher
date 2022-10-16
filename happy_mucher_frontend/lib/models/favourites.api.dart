import 'dart:convert';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavouritesAPI {
  static Future<List<tastyRecipe>> getIDApi(String id) async {
    //dotenv.env['JUWI_API_KEY'];
    print("getting recipe by id: " + id);
    await dotenv.load(fileName: "secrets.env");

    String key = dotenv.get('JUWI_API_KEY');

    var uri =
        Uri.https('tasty.p.rapidapi.com', '/recipes/get-more-info', {"id": id});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": key,
      "X-RapidAPI-Host": "tasty.p.rapidapi.com",
      "useQueryString": 'true'
    });
    //if (resp.statusCode == 200) {
    Map data = jsonDecode(utf8.decode(resp.bodyBytes));
    List temp = [];
    //List cals = [];
    temp.add(data);
    // for (var i in data['results']) {
    //   if (i.length == 50) {

    //   }
    //   // else if (i.length == 28) {
    //   //   for (var j in i['recipes']) temp.add(j);
    //   // }

    //   //if (i['type'] == "single recipe") cals.add(i['content']['nutrition']);
    // }

    // if (query == '') {
    //   print('empty');
    return tastyRecipe.snapshotRecipes(temp);
  }
}
