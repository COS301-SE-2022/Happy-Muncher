import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/models/myRecipe.dart';

class ComponentCard extends StatelessWidget {
  //final myRecipe recipe;
  final String ingredient;
  const ComponentCard({required this.ingredient});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(ingredient),
        leading: Text("\u2022 "),
        trailing:
            IconButton(onPressed: () {}, icon: Icon(Icons.close)),
      );
}
// Row(
//         children: [
//           const Icon(
//             Icons.star,
//             color: Colors.orange,
//           ),
//           Expanded(
//             child: Text(ingredient),
//           ),
//         ],
//       );