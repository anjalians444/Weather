import 'package:flutter/material.dart';


class DateModel{
  int date;

  DateModel({required this.date});

  DateModel.fromJson(Map<String, dynamic> json) :
        date = json['dt'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.date;
    return data;
  }
}