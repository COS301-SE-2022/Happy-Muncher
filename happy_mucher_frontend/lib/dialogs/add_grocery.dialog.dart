import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _items => firestore.collection('GroceryList');
  CollectionReference get _gltotals => firestore.collection('GL totals');

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

              Navigator.of(context).pop();
            }

            final currentTotals =
                ((await _gltotals.doc("Totals").get()).data() as Map);
            final estimatedTotals = currentTotals["estimated total"] as num;
            final shoppingTotals = currentTotals["shopping total"] as num;

            _gltotals.doc("Totals").update({
              'estimated total': estimatedTotals,
              'shopping total': shoppingTotals + num.parse(price)
            });
          },
          child: const Text('Add'),
        )
      ],
    );
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
