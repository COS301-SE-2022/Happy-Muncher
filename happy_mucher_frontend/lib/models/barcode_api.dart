import 'dart:convert';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:happy_mucher_frontend/models/barcode_data.dart';

class BarcodeAPI {
  // final String barcode;

  // BarcodeAPI({required this.barcode});
  static Future<List<BarcodeData>> getBarcode(String barcode) async {
    print('fetching data for: ' + barcode);
    await dotenv.load(fileName: "secrets.env");

    String key = dotenv.get('BARCODE_KEY_JUWI');
    String itemName = "";

    var uri = Uri.https('barcodes1.p.rapidapi.com', '/', {'query': barcode});
    final resp = await http.get(uri, headers: {
      "X-RapidAPI-Key": key,
      "X-RapidAPI-Host": 'barcodes1.p.rapidapi.com',
    });
    List temp = [];
    if (resp.statusCode == 200) {
      Map data = jsonDecode(utf8.decode(resp.bodyBytes));
      print(data);

      data.entries.forEach((e) => temp.add((e.value)));
    } else {
      throw Exception();
    }

    // for (var i in data['product']) {
    //   print("item");
    //   print(i);
    // }
    //print(temp);
    return BarcodeData.snapshotBarcode(temp);
  }
}
