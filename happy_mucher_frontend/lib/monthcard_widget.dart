import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/month.dart';

class MonthCard extends StatefulWidget {
  const MonthCard({Key? key, required this.image, required this.month})
      : super(key: key);
  final String image;
  final String month;
  @override
  State<MonthCard> createState() => MonthCardState();
}

class MonthCardState extends State<MonthCard> {
  @override
  Widget build(BuildContext context) {
   return
    buildMonthcard();
  }

  Widget buildMonthcard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: AssetImage(widget.image),
              child: InkWell(
                key: Key(widget.month),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  Month(month: widget.month
                    ),
                  ));
                },
              ),
              height: 130,
              fit: BoxFit.cover,
            )
          ],
        ),
      );
}
