import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.api.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tasty.api.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/recipe_card.dart';
import 'package:happy_mucher_frontend/tasty_card.dart';
import 'package:happy_mucher_frontend/pages/tasty_book.dart';
import 'package:happy_mucher_frontend/pages/createRecipe.dart';
import 'package:happy_mucher_frontend/pages/editRecipe.dart';
//import 'package:http/http.dart' as http;
import 'package:happy_mucher_frontend/pages/individualRecipe.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class MyRecipeBook extends StatefulWidget {
  MyRecipeBook({Key? key}) : super(key: key);
  @override
  State<MyRecipeBook> createState() => MyRecipeBookState();
}

class MyRecipeBookState extends State<MyRecipeBook> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = GetIt.I.get();
  int shoppingPrices = 0;
  int estimatePrices = 0;
  CollectionReference get _recipes =>
      firestore.collection('Users').doc(uid).collection('CustomRecipe');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("here");
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('CustomRecipe')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //print("RECIPE");
        print(doc["details"][3]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('MY recipe book'),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 252, 95, 13)),
      body: Row(
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
            stream: _recipes.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  key: const Key('recipes_lv'),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    print(documentSnapshot['details'][0]);
                    return Slidable(
                      key: Key(documentSnapshot['details'][0]),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                _recipes.doc(documentSnapshot.id).delete();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You have successfully deleted this recipe',
                                    ),
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'You have successfully deleted this recipe',
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditRecipe(
                                            document: documentSnapshot,
                                            //edit: true,
                                            title: documentSnapshot['details']
                                                [0],
                                            description:
                                                documentSnapshot['details'][1],
                                            calories: double.parse(
                                                documentSnapshot['details'][2]),
                                            cookTime:
                                                documentSnapshot['details'][3],
                                            ingredients:
                                                documentSnapshot['ingredients']
                                                    .cast<String>(),
                                            steps:
                                                documentSnapshot['instructions']
                                                    .cast<String>(),
                                          )));
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          )
                        ],
                      ),
                      child: ListTile(
                        //controlAffinity: ListTileControlAffinity.leading,
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => IndividualRecipe(
                            name: documentSnapshot['details'][0],
                            description: documentSnapshot['details'][1],
                            image: "",
                            id: 0,
                            ingredients:
                                documentSnapshot['ingredients'].cast<String>(),
                            cookTime: documentSnapshot['details'][3],
                            calories:
                                double.parse(documentSnapshot['details'][2]),
                            instructions:
                                documentSnapshot['instructions'].cast<String>(),
                          ),
                        )),
                        title: Text(documentSnapshot['details'][0]),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Create(
                        title: "",
                        calories: 0.0,
                        cookTime: "0",
                        description: "",
                        ingredients: [],
                        steps: [],
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

                    // return ListTile(
                    //   //controlAffinity: ListTileControlAffinity.leading,
                    //   title: Text(documentSnapshot['details'][0]),
                    // );