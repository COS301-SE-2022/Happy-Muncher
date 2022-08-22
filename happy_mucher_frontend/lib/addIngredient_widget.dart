import 'package:flutter/material.dart';

class IngredientFormWidget extends StatelessWidget {
  final String title;
  final ValueChanged<String> onChangedTitle;
  final VoidCallback addedIng;

  const IngredientFormWidget({
    //Key key,
    this.title = '',
    required this.onChangedTitle,
    required this.addedIng,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTitle(),
            SizedBox(height: 8),
            SizedBox(height: 32),
            buildButton(),
          ],
        ),
      );

  Widget buildTitle() => TextFormField(
        //maxLines: 1,
        initialValue: title,
        onChanged: onChangedTitle,
        validator: (title) {
          if (title != null && title.isEmpty) {
            return 'The title cannot be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
        ),
      );

  Widget buildButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          onPressed: addedIng,
          child: Text('Add'),
        ),
      );
}
