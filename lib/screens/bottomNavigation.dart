import 'package:flutter/material.dart';
import 'package:weather/widget/mycolor.dart';

import 'Home.dart';
import 'air_quality.dart';

class BottomNavigationpage extends StatefulWidget {
  const BottomNavigationpage({Key? key}) : super(key: key);

  @override
  _AirQualityState createState() => _AirQualityState();
}

class _AirQualityState extends State<BottomNavigationpage> {

  int pageIndex = 0;
  final pages = [AirQualitypage(),];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.skyblue,
        title: Text("Air Quality",style: TextStyle(color: Colors.white,fontSize: 20),
        ),
      ),


    );
  }
}
