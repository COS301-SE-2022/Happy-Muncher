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

//import 'package:http/http.dart' as http;

class Create extends StatefulWidget {
  Create({Key? key}) : super(key: key);
  @override
  State<Create> createState() => CreateState();
}

class CreateState extends State<Create> {
  final ImagePicker _picker = ImagePicker();
  //Recipe recipe = Recipe();
  myRecipe recipe = myRecipe(name: '');
  String title = "my Recipe";
  int selectedIndex = 0;
  static List<String> ingredients = [];
  static List<String> steps = [];
  bool ingEdit = false;

  final ingController = TextEditingController();
  //final List<String> ingredients = <String>[];
  final titleController = TextEditingController();
  final cooktimeController = TextEditingController();
  final caloriesController = TextEditingController();
  final preptimeController = TextEditingController();

  String cookTime = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create Recipe'),
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              recipe = myRecipe(
                name: title,
                //navigate back to other page
              );
            },
            child: const Text("Done"),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 95, 13)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Enter your Recipe Title ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          TextField(
              key: const Key("enterTitle"),
              controller: titleController,
              decoration: const InputDecoration(
                hintText: ('Title'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onSubmitted: ((value) {
                title = titleController.text;
                print(title);
              })
              // autofocus: true,
              ),
          const Text('Enter your Ingredients ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ingredients.map((String item) {
                return ComponentCard(
                  ingredient: item,
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SpeedDial(
              key: const Key('speed_dial_button'),
              icon: Icons.add,
              children: [
                SpeedDialChild(
                  onTap: () async {
                    final newIngredient = await showAddIngredientDialog(
                      context,
                      ingredients,
                    );
                    if (newIngredient != null) {
                      setState(() {
                        //used to refresh list
                        ingredients.add(newIngredient);
                      });
                    }
                  },
                  key: const Key('addToIngredientsyButtonText'),
                  child: const Icon(
                    Icons.abc,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                ),
                SpeedDialChild(
                  key: const Key('addToIngredientsButtonGallery'),
                  onTap: () async {
                    final newIngredients = await captureImageReceiptIngredients(
                        ImageSource.gallery);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newIngredients.length; i++) {
                        ingredients.add(newIngredients[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.collections,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                ),
                SpeedDialChild(
                  key: const Key('addToIngredientsButtonCamera'),
                  onTap: () async {
                    final newIngredients = await captureImageReceiptIngredients(
                        ImageSource.camera);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newIngredients.length; i++) {
                        ingredients.add(newIngredients[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                )
              ],
            ),
          ),
          const Text('Enter your Instructions ', style: TextStyle(height: 3.2)),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: steps.map((String item) {
                return ComponentCard(
                  ingredient: item,
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SpeedDial(
              //key: const Key('speed_dial_button'),
              icon: Icons.add,
              children: [
                SpeedDialChild(
                  onTap: () async {
                    final newInstruction = await showAddInstructionDialog(
                      context,
                      ingredients,
                    );
                    if (newInstruction != null) {
                      setState(() {
                        //used to refresh list
                        steps.add(newInstruction);
                      });
                    }
                  },
                  //key: const Key('addToInventoryButtonText'),
                  child: const Icon(
                    Icons.abc,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                ),
                SpeedDialChild(
                  //key: const Key('addToInventoryButtonGallery'),
                  onTap: () async {
                    final newSteps =
                        await captureImageReceiptRecipe(ImageSource.gallery);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newSteps.length; i++) {
                        steps.add(newSteps[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.collections,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                ),
                SpeedDialChild(
                  //key: const Key('addToInventoryButtonCamera'),
                  onTap: () async {
                    final newSteps =
                        await captureImageReceiptRecipe(ImageSource.camera);
                    setState(() {
                      //used to refresh list
                      for (int i = 0; i < newSteps.length; i++) {
                        steps.add(newSteps[i]);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 172, 255, 78),
                )
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
          toolbarTitle: 'Croppper',
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

    print(listOfText);
    return listOfText;
  }

  // Future<List<String>> getRecognisedTextRecipe(String path) async {
  //   final image = await decodeImageFromList(File(path).readAsBytesSync());
  //   final inputImage = InputImage.fromFilePath(path);
  //   final textDetector = TextRecognizer();
  //   RecognizedText recognizedText = await textDetector.processImage(inputImage);
  //   await textDetector.close();
  //   //final listOfItems = <ReceiptItem>[];
  //   final listOfText = <String>[];

  //   for (TextBlock block in recognizedText.blocks) {
  //     listOfText.add(block.text);
  //   }
  //   return listOfText;
  // }

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
