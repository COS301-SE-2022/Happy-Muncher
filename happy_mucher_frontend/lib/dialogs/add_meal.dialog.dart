import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<MealItemParams?> addMealDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const _MealDialog());
}

class _MealDialog extends StatefulWidget {
  const _MealDialog({Key? key}) : super(key: key);

  @override
  State<_MealDialog> createState() => _MealDialogState();
}

class _MealDialogState extends State<_MealDialog> {
  final nameController = TextEditingController();
  final quantityContoller = TextEditingController();
  final dateFieldController = TextEditingController();

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
              key: const Key('MealDialogNameField'),
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
                  key: const Key('MealDialogCalendarPickButton'),
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
          key: const Key('MealDialogAddButton'),
          onPressed: () {
            final name = nameController.text;
            final date = expirationDate;

            if (date != null) {
              Navigator.pop(
                context,
                MealItemParams(
                  name: name,
                  date: date,
                ),
              );
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}

class MealItemParams {
  final String name;
  final DateTime date;

  MealItemParams({
    required this.name,
    required this.date,
  });
}
