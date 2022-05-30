import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:intl/intl.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  var checkedValue = false;

  List<GroceryListItem> inventoryList = [];

  get groceryList => null;

  get value => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.fastfood),
        title: const Text(
          'Grocery List',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: const Key('Grocery_ListView'),
              itemCount: inventoryList.length,
              itemBuilder: (context, index) {
                final item = inventoryList[index];

                return Slidable(
                  key: Key(item.itemName),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          setState(() {
                            groceryList.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          final returnedItem = await addGroceryDialog(context,
                              editingItem: item);
                          if (returnedItem != null) {
                            setState(() {
                              groceryList.removeAt(index);

                              groceryList.insert(
                                  index,
                                  GroceryListItem(
                                    Price: returnedItem.price,
                                    itemName: returnedItem.name,
                                    value: value,
                                  ));
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      )
                    ],
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: item.value,
                    onChanged: (checkedValue) =>
                        setState(() => item.value = checkedValue!),
                    title: Text(item.itemName),
                    secondary: Text('R${item.Price}'),
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
                  key: const Key('addToGroceryListButton'),
                  onPressed: () async {
                    final returnedItem = await addGroceryDialog(context);
                    if (returnedItem != null) {
                      setState(() {
                        groceryList.add(GroceryListItem(
                          itemName: returnedItem.name,
                          Price: returnedItem.price,
                          value: false,
                        ));
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle),
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

class GroceryListItem {
  final String itemName;
  final int Price;
  bool value;
  GroceryListItem({
    required this.Price,
    required this.itemName,
    required this.value,
  });
}


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


