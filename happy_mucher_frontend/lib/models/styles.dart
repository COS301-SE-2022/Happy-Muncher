import 'dart:ui';

import 'package:flutter/material.dart';

abstract class Styles {
  //colors
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff0000000);
  static const Color orangeColor = Colors.orange;
  static const Color redColor = Colors.red;
  static const Color darkRedColor = Color(0xFFB71C1C);

  static const Color purpleColor = Color(0xff5E498A);

  static const Color darkThemeColor = Color(0xff33333E);

  static const Color grayColor = Color(0xff797979);

  static const Color greyColorLight = Color(0xffd7d7d7);

  static const Color settingsBackground = Color(0xffefeff4);

  static const Color settingsGroupSubtitle = Color(0xff777777);

  static const Color iconBlue = Color(0xff0000ff);
  static const Color transparent = Colors.transparent;
  static const Color iconGold = Color(0xffdba800);
  static const Color bottomBarSelectedColor = Color(0xff5e4989);

  //Strings
  static const TextStyle defaultTextStyle = TextStyle(
    color: Styles.purpleColor,
    fontSize: 20.0,
  );
  static const TextStyle defaultTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 20.0,
  );
  static const TextStyle defaultTextStyleGRey = TextStyle(
    color: Styles.grayColor,
    fontSize: 20.0,
  );
  static const TextStyle smallTextStyleGRey = TextStyle(
    color: Styles.grayColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyle = TextStyle(
    color: Styles.purpleColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyleWhite = TextStyle(
    color: Styles.whiteColor,
    fontSize: 16.0,
  );
  static const TextStyle smallTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 16.0,
  );
  static const TextStyle defaultButtonTextStyle =
      TextStyle(color: Styles.whiteColor, fontSize: 20);

  static const TextStyle profileTextStyleBlack = TextStyle(
    color: Styles.blackColor,
    fontSize: 20.0,
  );

  static const TextStyle defaultTextStyleWhite = TextStyle(
    color: Styles.whiteColor,
    fontSize: 20.0,
  );
  static const TextStyle messageRecipientTextStyle = TextStyle(
      color: Styles.blackColor, fontSize: 16.0, fontWeight: FontWeight.bold);

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        //* Custom Google Font
        //  fontFamily: Devfest.google_sans_family,
        primarySwatch: Colors.purple,
        //primarySwatch: Colors.red,
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: TextButton.styleFrom(
        //         backgroundColor: isDarkTheme ? Colors.white : Colors.black)),
        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ButtonStyle(
        //     // Makes all my ElevatedButton green
        //     backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        //   ),
        // ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: isDarkTheme ? Color(0xFF151515) : Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: isDarkTheme
                ? Colors.white
                : Colors.black, // This is a custom color variable
          ),
        ),
        primaryColor: isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme ? Colors.grey : Color(0xffF1F5FB),
        indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
        buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
        hintColor:
            isDarkTheme ? Colors.grey : Color.fromARGB(255, 107, 105, 106),
        highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
        hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
        focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
        disabledColor: Colors.grey,
        textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
        cardColor: isDarkTheme ? Color.fromARGB(153, 0, 0, 0) : Colors.white,
        canvasColor: isDarkTheme ? Color(0xFF212025) : Color(0xFFDFDEE3),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        buttonTheme: ButtonThemeData(
          buttonColor:
              isDarkTheme ? Color.fromARGB(255, 6, 143, 255) : Colors.orange,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: isDarkTheme
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          elevation: 0.0,
          actionsIconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
        ));
  }
}
