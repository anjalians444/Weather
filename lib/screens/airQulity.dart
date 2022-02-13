import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:weather/model/ForcastModel.dart';
import 'package:weather/model/WeatherModel.dart';
import 'package:weather/model/dateModel.dart';
import 'package:weather/screens/drawer.dart';
import 'package:weather/screens/image_viewer.dart';
import 'package:weather/services/Apiservices.dart';
import 'package:weather/services/Webservices.dart';
import 'package:weather/widget/mycolor.dart';
import 'package:weather/widget/style.dart';

class Air_Quality extends StatefulWidget {
  String lat = "";
  String lng = "";

  Air_Quality({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  _Air_QualityState createState() => _Air_QualityState();
}

class _Air_QualityState extends State<Air_Quality> with SingleTickerProviderStateMixin {
  DateTime now = new DateTime.now();
  var formatter = new DateFormat('EEEE, MMM DD');
  final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  late String currentAddress ="";
  String formattedDate = "";
  String city = "";
  int pageIndex = 0;
  List<MainModel> mainmodel = [];
  List<ComponentsModel> componentmodel = [];
  List<ForcastListModel> forcastmodel = [];
  List<DateModel> datemodel = [];
  String aqi = "Satisfied";
  var today ;
  bool load = false;
  double yourPercentage = 0.0;
  List<String> liquedname = ["Carbon monoxide","Nitrogen monoxide","Nitrogen dioxide","Ozone","Sulphur dioxide","Fine particles matter","Coarse particulate matter","Ammonia"];
  List<String> takecare = ["Vitamin C","Vitamin E","Beta-Carotene"];

  late Animation<double> animation;
  late AnimationController _controller;
  String i ="";
  double aq = 0.0;
 // Timestamp timestamp;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formattedDate = formatter.format(now);
    print(formattedDate);
    //  print("lat${widget.lat}");
    getdata();
  }

  getdata() async {
    setState(() {
      load = true;
    });
    //  await WebServices.AirPolutionRequest(context, widget.lat, widget.lng, mainmodel,componentmodel);
    await WebServices.AirPolutionForcastRequest(
        context, widget.lat, widget.lng,datemodel,forcastmodel, mainmodel, componentmodel);
    print("lat${widget.lat}");
    print("list${mainmodel.length}");
    setState(() {
   aqi =    componentmodel[0].pm10! > 0 || componentmodel[0].pm25! > 0 || componentmodel[0].pm10! < 25 || componentmodel[0].pm25! < 15
          ? "Good"
          : componentmodel[0].pm10! > 26 || componentmodel[0].pm25! > 16 || componentmodel[0].pm10! < 50 || componentmodel[0].pm25! < 30
          ? "Fair":
      componentmodel[0].pm10! > 50 || componentmodel[0].pm25! > 30 || componentmodel[0].pm10! < 90 || componentmodel[0].pm25! < 55
          ? "Moderate" :
      componentmodel[0].pm10! > 90 || componentmodel[0].pm25! > 55 || componentmodel[0].pm10! < 180 || componentmodel[0].pm25! < 110
          ? "Poor" :
      componentmodel[0].pm10! > 180 || componentmodel[0].pm25! > 110
          ? "Very Poor" : "";
   //    yourPercentage = mainmodel[0].aqi

      aq =  componentmodel[0].pm10! > 0 || componentmodel[0].pm25! > 0 || componentmodel[0].pm10! < 25 || componentmodel[0].pm25! < 15
          ? 25.0
          : componentmodel[0].pm10! > 26 || componentmodel[0].pm25! > 16 || componentmodel[0].pm10! < 50 || componentmodel[0].pm25! < 30
          ? 50.0:
      componentmodel[0].pm10! > 50 || componentmodel[0].pm25! > 30 || componentmodel[0].pm10! < 90 || componentmodel[0].pm25! < 55
          ?  90.0 :
      componentmodel[0].pm10! > 90 || componentmodel[0].pm25! > 55 || componentmodel[0].pm10! < 180 || componentmodel[0].pm25! < 110
          ? 180.0 :
      componentmodel[0].pm10! > 180 || componentmodel[0].pm25! > 110
          ? 300.0 : 0.0;
      _controller = AnimationController(duration:const Duration(microseconds: 5000), vsync: this);
      animation =Tween<double>(begin: 0, end: aq).animate(_controller)
        ..addListener((){
          setState((){
// The state that has changed here is the animation objects value
            i = animation.value.toStringAsFixed(0);
          });
        });
      _controller.forward();
      load = false;
    });
    print("aqi${datemodel.length}");
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('EE');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
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
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: MyColors.skyblue,
        title: Text("Air Quality",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: MyColors.whiteColor,size: 22.sp,)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                  // if (scaffoldKey.currentState!.isEndDrawerOpen) {
                  //   scaffoldKey.currentState!.openDrawer();
                  // } else {
                  //   scaffoldKey.currentState!.openEndDrawer();
                  // }
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      drawer: Drawers(),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: MyColors.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                    //  enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              "assets/air_q.png",
                              width: 40,
                              height: 50,
                            )),
                        Text(
                          "Air Quality",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 0
                            ? Container(
                                height: 2,
                                width: 70,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 1;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "Weather",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 1
                            ? Container(
                                height: 2,
                                width: 60,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 2;
                      });
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Image.asset(
                          "assets/menu.png",
                          width: 40,
                          height: 40,
                        ),
                        Text(
                          "Main Menu",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        pageIndex == 2
                            ? Container(
                                height: 2,
                                width: 60,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 3;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "EMISSIOONS",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 3
                            ? Container(
                                height: 2,
                                width: 60,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 4;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "EARTHQUAKE",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 4
                            ? Container(
                                height: 2,
                                width: 60,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 5;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "EXPOSURE",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 5
                            ? Container(
                                height: 2,
                                width: 70,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 6;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "DUST MAP",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 6
                            ? Container(
                                height: 2,
                                width: 70,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 7;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "CALENDAR",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 7
                            ? Container(
                                height: 2,
                                width: 70,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                    // enableFeedback: false,
                    onTap: () {
                      setState(() {
                        pageIndex = 8;
                      });
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/weath.png",
                          width: 40,
                          height: 50,
                        ),
                        Text(
                          "MY DEVICE",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        pageIndex == 8
                            ? Container(
                                height: 2,
                                width: 70,
                                color: MyColors.skyblue,
                              )
                            : Container()
                      ],
                    )),
                SizedBox(
                  height: 15.h,
                ),
              ],
            )),
      ),
      body:  mainmodel.length > 0? Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        print("share");
                        Share.share('check out my website https://example.com',
                            subject: 'Look what I made!');
                      },
                      icon: Icon(
                        Icons.share,
                        color: MyColors.greycolor,
                      )),
                ),

                Container(
                  child: Text(
                    formattedDate,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  child: Text(
                    "${currentAddress} , Madhay Pradesh ",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _getCurrentLocation();
                  },
                  child: Text(
                    "Get Current Location",
                    style: TextStyle(
                        color: MyColors.lightBlackColor26,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w100),
                  ),
                ),


            Padding(
              padding:  EdgeInsets.zero,
              child: Container(
                height: 300.h,
                padding: EdgeInsets.zero,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        showLabels: false,
                        showTicks: false,
                        startAngle: 120,
                        canScaleToFit: true,
                        endAngle: 60,
                        radiusFactor: 0.66,
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.12,
                          color: const Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                          cornerStyle: CornerStyle.bothCurve,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                              value: aq,
                              width: 0.12,
                              color:    componentmodel[0].pm10! > 0 || componentmodel[0].pm25! > 0 || componentmodel[0].pm10! < 25 || componentmodel[0].pm25! < 15
                                  ? MyColors.light_green
                                  : componentmodel[0].pm10! > 26 || componentmodel[0].pm25! > 16 || componentmodel[0].pm10! < 50 || componentmodel[0].pm25! < 30
                                  ? MyColors.light_yellow :
                              componentmodel[0].pm10! > 50 || componentmodel[0].pm25! > 30 || componentmodel[0].pm10! < 90 || componentmodel[0].pm25! < 55
                                  ? MyColors.lightskyblue :
                              componentmodel[0].pm10! > 90 || componentmodel[0].pm25! > 55 || componentmodel[0].pm10! < 180 || componentmodel[0].pm25! < 110
                                  ? MyColors.light_orange :
                              componentmodel[0].pm10! > 180 || componentmodel[0].pm25! > 110
                                  ? MyColors.lightred
                              // : cmodel.pm10 == 180.0 || cmodel.pm25 == 110.0
                              // ? MyColors.lightred
                                  : MyColors.lightred,
                              sizeUnit: GaugeSizeUnit.factor,
                              enableAnimation: true,
                              animationDuration: 100,
                              animationType: AnimationType.slowMiddle,
                              cornerStyle: CornerStyle.bothCurve)
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            angle: 90,
                              positionFactor: 0,
                              widget: Container(
                                child: Stack(
                                  alignment: Alignment.center,

                                  children: [

                                   Text(i,
                                          //  double.parse(mainmodel[0].aqi).toStringAsFixed(0),
                                          style: TextStyle(fontSize: 52.sp,fontWeight: FontWeight.w600,color: MyColors.blackColor),
                                        )
                                  ],
                                ),
                              ))
                        ]),
                  ])),
            ),

                Container(
                  child: Text(
                    aqi,
                    style: TextStyle(
                        fontSize: 25.sp.sp,
                        fontWeight: FontWeight.w600, color:
                    componentmodel[0].pm10! > 0 || componentmodel[0].pm25! > 0 || componentmodel[0].pm10! < 25 || componentmodel[0].pm25! < 15
                        ? MyColors.light_green
                        : componentmodel[0].pm10! > 26 || componentmodel[0].pm25! > 16 || componentmodel[0].pm10! < 50 || componentmodel[0].pm25! < 30
                        ? MyColors.light_yellow :
                    componentmodel[0].pm10! > 50 || componentmodel[0].pm25! > 30 || componentmodel[0].pm10! < 90 || componentmodel[0].pm25! < 55
                        ? MyColors.lightskyblue :
                    componentmodel[0].pm10! > 90 || componentmodel[0].pm25! > 55 || componentmodel[0].pm10! < 180 || componentmodel[0].pm25! < 110
                        ? MyColors.light_orange :
                    componentmodel[0].pm10! > 180 || componentmodel[0].pm25! > 110
                        ? MyColors.lightred: MyColors.red),
                  ),
                ),
                // SizedBox(height: 20.h,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        "Air Quality is Equivalent to 3",
                        style: TextStyle(
                            fontSize: 14.50.sp, fontWeight: FontWeight.w600),
                      ),
                      Image.asset(
                        "assets/cigarats.png",
                        height: 80,
                        width: 20,
                      ),
                      Text(
                        "Cigarettes a day",
                        style: TextStyle(
                            fontSize: 14.50.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GOOD",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "SATISFACTORY",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "MODERATE",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "POOR",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "V.POOR",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "SEVERE",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: _circule(MyColors.greenColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: _line(Colors.yellow, 50.0.w),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                child: _circule(Colors.yellow),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: _line(Colors.orange, 62.0.w),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                child: _circule(Colors.orange),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: _line(MyColors.red, 40.0.w),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                child: _circule(MyColors.red),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: _line(MyColors.purple, 30.0.w),
                              )
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                child: _circule(MyColors.purple),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 18.w),
                                child: _line(MyColors.darkred, 33.0.w),
                              )
                            ],
                          ),
                          _circule(MyColors.darkred)
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            "50",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 53.w,
                          ),
                          Text(
                            "100",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 60.w,
                          ),
                          Text(
                            "200",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 40.w,
                          ),
                          Text(
                            "300",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Text(
                            "400",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 27.w,
                          ),
                          Text(
                            "500",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: MyColors.lightBlackColor),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Allowed Activities",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Material(
                        color: MyColors.lightBlackColor,
                        child: Container(
                          height: 100.h,
                          child: ListView.builder(
                              itemCount: 8,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ImageViewer()));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Column(
                                      children: [
                                        _activitycard(),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          "Outdoor Sport",
                                          style: TextStyle(
                                              color: MyColors.blackColor,
                                         fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 0.5,
                        color: MyColors.greycolor,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Forecast",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Material(
                        color: MyColors.lightBlackColor26,
                        child: Container(
                          //  mainmodel[0].aqi == "1"? "Good": mainmodel[0].aqi == "2" ? "Fair":mainmodel[0].aqi == "3"? "Moderate": mainmodel[0].aqi == "4"? "Very Poor":
                          height: 100.h,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              itemCount: datemodel.length,
                              itemBuilder: (context, int index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child:_forcastcard(mainmodel[index], componentmodel[index],index, datemodel[index])


                                  // SizedBox(width: 10.w,),
                                  // _forcastcard(MyColors.light_yellow),
                                  // SizedBox(width: 10.w,),
                                  // _forcastcard(MyColors.lightorange),
                                  // SizedBox(width: 10.w,),
                                  // _forcastcard(MyColors.light_yellow),
                                  // SizedBox(width: 10.w,),
                                  // _forcastcard(Colors.lightGreen),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Recommendations",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Material(
                        color: MyColors.lightBlackColor,
                        child: Container(
                          height: 100.h,
                          child: ListView.builder(
                              itemCount: 8,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, int index) {
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Column(
                                    children: [
                                      _recommendcard(),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "Open Window",
                                        style: TextStyle(
                                            color: MyColors.blackColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Take",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Material(
                        color: MyColors.lightBlackColor26,
                        child: Container(
                            height: 100.h,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                                itemCount: takecare.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, int index) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: _takecard(takecare[index]),
                                  );
                                })),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 0.2.h,
                        color: MyColors.greycolor,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Pollutants Score",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        height: 0.5.h,
                        color: MyColors.blackColor,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Material(
                        color: MyColors.lightBlackColor,
                        child: Container(
                          height: 350.h,
                          child: ListView.builder(
                              itemCount: componentmodel.length,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 10.0.h),
                              itemBuilder: (context, int index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: _pollutantsscore(componentmodel[index],liquedname[index]),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 0.4,
                        color: MyColors.greycolor,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  SizedBox(width: 50.w,),
                          Container(
                            height: 20.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                                color: MyColors.orange,
                                borderRadius: BorderRadius.circular(50.r)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Dangerous",
                            style: TextStyle(
                              color: MyColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          Container(
                            height: 15.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: MyColors.greenColor,
                              // borderRadius: BorderRadius.circular(50.r)
                            ),
                            child: Center(
                                child: Icon(
                              Icons.check,
                              color: MyColors.whiteColor,
                              size: 15.sp,
                            )),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Satisfactory",
                            style: TextStyle(
                              color: MyColors.blackColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // SizedBox(width: 50.w,),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          load == true
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  color: MyColors.blackColor54,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: MyColors.skyblue,
                  )),
                )
              : Container(),
        ],
      ):
       Container(child: Center(child: CircularProgressIndicator())),
    );
  }

  _pollutantsscore(ComponentsModel comp0Model, String liqued) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.settings,
            size: 25.sp,
            color: MyColors.blackColor54,
          ),
          Container(
            width: 180.w,
            child: Text(
              "${liqued}",
              style: TextStyle(
                  color: MyColors.blackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            "${comp0Model.co}",
            style: TextStyle(
                color: MyColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
          Container(
            height: 20.h,
            width: 20.w,
            decoration: BoxDecoration(
                color: MyColors.orange,
                borderRadius: BorderRadius.circular(50.r)),
          )
        ],
      ),
    );
  }

  _forcastcard(MainModel mainModel, ComponentsModel cmodel,int index,DateModel dateModel) {
    var airpollution ;
    //if(cmodel.pm10 < 0 || cmodel.pm25  )
    return Container(
      child: Center(
        child: Container(
            height: 80.h,
            width: 90.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r), color:
            cmodel.pm10! > 0 || cmodel.pm25! > 0 || cmodel.pm10! < 25 || cmodel.pm25! < 15
                ? MyColors.light_green
                : cmodel.pm10! > 26 || cmodel.pm25! > 16 || cmodel.pm10! < 50 || cmodel.pm25! < 30
                ? MyColors.light_yellow :
            cmodel.pm10! > 50 || cmodel.pm25! > 30 || cmodel.pm10! < 90 || cmodel.pm25! < 55
                ? MyColors.lightskyblue :
            cmodel.pm10! > 90 || cmodel.pm25! > 55 || cmodel.pm10! < 180 || cmodel.pm25! < 110
                ? MyColors.light_orange :
            cmodel.pm10! > 180 || cmodel.pm25! > 110
                ? MyColors.lightred
                // : cmodel.pm10 == 180.0 || cmodel.pm25 == 110.0
                // ? MyColors.lightred
                : MyColors.lightred,),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                  ),
                  // Text('${
                  //     new DateFormat('EEE , MMM,DD').format(today.add(new Duration(days: index))).toString()}',style: MyTextStyle.bodytext6,),

                  Text(
                    "${new DateFormat('EE').format( DateTime.now().add(Duration(days: index))) }",
                    //"${ DateFormat('EE').format(DateTime.fromMillisecondsSinceEpoch(1644141600 * 1000))}",
                  //  '${DateFormat('EEE ,MMM,DD').format(today.add(new Duration(days: index)))}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    cmodel.nh3.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                 " ${ cmodel.pm10! > 0 || cmodel.pm25! > 0 || cmodel.pm10! < 25 || cmodel.pm25! < 15
                  ? "Good"
                      : cmodel.pm10! > 26 || cmodel.pm25! > 16 || cmodel.pm10! < 50 || cmodel.pm25! < 30
                  ? "Fair" :
                  cmodel.pm10! > 50 || cmodel.pm25! > 30 || cmodel.pm10! < 90 || cmodel.pm25! < 55
                  ? "Moderate" :
                  cmodel.pm10! > 90 || cmodel.pm25! > 55 || cmodel.pm10! < 180 || cmodel.pm25! < 110
                  ? "Poor" :
                  cmodel.pm10! > 180 || cmodel.pm25! > 110
                  ? "Very Poor"
                  // : cmodel.pm10 == 180.0 || cmodel.pm25 == 110.0
                  // ? MyColors.lightred
                      : ""}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _takecard(String takec) {
    return Container(
      child: Center(
        child: Container(
            height: 80.h,
            width: 140.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: MyColors.whiteColor),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "${takec}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 15.h,
                    width: 15.w,
                    decoration: BoxDecoration(color: MyColors.skyblue),
                    child: Center(
                        child: Text(
                      "!",
                      style: TextStyle(
                          color: MyColors.whiteColor, fontSize: 15.sp),
                    )),
                  )
                ],
              ),
            )),
      ),
    );
  }

  _activitycard() {
    return Container(
        height: 60.h,
        width: 66.w,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.red, width: 2),
            borderRadius: BorderRadius.circular(100.r)),
        child: Center(
          child: CircleAvatar(
            radius: 28.r,
            backgroundImage: AssetImage("assets/walk.gif"),
          ),
        ));
  }

  _recommendcard() {
    return Container(
        height: 60.h,
        width: 66.w,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.red, width: 2),
            borderRadius: BorderRadius.circular(100.r)),
        child: Center(
          child: CircleAvatar(
            radius: 28.r,
            backgroundImage: AssetImage("assets/weather_logo.png"),
          ),
        ));
  }

  _circule(Color color) {
    return Container(
      height: 25.h,
      width: 28.w,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(50.r)),
    );
  }

  _line(
    Color color,
    double width,
  ) {
    return Container(
      height: 25.h,
      child: Center(
        child: Container(
          height: 5.h,
          width: width.w,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  bottomLeft: Radius.circular(15.r))),
        ),
      ),
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
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      // lat = await "${_currentPosition.latitude}";
      // log = await"${_currentPosition.longitude}";
      currentAddress = await "${place.locality}";
      // cityname = await currentAddress.toString();
      print("address...${currentAddress}");
      // ApiServices.address = currentAddress;
      // cityname =  currentAddress.toString();
      // print("cityname${cityname}");
      //set address api
      // url2 = "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${log}&exclude=daily&appid=dcf95ed21773ea83a9fc1f29c2f76647&units=metric";
      // url =  await ApiServices.base_url+currentAddress+ApiServices.api;
      // print(ApiServices.address);
      // print(lat+ log+  currentAddress);
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
