import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/pages/myRecipeBook.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:happy_mucher_frontend/pages/favourites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//import 'package:http/http.dart' as http;

class RecipeBook extends StatefulWidget {
  RecipeBook({Key? key}) : super(key: key);
  @override
  State<RecipeBook> createState() => RecipeBookState();
}

class RecipeBookState extends State<RecipeBook> {
  final FirebaseAuth firebaseAuth = GetIt.I.get();
  String get uid => firebaseAuth.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();

  CollectionReference get _favourites =>
      firestore.collection('Users').doc(uid).collection('Recipes');

  //List<Recipe> recipes = [];
  //List<tastyRecipe> tr = [];
  //bool loading = true;
  List<String> ids = [];
  @override
  void initState() {
    // TODO: implement initState
    //getIDs();
    super.initState();
  }

  void getIDs() async {
    // print("GetIds");
    _favourites.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (ids == null) {
          ids.add(doc["ID"]);
        }
        if (ids != null && !ids.contains(doc["ID"])) {
          ids.add(doc["ID"]);
        }

        // print(ids);
      });
    });
    setState(() {
      ids = ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: buildAppBar(context, "Recipe Book"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size(300, 100),
                    onPrimary: const Color.fromARGB(255, 150, 66, 154),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TastyBook()));
                  },
                  child: Text(
                    "Tasty Recipe Book",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  )),
              SizedBox(height: size.height * 0.06),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size(300, 100),
                    onPrimary: const Color.fromARGB(255, 150, 66, 154),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyRecipeBook()));
                  },
                  child: Text(
                    "My Recipe Book",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  )),
              SizedBox(height: size.height * 0.06),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size(300, 100),
                    onPrimary: const Color.fromARGB(255, 150, 66, 154),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 150, 66, 154), width: 3.0),
                  ),
                  onPressed: () {
                    //ids = [];
                    setState(() {
                      //getIDs();
                      //print(ids);
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouritesBook(ids: ids)));
                  },
                  child: Text(
                    "My Favourites",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  )),
            ],
          ),
        ));
  }
}
