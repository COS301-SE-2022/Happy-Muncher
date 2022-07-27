import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/recipe.dart';
import 'package:happy_mucher_frontend/models/tastyRecipe.dart';
import 'package:happy_mucher_frontend/pages/individualRecipe.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:happy_mucher_frontend/dialogs/add_recipe.dialog.dart';
import 'package:happy_mucher_frontend/pages/mealplanner.dart';

import 'package:cached_network_image/cached_network_image.dart';

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:social_media_app/home/home_navigator_cubit.dart';

class RecipeCard extends StatelessWidget {
  final List<tastyRecipe> recipes;

  final _dummyImage =
      'https://i1.wp.com/butwhythopodcast.com/wp-content/uploads/2020/09/maxresdefault-28.jpg?fit=1280%2C720&ssl=1';
  //List<Recipe>? recipes;
  RecipeCard({this.recipes = const []});

  final FirebaseFirestore firestore = GetIt.I.get();
  CollectionReference get _meals => firestore.collection('Meal Planner');
  String name = "";
  String images = "";
  //this.recipeid = 0,
  String totTime = "";
  String description = "";
  double calories = 0;
  List<String> ingredients = const [''];
  List<String> instructions = const [''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe books'),
      ),
      body: _postsListView(context),
    );
  }

  Widget _postAuthorRow(BuildContext context, int ind) {
    const double avatarDiameter = 44;
    return GestureDetector(
      //onTap: () => BlocProvider.of<HomeNavigatorCubit>(context).showProfile(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: avatarDiameter,
              height: avatarDiameter,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarDiameter / 2),
                child: CachedNetworkImage(
                  imageUrl: recipes[ind].images,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            recipes[ind].name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _postImage(int ind) {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: recipes[ind].images,
      ),
    );
  }

  Widget _postCaption(int ind) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Text(recipes[ind].description),
    );
  }

  Widget _postView(BuildContext context, int ind) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _postAuthorRow(context, ind),
        _postImage(ind),
        _postCaption(ind),
        //_postCommentsButton(context),
      ],
    );
  }

  Widget _postsListView(BuildContext context) {
    return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return _postView(context, index);
        });
  }
}
