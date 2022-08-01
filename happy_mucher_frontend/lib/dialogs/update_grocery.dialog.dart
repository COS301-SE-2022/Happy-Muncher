import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';

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
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final dateFieldController = TextEditingController();

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _items => firestore.collection('GroceryList');

  CollectionReference get _totals => firestore.collection('GL totals');

  DateTime? expirationDate;
  DocumentSnapshot documentSnapshot;
  _UpdateGLPageState(this.documentSnapshot);

  @override
  Widget build(BuildContext context) {
    if (documentSnapshot != null) {
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
              double ogPrice = documentSnapshot['price'];
              await _items
                  .doc(documentSnapshot.id)
                  .update({"name": name, "price": priceDouble});
              UpdateGL(priceDouble, ogPrice);
              setState(() {});
              //GroceryListPageState().getTotals();
              nameController.text = '';
              priceController.text = '';
              dateFieldController.text = '';
              Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        )
      ],
    );
  }

  void UpdateGL(double price, double og) async {
    String? e = '';
    double estimate = 0.0;
    var collection = FirebaseFirestore.instance.collection('GL totals');
    //userUid is the current auth user
    var docSnapshot = await collection.doc('Totals').get();

    Map<String, dynamic> data = docSnapshot.data()!;

    e = data['estimated total'].toString();

    estimate = double.parse(e);
    estimate = estimate - og;
    estimate += price;
    await _totals.doc('Totals').update({
      "estimated total": estimate,
    });
  }
}
