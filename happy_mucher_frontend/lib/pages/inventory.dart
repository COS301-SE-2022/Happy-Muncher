import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_inventory.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_inventory.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IventoryPage extends StatefulWidget {
  const IventoryPage({Key? key}) : super(key: key);

  @override
  State<IventoryPage> createState() => _IventoryPageState();
}

class _IventoryPageState extends State<IventoryPage> {
  // text fields' controllers
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Inventory');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Inventory')),
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['itemName'] +
                          ' ' +
                          documentSnapshot['quantity'].toString()),
                      subtitle:
                          Text(documentSnapshot['expirationDate'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IventoryDialog(
                                          documentSnapshot:
                                              documentSnapshot))), //update
                            ),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _products.doc(documentSnapshot.id).delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'You have successfully deleted a product')));
                                }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product
        floatingActionButton: FloatingActionButton(
          onPressed: () => addInventoryDialog(context),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
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

