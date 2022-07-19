import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
<<<<<<< HEAD
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:happy_mucher_frontend/pages/month.dart';
>>>>>>> 7c9e53a64e76cda871eece630e6a9b33d00f933d

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);
  //static List<GroceryListItem> inventoryList = [];
  @override
  State<GroceryListPage> createState() => GroceryListPageState();
}

class GroceryListPageState extends State<GroceryListPage> {
  // text fields' controllers
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expController = TextEditingController();

  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _products => firestore.collection('GroceryList');

  CollectionReference get _inventory => firestore.collection('Inventory');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grocery List'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                key: const Key('Grocery_ListView'),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Slidable(
                    key: Key(documentSnapshot['name']),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              _products.doc(documentSnapshot.id).delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You have successfully deleted a grocery list item')));
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            showUpdateDialogGroceryList(
                                context, documentSnapshot);
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
                        title: Text(documentSnapshot['name']),
                        value: documentSnapshot['bought'],
                        subtitle:
                            Text('R' + documentSnapshot['price'].toString()),
                        onChanged: (newValue) {
                          _products
                              .doc(documentSnapshot.id)
                              .update({'bought': !documentSnapshot['bought']});

<<<<<<< HEAD
                          var checkVal = documentSnapshot['bought'];
                          var itemName = documentSnapshot['name'];
                          if (checkVal == false) {
                            //checks previous value if it is changing from false to true that means its being bought
                            _inventory.add(
                              {
                                "itemName": itemName,
                                "quantity": 1,
                                "expirationDate": ""
                              },
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please go to the inventory page to edit the quantity and expiration date')));
                          }
                        }),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key('addToGroceryListButton'),
          onPressed: () => addGLDialog(context),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
=======
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
          ),
          ElevatedButton(
            onPressed: () {
              int tot = 0;
              int price = 0;
              List<GroceryListItem> gl = [];
              inventoryList.forEach((element) {
                if (element.value == true) {
                  tot += element.Price;
                }
                price += element.Price;
              });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Month(price: price, glSpent: tot),
              ));
            },
            child: const Text("Finish Shopping"),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     int price = 0;
          //     List<GroceryListItem> gl = [];
          //     inventoryList.forEach((element) {
          //       price += element.Price;
          //     });
          //     Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => Month(price: price),
          //     ));
          //   },
          //   child: const Text("To Budget"),
          // )
        ],
      ),
    );
>>>>>>> 7c9e53a64e76cda871eece630e6a9b33d00f933d
  }
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

