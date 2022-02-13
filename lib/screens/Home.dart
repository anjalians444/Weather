
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/model/LocationModel.dart';
import 'package:weather/model/WeatherModel.dart';
import 'package:weather/model/currenmodel.dart';
import 'package:weather/screens/Weather_details.dart';
import 'package:weather/screens/airQulity.dart';
import 'package:weather/screens/air_quality.dart';
import 'package:weather/screens/bottomNavigation.dart';
import 'package:weather/screens/drawer.dart';
import 'package:weather/screens/weather.dart';
import 'package:weather/services/Apiservices.dart';
import 'package:weather/services/Webservices.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/widget/mycolor.dart';
import 'package:weather/widget/sizedBox.dart';
import 'package:location/location.dart' as loc;

import '../globalkey.dart';
//import 'package:location/location.dart' as loc;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String lat = "";
  String log ="";
  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
   late String currentAddress;
 static  String cityname = "";
  String url ="";
  List<LocationModel> loclist =[];
  List<Current> currlist = [];
  List<Condition> conlist = [];
  String name ="";
  String tempc ="";
  String tempf = "";
  String air = "";
  String presurein = "";
  String presuremb ="";
  bool isSwitched = false;
  var textValue = "";
  String windde = "";
  String windmph ="";
  String windkph ="";
  String winddir ="";
  bool load = false;
  String url2 ="";


  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = tempc;
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = tempf;
      });
      print('Switch Button is OFF');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _determinePosition();
     Future.delayed(Duration(seconds: 2),(){
      _getCurrentLocation();
    });

