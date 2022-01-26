import 'package:flutter/material.dart';

class MyColors{

  static const primaryColor = Color(0xFF00008B);
  static const lightorangeColor = Color(0x73fc6011);
  static const blackColor54 = Colors.black54;
  static const whiteColor = Colors.white;
  static const lightBlackColor = Color(0xFFF2F2F2);
  static const lightBlackColor26 = Color(0xFFD8D8D8);
  static const greycolor = Colors.grey;
  static const lightwhite = Color(0xFF362A2A);
  static const bluecolor = Color(0xff1260CC);
  static const textColorAbovePrimaryColor =Color(0xffefefef);
  static const skyblue = Color(0xff29afce);
  static const lightskyblue = Colors.cyan;
  static const greenColor = Colors.green;
  static const lightsky = Color(0xFFFE3F2FD);
  static const blackColor = Colors.black;
  static const orange = Color(0xFFDA4C05);
  static const lightorange = Color(0x71E8B197);

  static const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    //Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
    colors: <Color>[
      bluecolor,
      skyblue,
      lightskyblue
    ], // red to yellow
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );
  static const gradient2 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    //Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
    colors: <Color>[
      orange,
      Colors.yellow,
      orange
    ], // red to yellow
    tileMode: TileMode.repeated, // repeats the gradient over the canvas
  );
}