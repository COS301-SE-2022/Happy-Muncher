import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/backend/prices.dart';

Future<GroceryItemParams?> addGLDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const _GLDialog());
}

class _GLDialog extends StatefulWidget {
  const _GLDialog({Key? key}) : super(key: key);

  @override
  State<_GLDialog> createState() => GLDialogState();
}

class GLDialogState extends State<_GLDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final dateFieldController = TextEditingController();
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _gltotals =>
      firestore.collection('Users').doc(uid).collection('GL totals');

  CollectionReference get _items =>
      firestore.collection('Users').doc(uid).collection('GroceryList');

  static final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? expirationDate;
  double suggested = 0.0;
  double actual = 0.0;
  List<double> cpi = [];
  List<String> dates = [];
  double current = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              key: const Key('groceryListDialogNameField'),
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('name'),
              ),
              // onChanged: (value) {
              //   setState(() {
              //     nameController.text = nameController.text;
              //   });
              // },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              key: const Key('groceryListDialogPriceField'),
              controller: priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('Price'),
              ),
              // onChanged: (value) {
              //   setState(() {
              //     priceController.text = priceController.text;
              //   });
              // },
            ),
          ),
          TextButton(
              onPressed: () {
                String date = DateTime.now().month.toString();
                if (date.length == 1) {
                  String temp = '0' + date;
                  date = temp;
                }
                //print(date);
                FirebaseFirestore.instance
                    .collection('Prices')
                    .doc(nameController.text)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  if (documentSnapshot.exists) {
                    //print('Document data: ${documentSnapshot.data()}');
                    //print('Document data: ${documentSnapshot.data()}');
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    actual = data['actual'];
                    for (var i in data['cpi']) {
                      cpi.add(i as double);
                    }
                    for (var i in data['dates']) {
                      String date = i as String;
                      final splitted = date.split('-');
                      date = splitted[1];
                      //date += "/";
                      //date += splitted[0];
                      //dates.add(new DateFormat('MM/yyyy').parse(date) as String);
                      dates.add(date);
                    }
                    int index = getToday(date);
                    //print('index ' + index.toString());

                    double c = cpi[index] / 100;
                    //print(c);
                    current = (c * actual) + actual;
                    setState(() {
                      priceController.text = current.toStringAsFixed(2);
                    });
                    //return current;
                  } else {
                    print('Document does not exist on the database');
                    //return current;
                  }
                });
              },
              child: Text("suggest"))
        ],
      ),
      actions: [
        TextButton(
          key: const Key('groceryListDialogAddButton'),
          onPressed: () async {
            final name = nameController.text;
            final price = priceController.text;
            final priceDouble = double.tryParse(price);

            var docSnapshot = await _gltotals.doc('Totals').get();

            if (docSnapshot.exists) {
              final currentTotals =
                  ((await _gltotals.doc("Totals").get()).data() as Map);
              final estimatedTotals = currentTotals["estimated total"] as num;
              final shoppingTotals = currentTotals["shopping total"] as num;

              _gltotals.doc("Totals").set({
                'estimated total': estimatedTotals,
                'shopping total': shoppingTotals + num.parse(price)
              });
            } else {
              await _gltotals
                  .doc("Totals")
                  .set({"estimated total": 0, "shopping total": 0});

              _gltotals.doc("Totals").set({
                'estimated total': 0,
                'shopping total': 0 + num.parse(price)
              });
            }

            if (priceDouble != null) {
              await _items
                  .add({"name": name, "price": priceDouble, "bought": false});

              nameController.text = '';
              priceController.text = '';
              //GroceryListPageState().getTotals();
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }

  int getToday(String today) {
    // print("actual");
    // print(actual);
    // print("cpi");
    // print(cpi);
    // print("dates");
    // print(dates);

    for (int i = 0; i < dates.length; i++) {
      if (dates[i] == today) {
        return i;
      }
    }
    return (dates.length + 1);
  }
}

class GroceryItemParams {
  final String name;
  final double price;
  final bool value;

  GroceryItemParams({
    required this.price,
    required this.name,
    required this.value,
  });
}
