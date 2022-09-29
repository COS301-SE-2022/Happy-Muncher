import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_instruction.dialog.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';
import 'package:happy_mucher_frontend/dialogs/add_ingredient_dialog.dart';
import 'package:happy_mucher_frontend/componentcard.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/myRecipeBook.dart';
//import 'package:http/http.dart' as http;

class EditRecipe extends StatefulWidget {
  EditRecipe(
      {Key? key,
      required this.title,
      required this.calories,
      required this.cookTime,
      required this.description,
      required this.ingredients,
      required this.steps,
      required this.document})
      : super(key: key);
  String title;
  double calories = 0.0;
  String cookTime = "0";
  String description = "";
  List<String> ingredients = [];
  List<String> steps = [];
  DocumentSnapshot document;

  @override
  State<EditRecipe> createState() => EditRecipeState();
}

class EditRecipeState extends State<EditRecipe> {
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _customRecipe =>
      firestore.collection('Users').doc(uid).collection('CustomRecipe');

  final ImagePicker _picker = ImagePicker();
  //Recipe recipe = Recipe();
  //myRecipe recipe = myRecipe(name: '');
  int selectedIndex = 0;

  bool ingEdit = false;

  final ingController = TextEditingController();
  //final List<String> ingredients = <String>[];
  TextEditingController titleController = TextEditingController();
  TextEditingController cooktimeController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> myRecipe = [];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    cooktimeController.text = widget.cookTime;
    caloriesController.text = widget.calories.toString();
    descriptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        centerTitle: true,
        leading: TextButton(
          onPressed: () {
            myRecipe = [];
            myRecipe.add(widget.title);
            myRecipe.add(widget.description);
            myRecipe.add(widget.calories.toString());
            myRecipe.add(widget.cookTime);
            _customRecipe.doc(widget.document.id).update({
              "details": myRecipe,
              "instructions": widget.steps,
              "ingredients": widget.ingredients
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyRecipeBook()));
          },
          child: const Text(
            "Done",
            textAlign: TextAlign.right,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Enter your Recipe Title ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          TextField(
              key: const Key("enterTitleEdit"),
              controller: titleController,
              decoration: const InputDecoration(
                hintText: ('Title'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                setState(() {
                  widget.title = titleController.text;
                });

                //print(title);
              })
              // autofocus: true,
              ),
          const SizedBox(height: 14),
          TextField(
              key: const Key("descriptionEdit"),
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: ('Description'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                setState(() {
                  widget.description = descriptionController.text;
                });

                //print(title);
              })
              // autofocus: true,
              ),
          const SizedBox(height: 14),
          TextField(
              key: const Key("entercaloriesEdit"),
              controller: caloriesController,
              decoration: const InputDecoration(
                hintText: ('Calories'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                setState(() {
                  widget.calories = double.parse(caloriesController.text);
                });

                //print(calories);
              })
              // autofocus: true,
              ),
          const SizedBox(height: 14),
          TextField(
              key: const Key("entertimeEdit"),
              controller: cooktimeController,
              decoration: const InputDecoration(
                hintText: ('Cook Time'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                setState(() {
                  widget.cookTime = cooktimeController.text;
                });

                //print(cookTime);
              })
              // autofocus: true,
              ),
          const Text('Enter your Ingredients ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.ingredients.map((String item) {
                return ListTile(
                  title: Text(item),
                  leading: Text("\u2022 "),
                  trailing: IconButton(
                      onPressed: () {
                        print('Deleting');
                        widget.ingredients.remove(item);
                        _customRecipe.doc(widget.document.id).update({
                          //"details": myRecipe,
                          //"instructions": widget.steps,
                          "ingredients": widget.ingredients
                        });
                        setState(() {
                          print(widget.ingredients);
                        });
                      },
                      icon: Icon(Icons.close)),
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SpeedDial(
              key: const Key('speed_dial_buttonEdit'),
              icon: Icons.add,
              backgroundColor: Color.fromARGB(255, 150, 66, 154),
              children: [
                SpeedDialChild(
                  key: const Key('addToIngredientsButtonCameraEdit'),
                  onTap: () async {
                    final newIngredients = await captureImageReceiptIngredients(
                        ImageSource.camera);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newIngredients.length; i++) {
                        widget.ingredients.add(newIngredients[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 158, 115, 198),
                ),
                SpeedDialChild(
                  key: const Key('addToIngredientsButtonGalleryEdit'),
                  onTap: () async {
                    final newIngredients = await captureImageReceiptIngredients(
                        ImageSource.gallery);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newIngredients.length; i++) {
                        widget.ingredients.add(newIngredients[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.collections,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 185, 141, 223),
                ),
                SpeedDialChild(
                  onTap: () async {
                    final newIngredient = await showAddIngredientDialog(
                      context,
                      widget.ingredients,
                    );
                    if (newIngredient != null) {
                      setState(() {
                        //used to refresh list
                        widget.ingredients.add(newIngredient);
                      });
                    }
                  },
                  key: const Key('addToIngredientsyButtonTextEdit'),
                  child: const Icon(
                    Icons.abc,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 198, 158, 234),
                ),
              ],
            ),
          ),
          const Text('Enter your Instructions ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.steps.map((String item) {
                return ListTile(
                  title: Text(item),
                  leading: Text("\u2022 "),
                  trailing: IconButton(
                      onPressed: () {
                        print('Deleting');
                        widget.steps.remove(item);
                        _customRecipe.doc(widget.document.id).update({
                          //"details": myRecipe,
                          //"instructions": widget.steps,
                          "instructions": widget.steps
                        });
                        setState(() {
                          print(widget.steps);
                        });
                      },
                      icon: Icon(Icons.close)),
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SpeedDial(
              key: const Key('speed_dial_button_steps_edit'),
              icon: Icons.add,
              backgroundColor: Color.fromARGB(255, 150, 66, 154),
              children: [
                SpeedDialChild(
                  key: const Key('editIngredientsButtonCamera'),
                  onTap: () async {
                    final newSteps =
                        await captureImageReceiptRecipe(ImageSource.camera);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newSteps.length; i++) {
                        widget.steps.add(newSteps[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 158, 115, 198),
                ),
                SpeedDialChild(
                  key: const Key('editIngredientsButtonGallery'),
                  onTap: () async {
                    final newSteps =
                        await captureImageReceiptRecipe(ImageSource.gallery);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newSteps.length; i++) {
                        widget.steps.add(newSteps[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.collections,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 185, 141, 223),
                ),
                SpeedDialChild(
                  onTap: () async {
                    final newInstruction = await showAddInstructionDialog(
                      context,
                      widget.ingredients,
                    );
                    if (newInstruction != null) {
                      setState(() {
                        //used to refresh list
                        widget.steps.add(newInstruction);
                      });
                    }
                  },
                  key: const Key('editIngredientsButtonText'),
                  child: const Icon(
                    Icons.abc,
                    color: Colors.white,
                  ),
                  backgroundColor: Color.fromARGB(255, 198, 158, 234),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> captureImageReceiptIngredients(
      ImageSource imageSource) async {
    final image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return [];
    }
    final croppedImagePath = await cropImage(image.path);
    if (croppedImagePath == null) {
      return [];
    }

    final ingredients = await getRecognisedTextIngredients(croppedImagePath);
    return ingredients;
  }

  Future<List<String>> captureImageReceiptRecipe(
      ImageSource imageSource) async {
    final image = await _picker.pickImage(source: imageSource);
    if (image == null) {
      return [];
    }
    final croppedImagePath = await cropImage(image.path);
    if (croppedImagePath == null) {
      return [];
    }

    final steps = await getRecognisedTextRecipe(croppedImagePath);
    return steps;
  }

  Future<String?> cropImage(String path) async {
    final cropped =
        await ImageCropper().cropImage(sourcePath: path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false)
    ]);
    return cropped?.path;
  }

  Future<List<String>> getRecognisedTextIngredients(String path) async {
    final image = await decodeImageFromList(File(path).readAsBytesSync());
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    //final listOfItems = <ReceiptItem>[];
    final listOfText = <String>[];
    final listOfTempItems = <String>[];

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final textLower = line.text.toLowerCase();
        listOfTempItems.add(textLower);
      }
    }

    for (final text in listOfTempItems) {
      if (text.contains('•')) {
        final newName = text.replaceAll('•', '');
        listOfText.add(newName);
        continue;
      }
      if (text.contains('optional')) {
        continue;
      }
      if (text.contains('method')) {
        continue;
      }
      listOfText.add(text);
    }

    return listOfText;
  }

  Future<List<String>> getRecognisedTextRecipe(String path) async {
    final image = await decodeImageFromList(File(path).readAsBytesSync());
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    //final listOfItems = <ReceiptItem>[];
    String string = "";
    var listOfText = <String>[];
    var listOfFinalText = <String>[];

    for (TextBlock block in recognizedText.blocks) {
      string += block.text;
    }
    listOfText = string.split('.');

    if (listOfText.last == " " || listOfText.last == "") {
      listOfText.removeLast();
    }

    RegExp numbers = RegExp("^[0-9]");

    for (var item in listOfText) {
      if (item.contains('\n')) {
        var newItem = item.replaceAll('\n', '');
        if (numbers.hasMatch(newItem)) {
          continue;
        }
        listOfFinalText.add(newItem);
        continue;
      } else if (numbers.hasMatch(item)) {
        continue;
      }
      listOfFinalText.add(item);
    }

    return listOfFinalText;
  }
}
