import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_inventory.dialog.dart';
import 'package:intl/intl.dart';

class IventoryPage extends StatefulWidget {
  const IventoryPage({Key? key}) : super(key: key);

  @override
  State<IventoryPage> createState() => _IventoryPageState();
}

class _IventoryPageState extends State<IventoryPage> {
  static final dateFormat = DateFormat('yyyy-MM-dd');

  List<IventoryItem> inventoryList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.fastfood),
        title: const Text(
          'Inventory',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: const Key('Inventory_ListView'),
              itemCount: inventoryList.length,
              itemBuilder: (context, index) {
                final item = inventoryList[index];
                return Dismissible(
                  key: Key(item.itemName),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      inventoryList.removeAt(index);
                    });
                  },
                  child: ListTile(
                    title: Text('${item.quantity} x ${item.itemName}'),
                    trailing: Text(dateFormat.format(item.expirationDate)),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: IconButton(
                  key: const Key('addToInventoryButton'),
                  onPressed: () async {
                    final returnedItem = await addInventoryDialog(context);
                    if (returnedItem != null) {
                      setState(() {
                        inventoryList.add(IventoryItem(
                          quantity: returnedItem.quantity,
                          itemName: returnedItem.name,
                          expirationDate: returnedItem.date,
                        ));
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle),
                  iconSize: 64.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.photo_camera),
                  iconSize: 64.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//STRUCTURE
//SCAFFOLD
//  APPBAR
//    ICON + TEXT
//  COLUMN
//    EXPANDED (TO FILL UP SCREEN)
//      LISTVIEW (LIST OF TILES)
//       LIST TILE (LIST THAT CONTAINS INFO)
//         TEXT + TEXT
//    ROW (BOTTOM 2 BUTTONS)
//      PADDING
//        ICONBUTTON
//      PADDING
//        ICONBUTTON

//CLASS OF THE RETURNED LIST ITEM
class IventoryItem {
  final String itemName;
  final int quantity;
  final DateTime expirationDate;

  IventoryItem({
    required this.quantity,
    required this.itemName,
    required this.expirationDate,
  });
}
