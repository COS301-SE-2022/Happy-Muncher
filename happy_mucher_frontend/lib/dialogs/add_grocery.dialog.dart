import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _gltotals =>
      firestore.collection('Users').doc(uid).collection('GL totals');

  CollectionReference get _items =>
      firestore.collection('Users').doc(uid).collection('GroceryList');

  static final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? expirationDate;

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
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('groceryListDialogAddButton'),
          onPressed: () async {
            final name = nameController.text;
            final price = priceController.text;
            final priceDouble = double.tryParse(price);

            if (priceDouble != null) {
              await _items
                  .add({"name": name, "price": priceDouble, "bought": false});

              nameController.text = '';
              priceController.text = '';
              UpdateGL(priceDouble);
              //GroceryListPageState().getTotals();
              Navigator.of(context).pop();
            }

            final currentTotals =
                ((await _gltotals.doc("Totals").get()).data() as Map);
            final estimatedTotals = currentTotals["estimated total"] as num;
            final shoppingTotals = currentTotals["shopping total"] as num;

            _gltotals.doc("Totals").set({
              'estimated total': estimatedTotals,
              'shopping total': shoppingTotals + num.parse(price)
            });
          },
          child: const Text('Add'),
        )
      ],
    );
  }

  void UpdateGL(double price) async {
    String? e = '';
    double estimate = 0.0;
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('GL totals');
    //userUid is the current auth user
    var docSnapshot = await collection.doc('Totals').get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;

      e = data['estimated total'].toString();
    }
    estimate = double.parse(e);
    estimate += price;

    await _gltotals
        .doc('Totals')
        .set({"estimated total": estimate, "shopping total": 0});
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
