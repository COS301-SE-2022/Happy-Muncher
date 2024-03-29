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
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:happy_mucher_frontend/backend/prices.dart';

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
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  int shoppingPrices = 0;
  int estimatePrices = 0;
  bool croppeddial = false;
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
      appBar: buildAppBar(context, "Grocery List"),
      body: Column(
        children: [
          StreamBuilder(
              stream: _gltotals.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData &&
                    !streamSnapshot.data!.docs.isEmpty) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[0];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SHOPPING TOTAL: ${(documentSnapshot['estimated total'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ESTIMATED TOTAL: ${(documentSnapshot['shopping total'] as num).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
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

                                  var docSnapshot =
                                      await _gltotals.doc('Totals').get();

                                  if (docSnapshot.exists) {
                                    final currentTotals =
                                        ((await _gltotals.doc("Totals").get())
                                            .data() as Map);
                                    final estimatedTotals =
                                        currentTotals["estimated total"] as num;
                                    final shoppingTotals =
                                        currentTotals["shopping total"] as num;

                                    final isBought = documentSnapshot['bought'];

                                    if (isBought == false) {
                                      _gltotals.doc("Totals").set({
                                        'estimated total': estimatedTotals,
                                        'shopping total': (shoppingTotals -
                                                documentSnapshot['price'])
                                            .clamp(0, double.infinity)
                                      });
                                    } else {
                                      _gltotals.doc("Totals").set({
                                        'estimated total': estimatedTotals -
                                            documentSnapshot['price'],
                                        'shopping total': (shoppingTotals -
                                                documentSnapshot['price'])
                                            .clamp(0, double.infinity)
                                      });
                                    }
                                  }
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You have successfully deleted a grocery list item',
                                    ),
                                  ),
                                );
                                setState(
                                  () async {},
                                );
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 150, 66, 154),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showUpdateDialogGroceryList(
                                    context, documentSnapshot);
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 198, 158, 234),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            )
                          ],
                        ),
                        child: CheckboxListTile(
                          activeColor: Color.fromARGB(255, 150, 66, 154),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(documentSnapshot['name']),
                          value: documentSnapshot['bought'],
                          subtitle: Text('R' +
                              documentSnapshot['price'].toStringAsFixed(2)),
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

                              service.showNotification(
                                id: 0,
                                title: 'Happy Muncher',
                                body:
                                    '$itemName has been added to inventory. Please go the the inventory page to edit the quantity and expiration date',
                              );
                            }

                            var docSnapshot =
                                await _gltotals.doc('Totals').get();

                            if (docSnapshot.exists) {
                              final currentTotals =
                                  ((await _gltotals.doc("Totals").get()).data()
                                      as Map);
                              final estimatedTotals =
                                  currentTotals["estimated total"] as num;
                              final shoppingTotals =
                                  currentTotals["shopping total"] as num;

                              if (checkVal) {
                                _gltotals.doc("Totals").set({
                                  'estimated total': estimatedTotals +
                                      documentSnapshot['price'],
                                  'shopping total': shoppingTotals
                                });
                              } else {
                                _gltotals.doc("Totals").set({
                                  'estimated total': estimatedTotals -
                                      documentSnapshot['price'],
                                  'shopping total': shoppingTotals
                                });
                              }
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
        backgroundColor: Color.fromARGB(255, 150, 66, 154),
        children: [
          SpeedDialChild(
            key: const Key('addToInventoryButtonCamera'),
            onTap: () async {
              showAlertDialog(context, ImageSource.camera);
              // if (croppeddial) {
              //   captureImageReceipt(ImageSource.camera);
              // }
            },
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 158, 115, 198),
          ),
          SpeedDialChild(
            key: const Key('addToInventoryButtonGallery'),
            onTap: () async {
              //showAlertDialog(context);
              showAlertDialog(context, ImageSource.gallery);
              //captureImageReceipt(ImageSource.gallery);
            },
            child: const Icon(Icons.collections, color: Colors.white),
            backgroundColor: Color.fromARGB(255, 185, 141, 223),
          ),
          SpeedDialChild(
            onTap: () => addGLDialog(context),
            key: const Key('addToInventoryButtonText'),
            child: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 198, 158, 234),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void captureImageReceipt(ImageSource imageSource) async {
    croppeddial = false;
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

    var docSnapshot = await _gltotals.doc('Totals').get();

    if (docSnapshot.exists) {
      final currentTotals =
          ((await _gltotals.doc("Totals").get()).data() as Map);
      final estimatedTotals = currentTotals["estimated total"] as num;
      final shoppingTotals = currentTotals["shopping total"] as num;

      _gltotals.doc("Totals").set({
        'estimated total': estimatedTotals,
        'shopping total': shoppingTotals + priceUpdate
      });
    } else {
      _gltotals
          .doc("Totals")
          .set({'estimated total': 0, 'shopping total': 0 + priceUpdate});
    }

    final futures = listOfItemNames.map((item) {
      return _products.add(
          {"name": item.itemName, "price": item.itemPrice, "bought": false});
      //item.name item.price
    });

    await Future.wait(futures);
  }

  Future<String?> cropImage(String path) async {
    //showAlertDialog(context);
    final cropped =
        await ImageCropper().cropImage(sourcePath: path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
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

  showAlertDialog(BuildContext context, ImageSource imageSource) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        croppeddial = true;
        Navigator.of(context, rootNavigator: true).pop();
        captureImageReceipt(imageSource);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Remember!"),
      content: const Text(
          "Crop the image to contain only the item names and their prices"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ReceiptItem {
  final String itemName;
  final double itemPrice;

  ReceiptItem({required this.itemName, required this.itemPrice});
}
