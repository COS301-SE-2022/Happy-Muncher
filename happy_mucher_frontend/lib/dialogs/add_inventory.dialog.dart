import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:intl/intl.dart';

Future<InventoryItemParams?> addInventoryDialog(BuildContext context,
    {IventoryItem? editingItem}) {
  return showDialog(
      context: context,
      builder: (_) => _InventoryDialog(
            inventoryEditingItem: editingItem,
          ));
}

class _InventoryDialog extends StatefulWidget {
  final IventoryItem? inventoryEditingItem;
  const _InventoryDialog({Key? key, this.inventoryEditingItem})
      : super(key: key);

  @override
  State<_InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<_InventoryDialog> {
  final nameController = TextEditingController();
  final quantityContoller = TextEditingController();
  final dateFieldController = TextEditingController();

  static final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? expirationDate;

  @override
  void initState() {
    super.initState();
    final editingItem = widget.inventoryEditingItem;
    if (editingItem != null) {
      nameController.text = editingItem.itemName;
      quantityContoller.text = '${editingItem.quantity}';
      dateFieldController.text = dateFormat.format(editingItem.expirationDate);
      expirationDate = editingItem.expirationDate;
    }
  }

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
              controller: quantityContoller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
          onPressed: () {
            final name = nameController.text;
            final quantity = quantityContoller.text;
            final quantityInt = int.tryParse(quantity);
            final date = expirationDate;

            if (date != null && quantityInt != null) {
              Navigator.pop(
                context,
                InventoryItemParams(
                  quantity: quantityInt,
                  name: name,
                  date: date,
                ),
              );
            }
          },
          child: const Text('Enter'),
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
