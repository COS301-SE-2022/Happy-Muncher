import 'package:flutter/material.dart';
//import 'package:todo_app_ui_example/widget/todo_form_widget.dart';
import 'package:happy_mucher_frontend/addIngredient_widget.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';

class AddIngredientDialog extends StatefulWidget {
  List<String> ingredients = [];

  AddIngredientDialog({required this.ingredients});
  @override
  _AddIngredientDialogState createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  final _formKey = GlobalKey<FormState>();
  String ingredient = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Ingredient',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            IngredientFormWidget(
              onChangedTitle: (title) => setState(() {
                print(title);
                widget.ingredients.add(title);
              }),
              addedIng: () {},
            ),
          ],
        ),
      );
}
