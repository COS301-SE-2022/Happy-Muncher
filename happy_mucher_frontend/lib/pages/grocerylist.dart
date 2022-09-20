import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:happy_mucher_frontend/dialogs/add_grocery.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_grocery.dialog.dart';
import 'package:happy_mucher_frontend/pages/inventory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/pages/notification.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({Key? key}) : super(key: key);
  //static List<GroceryListItem> inventoryList = [];
  @override
  State<GroceryListPage> createState() => GroceryListPageState();
}

class GroceryListPageState extends State<GroceryListPage> {
  // text fields' controllers
  // text fields' controllers
  final ImagePicker _picker = ImagePicker();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  int shoppingPrices = 0;
  int estimatePrices = 0;
  CollectionReference get _products =>
      firestore.collection('Users').doc(uid).collection('GroceryList');

  CollectionReference get _inventory =>
      firestore.collection('Users').doc(uid).collection('Inventory');

  CollectionReference get _gltotals =>
      firestore.collection('Users').doc(uid).collection('GL totals');
  late final LocalNotificationService service;

  @override
  void initState() {
    super.initState();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNoticationListener);

  void onNoticationListener(String? payload) {
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const IventoryPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => totals(context));
    return Scaffold(
      appBar: AppBar(
          title: const Text('Grocery List'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 252, 95, 13)),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: _gltotals.doc('Totals').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data?.data() as Map;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Estimated Total: ${(data['estimated total'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'Actual Total: ${(data['shopping total'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
          Expanded(
            child: StreamBuilder(
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
                                setState(() async {
                                  _products.doc(documentSnapshot.id).delete();

                                  final currentTotals =
                                      ((await _gltotals.doc("Totals").get())
                                          .data() as Map);
                                  final estimatedTotals =
                                      currentTotals["estimated total"] as num;
                                  final shoppingTotals =
                                      currentTotals["shopping total"] as num;

                                  final isBought = documentSnapshot['bought'];

                                  if (isBought == false) {
                                    _gltotals.doc("Totals").update({
                                      'estimated total': estimatedTotals,
                                      'shopping total': shoppingTotals -
                                          documentSnapshot['price']
                                    });
                                  } else {
                                    _gltotals.doc("Totals").update({
                                      'estimated total': estimatedTotals -
                                          documentSnapshot['price'],
                                      'shopping total': shoppingTotals -
                                          documentSnapshot['price']
                                    });
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You have successfully deleted a grocery list item',
                                      ),
                                    ),
                                  );
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
                          onChanged: (checkVal) async {
                            if (checkVal == null) {
                              return;
                            }
                            _products
                                .doc(documentSnapshot.id)
                                .update({'bought': checkVal});

                            var itemName = documentSnapshot['name'];

                            if (checkVal == true) {
                              _inventory.add(
                                {
                                  "itemName": itemName,
                                  "quantity": 1,
                                  "expirationDate": ""
                                },
                              );

                              NotificationAPI.showNotification(
                                  title: 'Happy Muncher',
                                  body:
                                      '$itemName has been added to inventory. Please go the the inventory page to edit the quantity and expiration date',
                                  payload: 'groceryList');
                            }

                            final currentTotals =
                                ((await _gltotals.doc("Totals").get()).data()
                                    as Map);
                            final estimatedTotals =
                                currentTotals["estimated total"] as num;
                            final shoppingTotals =
                                currentTotals["shopping total"] as num;

                            if (checkVal) {
                              _gltotals.doc("Totals").update({
                                'estimated total':
                                    estimatedTotals + documentSnapshot['price'],
                                'shopping total': shoppingTotals
                              });
                            } else {
                              _gltotals.doc("Totals").update({
                                'estimated total':
                                    estimatedTotals - documentSnapshot['price'],
                                'shopping total': shoppingTotals
                              });
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
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        key: const Key('speed_dial_button'),
        icon: Icons.add,
        backgroundColor: Color.fromARGB(255, 172, 255, 78),
        children: [
          SpeedDialChild(
            onTap: () => addGLDialog(context),
            key: const Key('addToInventoryButtonText'),
            child: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 172, 255, 78),
          ),
          SpeedDialChild(
            key: const Key('addToInventoryButtonGallery'),
            onTap: () async {
              captureImageReceipt(ImageSource.gallery);
            },
            child: const Icon(
              Icons.collections,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 172, 255, 78),
          ),
          SpeedDialChild(
            key: const Key('addToInventoryButtonCamera'),
            onTap: () async {
              captureImageReceipt(ImageSource.camera);
            },
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 172, 255, 78),
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
    var priceUpdate = 0.0;

    for (final item in listOfItemNames) {
      priceUpdate += item.itemPrice;
    }
    final currentTotals = ((await _gltotals.doc("Totals").get()).data() as Map);
    final estimatedTotals = currentTotals["estimated total"] as num;
    final shoppingTotals = currentTotals["shopping total"] as num;

    _gltotals.doc("Totals").update({
      'estimated total': estimatedTotals,
      'shopping total': shoppingTotals + priceUpdate
    });

    final futures = listOfItemNames.map((item) {
      return _products.add(
          {"name": item.itemName, "price": item.itemPrice, "bought": false});
      //item.name item.price
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

  Future<List<ReceiptItem>> getRecognisedText(String path) async {
    final image = await decodeImageFromList(File(path).readAsBytesSync());
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    final mapOfItems = <ReceiptItem>[];
    final listOfItems = <String>[];
    final listOfTempItems = <String>[];
    final listOfItemsPrices = <double>[];

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.boundingBox.left / image.width * 100 < 10) {
          final textLower = line.text.toLowerCase();
          listOfTempItems.add(textLower);
        }
      }
    }

    for (final text in listOfTempItems) {
      if (text.contains('@')) {
        //multiples at spar
        continue;
      }
      if (text.contains("promo")) {
        //woolworths
        continue;
      }
      if (text.contains("**")) {
        continue;
      }
      if (text.contains("xtrasave")) {
        //checkers hyper
        continue;
      }
      listOfItems.add(text);
    }

    //remove symbols : @
    //fix R and regex
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.boundingBox.right / image.width * 100 > 95) {
          if (line.text.contains('-')) {
            //if discount remove
            continue;
          }
          if (line.text.contains(RegExp("[a-zA-Z]+"))) {
            final newPrice = line.text.replaceAll(RegExp("[a-zA-Z]+"), '');
            listOfItemsPrices.add(double.parse(newPrice));
            continue;
          }
          if (line.text.contains(' ')) {
            final newPrice = line.text.replaceAll(' ', '');
            listOfItemsPrices.add(double.parse(newPrice));
            continue;
          }
          if (line.text.contains(',')) {
            final newPrice = line.text.replaceAll(',', '.');
            listOfItemsPrices.add(double.parse(newPrice));
            continue;
          }
          if (line.text
              .contains(RegExp(r"[`~!@#$%^&*()_+\\<>?/{}\[\]|:;']+"))) {
            final newPrice = line.text
                .replaceAll(RegExp(r"[`~!@#$%^&*()_+\\<>?/{}\[\]|:;']+"), '');
            listOfItemsPrices.add(double.parse(newPrice));
            continue;
          }
          listOfItemsPrices.add(double.parse(line.text));
        }
      }
    }

    if (listOfItemsPrices.length == listOfItems.length) {
      for (int i = 0; i < listOfItems.length; i++) {
        final newItem = ReceiptItem(
            itemName: listOfItems[i], itemPrice: listOfItemsPrices[i]);
        mapOfItems.add(newItem);
      }
    } else if (listOfItemsPrices.length > listOfItems.length) {
      for (int i = 0; i < listOfItems.length; i++) {
        final newItem = ReceiptItem(
            itemName: listOfItems[i], itemPrice: listOfItemsPrices[i]);
        mapOfItems.add(newItem);
      }
    } else if (listOfItemsPrices.length < listOfItems.length) {
      for (int i = 0; i < listOfItemsPrices.length; i++) {
        final newItem = ReceiptItem(
            itemName: listOfItems[i], itemPrice: listOfItemsPrices[i]);
        mapOfItems.add(newItem);
      }
    }

    return mapOfItems;
  }
}

class ReceiptItem {
  final String itemName;
  final double itemPrice;

  ReceiptItem({required this.itemName, required this.itemPrice});
}
