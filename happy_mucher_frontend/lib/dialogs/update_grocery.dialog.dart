import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final CollectionReference _items =
      FirebaseFirestore.instance.collection('GroceryList');

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
            final priceInt = int.tryParse(price);
            const valueFalse = false;
            if (priceInt != null) {
              await _items
                  .doc(documentSnapshot.id)
                  .update({"name": name, "price": price});

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
}

class InventoryItemParams {
  final String name;
  final int quantity;
  final DateTime date;

  InventoryItemParams({
    required this.quantity,
    required this.name,
    required this.date,
  });
}
