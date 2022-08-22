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

  final FirebaseFirestore firestore = GetIt.I.get();
  double shoppingPrices = 0.0;
  double estimatePrices = 0.0;
  CollectionReference get _products => firestore.collection('GroceryList');

  CollectionReference get _inventory => firestore.collection('Inventory');

  //final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _gltotals => firestore.collection('GL totals');
  @override
  void initState() {
    super.initState();

    NotificationAPI.init();
    // print('init');
    // //Totals(context);
    // print('est');
    // print(estimatePrices);
    // print('shopping');
    // print(shoppingPrices);
    getTotals();
  }

  void listenNotification() =>
      NotificationAPI.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => IventoryPage(),
      ));

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => totals(context));
    return Scaffold(
      appBar: AppBar(
          title: const Text('Grocery List'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13)),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 252, 95, 13),
        child: Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const WidgetSpan(
                    child: Icon(Icons.add, size: 19),
                  ),
                  TextSpan(
                    text:
                        "Estimated Total: " + estimatePrices.toString() + "\n",
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
                  const WidgetSpan(
                    child: Icon(Icons.shopping_cart, size: 19),
                  ),
                  TextSpan(
                    text: "Total: " + shoppingPrices.toString(),
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                    ),
                  ),
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
                            double price = documentSnapshot['price'];

                            if (documentSnapshot['bought'] == true) {
                              shoppingPrices = shoppingPrices - price;
                            }
                            estimatePrices =
                                estimatePrices - documentSnapshot['price'];
                            GLdelete(price, documentSnapshot['bought']);
                            _products.doc(documentSnapshot.id).delete();
                            //getTotals();

                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'You have successfully deleted a grocery list item',
                                ),
                              ),
                            );

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
                          getTotals();
                          setState(() {});
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

                      ChckUpdate(documentSnapshot['price'],
                          !documentSnapshot['bought']);
                      if (!documentSnapshot['bought'] == true) {
                        shoppingPrices += documentSnapshot['price'];
                      } else {
                        shoppingPrices =
                            shoppingPrices - documentSnapshot['price'];
                      }
                      setState(() {});

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
                        NotificationAPI.showNotification(
                            title: 'Happy Muncher',
                            body:
                                '$itemName has been added to inventory. Please go the the inventory page to edit the quantity and expiration date',
                            payload: 'groceryList');
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
        key: const Key('speed_dial_button'),
        icon: Icons.add,
        children: [
          SpeedDialChild(
            onTap: () {
              addGLDialog(context);
              getTotals();
              setState(() {});
            },
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
          if (line.text.contains("XTRASAVE")) {
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

  void getTotals() async {
    print('fetching');
    String? e = '';
    String? s = '';
    var es;
    var sh;
    var collection = FirebaseFirestore.instance.collection('GL totals');
    //userUid is the current auth user
    var docSnapshot = await collection.doc('Totals').get();

    Map<String, dynamic> data = docSnapshot.data()!;

    e = data['estimated total'].toString();
    s = data['shopping total'].toString();
    estimatePrices = double.parse(e);
    shoppingPrices = double.parse(s);

    // print(sh);
    if (mounted) {
      setState(() {});
    }
  }

  void GLdelete(double price, bool bought) async {
    String? e = '';
    String? s = '';
    double estimate = 0.0;
    double shopped = 0.0;
    var collection = FirebaseFirestore.instance.collection('GL totals');
    //userUid is the current auth user
    var docSnapshot = await collection.doc('Totals').get();

    Map<String, dynamic> data = docSnapshot.data()!;

    e = data['estimated total'].toString();
    s = data['shopping total'].toString();

    estimate = double.parse(e);
    estimate = estimate - price;

    if (bought == true) {
      shopped = double.parse(s);
      shopped = shopped - price;
    }

    await _gltotals
        .doc('Totals')
        .update({"estimated total": estimate, "shopping total": shopped});
  }

  void ChckUpdate(double price, bool bought) async {
    String? e = '';
    double shopped = 0.0;
    var collection = FirebaseFirestore.instance.collection('GL totals');
    //userUid is the current auth user
    var docSnapshot = await collection.doc('Totals').get();

    Map<String, dynamic> data = docSnapshot.data()!;

    e = data['shopping total'].toString();

    shopped = double.parse(e);

    if (bought == false) {
      //unchecked
      shopped = shopped - price;
    } else {
      //checked
      shopped = shopped + price;
    }
    await _gltotals.doc('Totals').update({
      "shopping total": shopped,
    });
  }
}

class ReceiptItem {
  final String itemName;
  final double itemPrice;

  ReceiptItem({required this.itemName, required this.itemPrice});
}
