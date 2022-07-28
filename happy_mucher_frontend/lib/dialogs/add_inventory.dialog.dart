import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<InventoryItemParams?> addInventoryDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const _InventoryDialog());
}

class _InventoryDialog extends StatefulWidget {
  const _InventoryDialog({Key? key}) : super(key: key);

  @override
  State<_InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<_InventoryDialog> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final dateFieldController = TextEditingController();

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _products => firestore.collection('Inventory');

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
              key: const Key('inventoryDialogNameField'),
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
              key: const Key('inventoryDialogQuantityField'),
              controller: quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('Quantity'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateFieldController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      enabled: false,
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('inventoryDialogCalendarPickButton'),
                  onPressed: () async {
                    final chosenDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 30),
                      ),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365),
                      ),
                    );

                    if (chosenDate != null) {
                      dateFieldController.text = dateFormat.format(chosenDate);
                      expirationDate = chosenDate;
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('inventoryDialogAddButton'),
          onPressed: () async {
            final String name = nameController.text;
            final int? quantity = int.tryParse(quantityController.text);
            final String expD = dateFieldController.text;
            if (quantity != null) {
              await _products.add({
                "expirationDate": expD,
                "itemName": name,
                "quantity": quantity
              });

              nameController.text = '';
              quantityController.text = '';
              dateFieldController.text = '';
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
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
