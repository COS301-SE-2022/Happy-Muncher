import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/pages/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';

Future<GroceryItemParams?> addbarD(BuildContext context, String itemN) {
  return showDialog(
      context: context, builder: (_) => _addbarD(itemName: itemN));
}

class _addbarD extends StatefulWidget {
  const _addbarD({Key? key, required this.itemName}) : super(key: key);
  final String itemName;
  @override
  State<_addbarD> createState() => addbarState();
}

class addbarState extends State<_addbarD> {
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;

  //final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final dateFieldController = TextEditingController();

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _products =>
      firestore.collection('Users').doc(uid).collection('Inventory');
  late final LocalNotificationService service;
  static final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? expirationDate;
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.itemName;
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => IventoryPage())));
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
                      final String name = nameController.text;
                      dateFieldController.text = dateFormat.format(chosenDate);
                      expirationDate = chosenDate;
                      int id = UniqueKey().hashCode;
                      LocalNotificationService.setID(id);
                      service.showScheduledNotification(
                          id: id,
                          title: 'Happy Muncher',
                          body:
                              '$name expires today! Please add it to your grocery list.',
                          seconds: 5,
                          scheduledDate: chosenDate);
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
            }
            Navigator.of(context).pop();
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
