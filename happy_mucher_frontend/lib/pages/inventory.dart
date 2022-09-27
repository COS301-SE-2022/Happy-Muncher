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
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:camera/camera.dart';
import 'package:happy_mucher_frontend/models/barcode_api.dart';
import 'package:happy_mucher_frontend/models/barcode_data.dart';
import 'package:happy_mucher_frontend/dialogs/add_bar.dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IventoryPage extends StatefulWidget {
  const IventoryPage({Key? key}) : super(key: key);

  @override
  State<IventoryPage> createState() => _IventoryPageState();
}

class _IventoryPageState extends State<IventoryPage> {
  final ImagePicker picker = ImagePicker();
  String? imagepath;
  // text fields' controllers
  // text fields' controllers
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expController = TextEditingController();

  String _scanBarcode = 'Unknown';

  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;
  CameraController? controller;

  bool fetchingBarcode = true;
  String barcode = "";

  List<BarcodeData> scanResult = [];
  final TextEditingController inputController = TextEditingController();

  String itemName = "";

  CollectionReference get _products =>
      firestore.collection('Users').doc(uid).collection('Inventory');

  late final LocalNotificationService service;
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
        builder: (context) => IventoryPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Inventory"),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData && fetchingBarcode == true) {
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
                          service.cancel(LocalNotificationService.getID());
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
        key: const Key('addToInventoryButton'),
        backgroundColor: Color.fromARGB(255, 150, 66, 154),
        children: [
          SpeedDialChild(
            onTap: () => addInventoryDialog(context),
            key: const Key('addToInventoryButtonText'),
            child: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
            backgroundColor: Color.fromARGB(255, 158, 115, 198),
          ),
          SpeedDialChild(
              onTap: () => getImage(ImageSource.camera),
              child: const Icon(
                CupertinoIcons.barcode_viewfinder,
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 185, 141, 223)),
        ],
      ),

      // FloatingActionButton(
      //   backgroundColor: Color.fromARGB(255, 172, 255, 78),
      //   key: const Key('addToInventoryButton'),
      //   onPressed: () => addInventoryDialog(context),
      //   child: const Icon(Icons.add),
      // ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  void getImage(ImageSource image) async {
    // XFile? file = await ImagePicker().pickImage(source: image);
    final photo = await ImagePicker().pickImage(source: image);
    if (photo != null) {
      imagepath = photo.path;
      setState(() {});
      processImage(photo);
    }
  }
  //imagefile Xfile

//using ML kit
  Future<void> processImage(XFile image) async {
    String vals = "";
    final inputImage = InputImage.fromFilePath(image.path);
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
      for (final bar in barcodes) {
        vals += '${bar.rawValue}';

        //print(bar);
        //print("text " + text);
      }
    }
    _isBusy = false;
    barcode = vals;
    if (mounted) {
      setState(() {});
    }
    //print("String: " + barcode);

    getItemName(barcode);
  }

  Future<void> getItemName(String barcode) async {
    //6009522300623
    //009542020316
    //recipes = await RecipeAPI.getRecipe();
    fetchingBarcode = false;
    print(barcode);
    try {
      scanResult = await BarcodeAPI.getBarcode(barcode);
      itemName = scanResult[0].name;
      fetchingBarcode = true;
    } catch (e) {
      //print("here");
      itemName = "unknown";
    }

    print(itemName);
    //showResultDialog(context);
    setState(() {});
    addbarD(context, itemName);
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
