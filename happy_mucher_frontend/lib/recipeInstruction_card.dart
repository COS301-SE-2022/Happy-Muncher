import 'package:flutter/material.dart';

class InstructionCard extends StatelessWidget {
  final String instruction;
  final int step;

  InstructionCard({required this.instruction, required this.step});

  @override
  Widget build(BuildContext context) {
    Color llGrey = Color(0xFF555555);
    Color lightGrey = Color(0xFF2D2C31); //ingredients block
    Color darkGrey = Color(0xFF212025); //ingredients background
    Color mediumGrey = Color(0xFF39383D);
    Color offWhite = Color(0xFFDFDEE3);

    return Flexible(
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
            // decoration: BoxDecoration(
            //     border: Border(bottom: BorderSide(color: llGrey, width: 2))),
            color: lightGrey,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " " + step.toString() + "   ",
                  style: TextStyle(
                    color: offWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                    child: Text(
                  instruction,
                  style: TextStyle(color: offWhite, fontSize: 15),
                ))
              ],
            )));
  }
}
