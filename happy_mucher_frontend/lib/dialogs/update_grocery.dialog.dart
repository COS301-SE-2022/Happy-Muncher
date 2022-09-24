import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> showUpdateDialogGroceryList(
    BuildContext context, DocumentSnapshot document) {
  return showDialog(
    context: context,
    builder: (_) => GLDialog(documentSnapshot: document),
  );
}

class GLDialog extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const GLDialog({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<GLDialog> createState() {
    return _UpdateGLPageState(documentSnapshot);
  }
}

class _UpdateGLPageState extends State<GLDialog> {
  // text fields' controllers
  // text fields' controllers
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final dateFieldController = TextEditingController();

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _gltotals =>
      firestore.collection('Users').doc(uid).collection('GL totals');
  CollectionReference get _items =>
      firestore.collection('Users').doc(uid).collection('GroceryList');

  DateTime? expirationDate;
  DocumentSnapshot documentSnapshot;
  _UpdateGLPageState(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    if (documentSnapshot.exists) {
      nameController.text = documentSnapshot['name'];
      priceController.text = documentSnapshot['price'].toString();
    }

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              key: const Key('GroceryDialogNameField'),
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('Name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              key: const Key('GrocerDialogPriceField'),
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
          key: const Key('GroceryListDialogAddButton'),
          onPressed: () async {
            final name = nameController.text;
            final price = priceController.text;
            final priceDouble = double.tryParse(price);
            if (priceDouble != null) {
              await _items
                  .doc(documentSnapshot.id)
                  .update({"name": name, "price": priceDouble});

              nameController.text = '';
              priceController.text = '';
              dateFieldController.text = '';

              final currentTotals =
                  ((await _gltotals.doc("Totals").get()).data() as Map);
              final estimatedTotals = currentTotals["estimated total"] as num;
              final shoppingTotals = currentTotals["shopping total"] as num;

              await _gltotals.doc("Totals").update({
                'estimated total': estimatedTotals,
                'shopping total':
                    shoppingTotals - documentSnapshot['price'] + priceDouble
              });

              Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        )
      ],
    );
  }
}
