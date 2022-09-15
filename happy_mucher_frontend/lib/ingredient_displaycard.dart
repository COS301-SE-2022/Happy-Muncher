import 'package:flutter/material.dart';

class ingredientCard extends StatelessWidget {
  final String ingredient;

  ingredientCard({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    Color llGrey = Color(0xFF555555);
    Color lightGrey = Color(0xFF2D2C31); //ingredients block
    Color darkGrey = Color(0xFF212025); //ingredients background
    Color mediumGrey = Color(0xFF39383D);
    Color offWhite = Color(0xFFDFDEE3);

    return Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: lightGrey))),
        child: Text(ingredient));
  }
}