//getdata();
  }
  @override

  Widget build(BuildContext context) {

      ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.skyblue,
         // iconTheme: ,
          title: Center(child: Text("Weather",style: TextStyle(color: MyColors.whiteColor,fontSize: 18),)),),
       // drawer: Drawers(),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                        hSizedBox2,
                       // hSizedBox2,
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Center(child: Text("Weather",style: TextStyle(color: MyColors.blackColor,fontSize: 25,fontWeight: FontWeight.w700),)),
                            ),

                            Container(
                              alignment: Alignment.center,
                              child: Center(
                                  child: Text("City: ${cityname}",style: TextStyle(color: MyColors.blackColor,fontSize: 16,fontWeight: FontWeight.w700),)
                              ),
                            ),              ],
                        ),
                    hSizedBox1,
                    Material(
                      child: Container(
                        padding: EdgeInsets.only(left: 15,right: 15,bottom: 30),
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: GridView.custom(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                          childrenDelegate: SliverChildListDelegate(
                            [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Air_Quality (lat: lat, lng: log,)));
                                },
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: Container(
                                        // padding: EdgeInsets.only(top: 10,bottom: 10),
                                        decoration: BoxDecoration(
                                          gradient: MyColors.gradient,
                                          // color: Color(0xFF005D6C),
                                          borderRadius: BorderRadius.circular(30.0),
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.60),
                                                BlendMode.dstATop),
                                              image: AssetImage("assets/quality.jpg",),
                                          fit: BoxFit.cover

                                          )
                                        ),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              hSizedBox3,
                                             // Image.asset("assets/in.png",height: 80,width: 100,color: MyColors.whiteColor,),
                                              //hSizedBox1,
                                              // ${presurein}
                                              Text(" AirQuality",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: (){
                                  currentAddress == null || currentAddress == ""?CircularProgressIndicator():     Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherPage(key: GlobalKeys.home,lat: lat,longi: log, address: currentAddress,)));
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Container(
                                      // padding: EdgeInsets.only(top: 10,bottom: 10),
                                      decoration: BoxDecoration(
                                        gradient: MyColors.gradient,
                                        // color: Color(0xFF005D6C),
                                        image:DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage("assets/weather.jpg")
                                        ),
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                      child:Padding(
                                        padding:  EdgeInsets.all(27.0),
                                        child: Text("Weather",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w600,fontSize: 18.sp),),
                                      ) ,
                                      // child: Center(
                                      //   child: Column(
                                      //     children: [
                                      //       hSizedBox3,
                                      //       Container(
                                      //         padding: EdgeInsets.only(left: 22),
                                      //         alignment: Alignment.center,
                                      //         child: Row(
                                      //           children: [
                                      //             Container(child: Text("C°",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700),),),
                                      //             Switch(
                                      //               onChanged: toggleSwitch,
                                      //               value: isSwitched,
                                      //               activeColor: Colors.blue,
                                      //               activeTrackColor: Colors.yellow,
                                      //               inactiveThumbColor: Colors.redAccent,
                                      //               inactiveTrackColor: Colors.orange,
                                      //             ),
                                      //             Container(child: Text("F°",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w700),),),
                                      //
                                      //           ],
                                      //         ),
                                      //       ),
                                      //       // Image.asset("assets/mb.png",height: 60,width: 60,color: MyColors.whiteColor,),
                                      //       hSizedBox,
                                      //       Text(" Temprature:- \n     ${textValue} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                                      //     ],
                                      //   ),
                                      // )
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        gradient: MyColors.gradient,
                                       // color: Color(0xFF005D6C),
                                          borderRadius: BorderRadius.circular(30.0),
                                          // image: DecorationImage(
                                          //   colorFilter: ColorFilter.mode(Colors.blue.withOpacity(0.60),
                                          //       BlendMode.dstATop),
                                          //     image: AssetImage("assets/.png"))
                                       ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            hSizedBox2,
                                            Image.asset("assets/mb.png",height: 60,width: 60,color: MyColors.whiteColor,),
                                            hSizedBox1,
                                            Text(" PresureMb:- \n",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                                          ],
                                        ),
                                      )),
                                ),
                              ),

                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              //   child: Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(30)
                              //     ),
                              //     child: Container(
                              //       // padding: EdgeInsets.only(top: 10,bottom: 10),
                              //         decoration: BoxDecoration(
                              //           gradient: MyColors.gradient,
                              //           // color: Color(0xFF005D6C),
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               hSizedBox2,
                              //
                              //               Image.asset("assets/weather_logo.png",height: 60,width: 60,),
                              //               hSizedBox,
                              //               Text(" Humidity:- \n          ${air} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                              //             ],
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              //   child: Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(30)
                              //     ),
                              //     child: Container(
                              //        decoration: BoxDecoration(
                              //           gradient: MyColors.gradient,
                              //           // color: Color(0xFF005D6C),
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               hSizedBox2,
                              //
                              //               Image.asset("assets/weather_logo.png",height: 60,width: 60,),
                              //               hSizedBox,
                              //               Text(" Wind Degree:- \n            ${windde} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                              //             ],
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              //   child: Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(30)
                              //     ),
                              //     child: Container(
                              //       // padding: EdgeInsets.only(top: 10,bottom: 10),
                              //         decoration: BoxDecoration(
                              //           gradient: MyColors.gradient,
                              //           // color: Color(0xFF005D6C),
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               hSizedBox2,
                              //
                              //               Image.asset("assets/weather_logo.png",height: 60,width: 60,),
                              //               hSizedBox,
                              //               Text(" WindDir:- \n     ${winddir} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                              //             ],
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              //   child: Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(30)
                              //     ),
                              //     child: Container(
                              //       // padding: EdgeInsets.only(top: 10,bottom: 10),
                              //         decoration: BoxDecoration(
                              //           gradient: MyColors.gradient,
                              //           // color: Color(0xFF005D6C),
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               hSizedBox2,
                              //
                              //               Image.asset("assets/weather_logo.png",height: 60,width: 60,),
                              //               hSizedBox,
                              //               Text(" Wind KPH:- \n     ${windkph} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                              //             ],
                              //           ),
                              //         )),
                              //   ),
                              // ),
                              // Container(
                              //   height: 100,
                              //   width: 100,
                              //   margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                              //   child: Card(
                              //     elevation: 5,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(30)
                              //     ),
                              //     child: Container(
                              //       // padding: EdgeInsets.only(top: 10,bottom: 10),
                              //         decoration: BoxDecoration(
                              //           gradient: MyColors.gradient,
                              //           // color: Color(0xFF005D6C),
                              //           borderRadius: BorderRadius.circular(30.0),
                              //         ),
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               hSizedBox2,
                              //
                              //               Image.asset("assets/weather_logo.png",height: 60,width: 60,),
                              //               hSizedBox,
                              //               Text(" Wind MPH:- \n     ${windmph} ",style: TextStyle(color: MyColors.whiteColor,fontWeight: FontWeight.w700,fontSize: 16),),
                              //             ],
                              //           ),
                              //         )),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              cityname == null || cityname == "" ||  cityname.isEmpty?
               Container(
             height: MediaQuery.of(context).size.height,
                color: MyColors.blackColor54,
                child: Center(child: CircularProgressIndicator(
                  color: MyColors.skyblue,
                )) ,
              )
                   : Container()
            ],
          )

      );

  }
  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition()
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    loc.Location locationR = loc.Location();

    if (!await locationR.serviceEnabled()) {
      locationR.requestService();
      setState(() {

      });
    }
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   permission = await Geolocator.requestPermission();
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    setState(() {

    });

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        setState(() {

        });
        return Future.error('Location permissions are denied');
      }
      Future.delayed(Duration(milliseconds: 2)).then((_)  {
        print("open dialog");
      //  c=="" ? _showModalBottomSheet() : null;
      });


    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      lat = await "${_currentPosition.latitude}";
      log = await"${_currentPosition.longitude}";
      currentAddress = await "${place.locality}";
      // cityname = await currentAddress.toString();
      print("address...${currentAddress}");
      ApiServices.address = currentAddress;
      cityname =  currentAddress.toString();
      print("cityname${cityname}");
      //set address api
      // url2 = "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${log}&exclude=daily&appid=dcf95ed21773ea83a9fc1f29c2f76647&units=metric";
      url =  await ApiServices.base_url+currentAddress+ApiServices.api;
      print(ApiServices.address);
      print(lat+ log+  currentAddress);
      //getdata();
      setState(() {

      });


      //getdata();
      setState(() {
        print("city"+ ApiServices.address);
      });
    } catch (e) {
      print(e);
    }
  }
}
