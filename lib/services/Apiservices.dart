import 'package:flutter/material.dart';

class ApiServices{
  static String base_url = "https://api.weatherapi.com/v1/current.json?key=527ce7f89c924b1194c132938221501&q=";
  static String airforcast_baseurl = "http://api.openweathermap.org/data/2.5/air_pollution/forecast?";
  static String airp_baseurl = "http://api.openweathermap.org/data/2.5/air_pollution?";
  static String key = "6b74919536612050173adcf393d3f8e5";
  static String city_url = "&q=";
  static String address = "";
  static String api = "&aqi=no";
  static String onapicall = "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${longi}&exclude=hourly,daily&appid=${key}";
  static String lat = "";
  static String longi ="";
  static String img_url = "http://openweathermap.org/img/w/";
  static String airpolution_url = "lat=${lat}&lon=${longi}&appid=${key}";
}