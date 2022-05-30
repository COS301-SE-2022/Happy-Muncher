import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/grocerylist.dart';

Future<GroceryItemParams?> addGroceryDialog(BuildContext context,
    {GroceryListItem? editingItem}) {
  return showDialog(context: context, builder: (_) => const _GroceryDialog());
}

class _GroceryDialog extends StatefulWidget {
  const _GroceryDialog({Key? key}) : super(key: key);

  @override
  State<_GroceryDialog> createState() => _GroceryDialogState();
}

class _GroceryDialogState extends State<_GroceryDialog> {
  final nameController = TextEditingController();
  final priceContoller = TextEditingController();
  final dateFieldController = TextEditingController();

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
                label: Text('Name'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              key: const Key('groceryListDialogPriceField'),
              controller: priceContoller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('price'),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('groceryListDialogAddButton'),
          onPressed: () {
            final name = nameController.text;
            final price = priceContoller.text;
            final priceInt = int.tryParse(price);
            const valueFalse = false;

            if (priceInt != null) {
              Navigator.pop(
                context,
                GroceryItemParams(
                    price: priceInt, name: name, value: valueFalse),
              );
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}

class GroceryItemParams {
  final String name;
  final int price;
  final bool value;

  GroceryItemParams({
    required this.price,
    required this.name,
    required this.value,
  });
}
