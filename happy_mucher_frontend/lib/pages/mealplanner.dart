import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/dialogs/add_meal.dialog.dart';
import 'package:intl/intl.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key}) : super(key: key);

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  static final dateFormat = DateFormat('yyyy-MM-dd');

  List<MealItem> MealList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.fastfood),
        title: const Text(
          'Meal Planner',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: const Key('Meal_ListView'),
              itemCount: MealList.length,
              itemBuilder: (context, index) {
                final item = MealList[index];

                return ListTile(
                  title: Text(' ${item.itemName}'),
                  trailing: Text(dateFormat.format(item.expirationDate)),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: IconButton(
                  key: const Key('addToMealButton'),
                  onPressed: () async {
                    final returnedItem = await addMealDialog(context);
                    if (returnedItem != null) {
                      setState(() {
                        MealList.add(MealItem(
                          itemName: returnedItem.name,
                          expirationDate: returnedItem.date,
                        ));
                      });
                    }
                  },
                  icon: const Icon(Icons.add_circle),
                  iconSize: 64.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//STRUCTURE
//SCAFFOLD
//  APPBAR
//    ICON + TEXT
//  COLUMN
//    EXPANDED (TO FILL UP SCREEN)
//      LISTVIEW (LIST OF TILES)
//       LIST TILE (LIST THAT CONTAINS INFO)
//         TEXT + TEXT
//    ROW (BOTTOM 2 BUTTONS)
//      PADDING
//        ICONBUTTON
//      PADDING
//        ICONBUTTON

//CLASS OF THE RETURNED LIST ITEM
class MealItem {
  final String itemName;
  final DateTime expirationDate;

  MealItem({
    required this.itemName,
    required this.expirationDate,
  });
}
