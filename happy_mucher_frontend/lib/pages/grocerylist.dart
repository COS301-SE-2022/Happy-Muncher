import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int shoppingPrices = 0;
  int estimatePrices = 0;
  CollectionReference get _products => firestore.collection('GroceryList');

  CollectionReference get _inventory => firestore.collection('Inventory');

  //final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _gltotals => firestore.collection('GL totals');
  var data;
  @override
  void initState() {
    super.initState();
    // print('init');
    // //Totals(context);
    // print('est');
    // print(estimatePrices);
    // print('shopping');
    // print(shoppingPrices);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => Totals(context));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grocery List'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 252, 95, 13),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.add, size: 19),
                    ),
                    TextSpan(
                        text: "Estimated Total: " +
                            estimatePrices.toString() +
                            "\n",
                        style: TextStyle(fontSize: 19, color: Colors.black)),
                    WidgetSpan(
                      child: Icon(Icons.shopping_cart, size: 19),
                    ),
                    TextSpan(
                        text: "Total: " + shoppingPrices.toString(),
                        style: TextStyle(fontSize: 19, color: Colors.black)),
                  ],
                ),
              )
              // Text(

              //   "\u2713 Estimated Price: " +
              //       estimatePrices.toString() +
              //       '\n' +
              //       "Total: " +
              //       shoppingPrices.toString(),
              //   style: TextStyle(fontSize: 19, color: Colors.black),
              // ),
            ],
          ),
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
                        ),
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
          backgroundColor: Color.fromARGB(255, 172, 255, 78),
          onPressed: () => addGLDialog(context),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }

  Totals(context) {
    print('totals');
    //e = 0;
    Estimates();
    Shopping();
    print('done');

    setState(() {
      //estimatePrices = 0;
    });
  }

  Estimates() {
    int e = 0;
    FirebaseFirestore.instance
        .collection('GroceryList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if ((doc["price"]) != 0) {
          String n = doc["price"].toString();
          e += int.parse(n);
        }
      });
      print('here');
      estimatePrices = e;

      //return estimatePrices;
    });
    print('getting estimates: ' + estimatePrices.toString());
    if (estimatePrices != null) {
      _gltotals.doc('Totals').update({'estimated total': estimatePrices});
    }
    setState(() {});
    //estimatePrices = e;

    //return estimatePrices;
    //print('getting estimates: ' + e.toString());
  }

  Shopping() {
    int s = 0;
    FirebaseFirestore.instance
        .collection('GroceryList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if ((doc["bought"]) == true) {
          String n = doc['price'].toString();
          s += int.parse(n);
        }
      });
      print('here');
      shoppingPrices = s;
    });
  }
}
//  decoration: BoxDecoration(
//           border: Border(
//             top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
//             bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
//           ),
//           color: Colors.white,
//         ),
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
