import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);

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

