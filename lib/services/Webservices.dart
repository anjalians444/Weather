import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/globalkey.dart';
import 'package:weather/model/ForcastModel.dart';
import 'package:weather/model/LocationModel.dart';
import 'package:weather/model/WeatherModel.dart';
import 'package:weather/model/currenmodel.dart';
import 'package:weather/model/dateModel.dart';
import 'package:weather/services/Apiservices.dart';

class WebServices{


static  Future<void> getData(String url,List clist,List<Weatherlist> wlist,List<Daily> dlist,List<HourlyModel> hlist) async {
   // var httpClient = new HttpClient();
    var response = await http.get(Uri.parse(url),
    // print(request.body);

        // body:convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        });
    print("res"+response.body);
    // final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    Map<String, dynamic> jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
    print("jsonres"+jsonResponse.toString());
    if (response.statusCode == 200) {
      print("response${response.body}");
      var list = jsonResponse['current'];
      // var dalist = jsonResponse['daily'];
      // print("daily..."+dalist.toString());
      CurrentModel currentModel;
      currentModel = CurrentModel.fromJson(list);
      clist.add(currentModel);
      print("listlength${list.toString()}");
      print("....${list['temp']}");
     // print("....${clist[0].}");

     // print("dlist${dlist.}")
      var weather = list['weather'];
      print("name${weather.toString()}");
      print("name${weather[0]['main']}");
      weather.forEach((element) {
        Weatherlist weatherlist = Weatherlist.fromJson(element);
        wlist.add(weatherlist);
        print("weather${weatherlist.description}");
      });
      print("weather${wlist[0].description}");
      var dailylist = jsonResponse['daily'];
      print(dailylist.toString());
      dailylist.forEach((element) {
        Daily daily = Daily.fromJson(element);
        dlist.add(daily);
       // print("daily${dlist.length}");
      });
      print("daily${dlist.length}");
      print(dlist[0].dewPoint);

      var hourlist = jsonResponse['hourly'];
      print("hour${hourlist.toString()}");
      hourlist.forEach((element) {
        HourlyModel hmodel = HourlyModel.fromJson(element);
        hlist.add(hmodel);
         print("daily${hlist.length}");
      });
       var wetlist = dailylist[0]['weather'];
       print("we...${wetlist[0]['description']}");
      wetlist.forEach((element) {
        Weatherlist wmodel = Weatherlist.fromJson(element);
        wlist.add(wmodel);
        print("daily${wlist.length}");
      });
      // print("tempc....${currlist[0].tempC}");
      // var condition = current['condition'];
      // Condition con;
      //
      // con = Condition.fromJson(condition);
      // conlist.add(con);
      // print("condition${condition}");
    } else {
      throw Exception('error');
    }

   // var response = await request.close();
   //  var data = json.decode(request.body);
   //  print("data${data}");
   //  var current = data['current'];
   //  print(current);
   //  CurrentModel currentmodel;
   //  currentmodel = CurrentModel.fromJson(current);
   //  clist.add(currentmodel);
   //
   //  print("currentlist${clist.length}");
   //  var temp = current['weather'];
   //  print(temp.toString());
   //  Weatherlist wmodel;
   //
   //  wmodel = Weatherlist.fromJson(temp);
   //  weatherlist.add(wmodel);
   //
   //  print("wlist${weatherlist.length}");
   //  print(temp.toString());
   //  return { 'description': current, 'temp': temp };
  }
 static Future<void>weatherRequest(BuildContext context,String url,List<LocationModel> loclist,List<Current> currlist, List<Condition> conlist)async{
    var response=await http.get(Uri.parse(url),
        // body:convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        });
    print("res"+response.body);
    // final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    Map<String, dynamic> jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
    print("jsonres"+jsonResponse.toString());
    if (response.statusCode == 200) {
      print("response${response.body}");
      var list = jsonResponse['location'];
      LocationModel locationModel;
      locationModel = LocationModel.fromJson(list);
      loclist.add(locationModel);
      print("listlength${list.toString()}");
      print("....${list['name']}");
      print("....${loclist[0].name}");


      var current = jsonResponse['current'];
      print("name${current.toString()}");

      Current currentmodel;

      currentmodel = Current.fromJson(current);
        currlist.add(currentmodel);

      print("currentlist${currlist.length}");
      print("tempc....${currlist[0].tempC}");
      var condition = current['condition'];
      Condition con;

      con = Condition.fromJson(condition);
      conlist.add(con);
      print("condition${condition}");
    } else {
      throw Exception('error');
    }
  }

  
  static Future<void> AirPolutionRequest(BuildContext context, String lat,String lng, List<MainModel> mainlist, List<ComponentsModel> componentlist) async{

  print("lattitude${lat} ")
;  var response = await http.get(Uri.parse(ApiServices.airp_baseurl+"lat=${lat}&lon=${lng}&appid=dcf95ed21773ea83a9fc1f29c2f76647"),
        // body:convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json"
        });
    print("res"+response.body);

    Map<String , dynamic> jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
    print("jsonres"+jsonResponse.toString());
    if (response.statusCode == 200) {
      print("response${response.body}");
    //  var list = j
      var list = jsonResponse['list'];
      print("list${list.toString()}");
      var main = list[0]['main'];
      var component = list[0]["components"];
      print("list..."+main.toString());
      MainModel mainModel;
      mainModel = MainModel.fromJson(main);
      mainlist.add(mainModel);
      print("listlength${list.toString()}");
      print("....${list[0]['aqi']}");
      print("....${mainlist[0].aqi}");
      ComponentsModel  componentsModel;
      componentsModel = ComponentsModel.fromJson(main);
      componentlist.add(componentsModel);
      print("listlength${list.toString()}");
      print("....${list[0]['co']}");
      print("....${componentlist.length}");
    } else {
      throw Exception('error');
    }
  }

static Future<void> AirPolutionForcastRequest(BuildContext context, String lat,String lng,List<DateModel> datelist,List<ForcastListModel> forcastmodel, List<MainModel> mainlist , List<ComponentsModel> compolist) async{

  print("lattitude${lat} ");
  var response = await http.get(Uri.parse(ApiServices.airforcast_baseurl+"lat=${lat}&lon=${lng}&appid=dcf95ed21773ea83a9fc1f29c2f76647"),
      // body:convert.jsonEncode(request),
      headers: {
        "content-type": "application/json",
        "accept": "application/json"
      });
  print("res"+response.body);

  Map<String , dynamic> jsonResponse = await json.decode(utf8.decode(response.bodyBytes));
  print("jsonres"+jsonResponse.toString());
  if (response.statusCode == 200) {
    print("response${response.body}");
    //  var list = j
  //  var main = list[0]['main'];
    var list = jsonResponse['list'];
    list.forEach((element) {

      print("element"+element['dt'].toString());
      DateModel dtModel = DateModel.fromJson(element);
      datelist.add(dtModel);
      //  print("daily${mainlist.length}");
      print("date${datelist[0].date}");
      var main = element['main'];
      MainModel mainModel = MainModel.fromJson(main);
      mainlist.add(mainModel);
     //  print("daily${mainlist.length}");
       print("main..${mainlist[0].aqi}");

      var compo = element['components'];
      print("mainlistttttt${compo.toString()}");
      ComponentsModel componentsModel;
      componentsModel = ComponentsModel.fromJson(compo);
      compolist.add(componentsModel);
     // print("componentmodel${componentsModel.co}");


    //  var component = list[0]["components"];
      print("listlength${list.toString()}");
      print("....${mainlist[0].aqi}");



    });
    //var main = list[0]['main'];

ForcastListModel forModel = ForcastListModel.fromJson(jsonResponse);
    forcastmodel.add(forModel);
    print("length    ${forcastmodel.length}");
    print("we...${list[0]['dt']}");
  } else {
    throw Exception('error');
  }
}

}