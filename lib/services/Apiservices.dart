import 'package:flutter/material.dart';

class ApiServices{
  static String base_url = "https://api.weatherapi.com/v1/current.json?key=527ce7f89c924b1194c132938221501&q=";
  static String key = "527ce7f89c924b1194c132938221501";
  static String city_url = "&q=";
  static String address = "";
  static String api = "&aqi=no";
  static String onapicall = "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${longi}&exclude=hourly,daily&appid=${key}";
  static String lat = "";
  static String longi ="";
  static String img_url = "http://openweathermap.org/img/w/";
}