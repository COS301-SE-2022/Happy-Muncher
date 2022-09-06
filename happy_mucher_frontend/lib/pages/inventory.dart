import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:happy_mucher_frontend/dialogs/add_inventory.dialog.dart';
import 'package:happy_mucher_frontend/dialogs/update_inventory.dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:happy_mucher_frontend/pages/notification.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:camera/camera.dart';
import 'package:happy_mucher_frontend/models/barcode_api.dart';
import 'package:happy_mucher_frontend/models/barcode_data.dart';

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

  final FirebaseFirestore firestore = GetIt.I.get();
  String _scanBarcode = 'Unknown';
  CollectionReference get _products => firestore.collection('Inventory');

  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;
  CameraController? controller;

  String barcode = "";

  List<BarcodeData> scanResult = [];
  final TextEditingController inputController = TextEditingController();

  String itemName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 252, 95, 13),
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              key: const Key('Inventory_ListView'),
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Slidable(
                  key: Key(documentSnapshot['itemName']),
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
                                        'You have successfully deleted a product')));
                          });
                          NotificationAPI.cancel(NotificationAPI.getID());
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          showUpdateDialog(context, documentSnapshot);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      )
                    ],
                  ),
                  child: ListTile(
                    title: Text(documentSnapshot['quantity'].toString() +
                        ' \u{00D7} ' +
                        documentSnapshot['itemName'] +
                        ' '),
                    trailing:
                        Text(documentSnapshot['expirationDate'].toString()),
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
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            onTap: () => addInventoryDialog(context),
            key: const Key('addToInventoryButtonText'),
            child: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 172, 255, 78),
          ),
          SpeedDialChild(
            onTap: () => scanBarcodeNormal(),
            child: const Icon(
              Icons.photo_camera,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 147, 182, 106),
          ),
          SpeedDialChild(
            onTap: () => showInputDialog(context),
            child: const Icon(
              CupertinoIcons.barcode_viewfinder,
              color: Color.fromARGB(255, 70, 70, 70),
            ),
            backgroundColor: Colors.grey,
          )
        ],
      ),

      // FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255, 172, 255, 78),
      //   key: const Key('addToInventoryButton'),
      //   onPressed: () => addInventoryDialog(context),
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    print("scan barcode normal");
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      print("scanning");
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on Exception {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

//using ML kit
  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
    } else {
      String text = 'Barcodes found: ${barcodes.length}\n\n';
      for (final barcode in barcodes) {
        text += 'Barcode: ${barcode.rawValue}\n\n';
      }
      _text = text;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getItemName(String barcode) async {
    //6009522300623
    //009542020316
    //recipes = await RecipeAPI.getRecipe();
    //print("barcode: " + barcode);
    scanResult = await BarcodeAPI.getBarcode(barcode);
    itemName = scanResult[0].name;

    showResultDialog(context);
    setState(() {});
  }

  showInputDialog(BuildContext context) {
    AlertDialog input = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              controller: inputController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text('barcode'),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('groceryListDialogAddButton'),
          onPressed: () async {
            setState(() {
              this.barcode = inputController.text;
              //print(inputController.text);
              getItemName(barcode);
            });
          },
          child: const Text('Add'),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return input;
      },
    );
  }

  showResultDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      content: Text(itemName),
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
