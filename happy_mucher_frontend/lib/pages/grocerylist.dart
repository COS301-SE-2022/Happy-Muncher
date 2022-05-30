import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

  @override
  State<GroceryListPage> createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  var checkedValue = false;

  List<GroceryListItem> inventoryList = [];

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

                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: item.value,
                  onChanged: (checkedValue) =>
                      setState(() => item.value = checkedValue!),
                  title: Text(item.itemName),
                  secondary: Text('R${item.Price}'),
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
                        inventoryList.add(GroceryListItem(
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

//Total for budget
  TotEstimate() {
    int total = 0;
    inventoryList.forEach((element) {
      total = total + element.Price;
    });
  }
}

class GroceryListItem {
  String itemName;
  int Price;
  bool value;
  GroceryListItem({
    required this.Price,
    required this.itemName,
    required this.value,
  });
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
