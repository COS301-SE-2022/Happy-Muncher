import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

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
                    subtitle: Text('R' + documentSnapshot['price'].toString()),
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Please go to the inventory page to edit the quantity and expiration date')));
                      }
                    },
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            onTap: () => addGLDialog(context),
            key: const Key('addToInventoryButton'),
            child: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            onTap: () async {
              captureImageReceipt(ImageSource.gallery);
            },
            child: const Icon(
              Icons.collections,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          ),
          SpeedDialChild(
            onTap: () async {
              captureImageReceipt(ImageSource.camera);
            },
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
          )
        ],
      ),
    );
  }

  void captureImageReceipt(ImageSource imageSource) async {
    final image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return;
    }
    final croppedImagePath = await cropImage(image.path);
    if (croppedImagePath == null) {
      return;
    }
    final listOfItemNames = await getRecognisedText(croppedImagePath);

    final futures = listOfItemNames.map((item) {
      return _products.add({"name": item, "price": 0.0, "bought": false});
    });
    await Future.wait(futures);
  }

  Future<String?> cropImage(String path) async {
    final cropped =
        await ImageCropper().cropImage(sourcePath: path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Croppper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false)
    ]);
    return cropped?.path;
  }

  Future<List<String>> getRecognisedText(String path) async {
    final image = await decodeImageFromList(File(path).readAsBytesSync());
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    //final listOfItems = <ReceiptItem>[];
    final listOfItems = <String>[];

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.boundingBox.left / image.width * 100 < 10) {
          if (line.text.contains('@')) {
            //multiples at spar
            continue;
          }
          if (line.text.contains("promo")) {
            //woolworths
            continue;
          }
          if (line.text.contains("**")) {
            continue;
          }
          if (line.text.contains("xtrasave")) {
            //checkers hyper
            continue;
          }
          if (listOfItems.contains(line.text)) {
            continue;
          }
          listOfItems.add(line.text);
        }
      }
    }
    return listOfItems;
  }
}

class ReceiptItem {
  final String itemName;
  final double itemPrice;

  ReceiptItem({required this.itemName, required this.itemPrice});
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
