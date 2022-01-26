
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/globalkey.dart';
import 'package:weather/model/LocationModel.dart';
import 'package:weather/model/WeatherModel.dart';
import 'package:weather/model/currenmodel.dart';
import 'package:weather/widget/getdatetime.dart';
import 'package:weather/widget/mycolor.dart';
import 'package:weather/widget/sizedBox.dart';
import 'package:weather/widget/style.dart';

class WeatherDetails extends StatefulWidget {
  CurrentModel model;
  // List <LocationModel> locmodel = [];
  List <Weatherlist> weathermodel = [];
  List <Daily> dailymodel = [];
  List<HourlyModel> hlist = [];
  var textValue = "°F";
  String tempc = "";
  String tempf ="";
  String city = "";
   WeatherDetails({Key? key,required this.model,required this.weathermodel,required this.city,required this.textValue,required this.dailymodel,required this.hlist,required this.tempc}) : super(key: key);
  //,required this.locmodel
  @override
  WeatherDetailsState createState() => WeatherDetailsState();
}

class WeatherDetailsState extends State<WeatherDetails> {

  String time ="";
  String lat = "";
  String longi = "";
  String icon_url ="";
  String main ="";
  String des= "";
  var today ;
  String tempf = "";
  String tempc ="";
  double temp = 0.0;
  String formatter ="";
  final DateTime userDate = DateTime.now();
  var d12;
  var sunr;
  var sunset;
  @override
  void initState() {
    super.initState();
    daily();
    setState(() {
      widget.textValue;
      tempc = widget.model.temp.toString();
      print("tempccc${widget.textValue}");
      print("tempccc${tempc}");
      //icon_url = "http://openweathermap.org/img/w/" + widget.weathermodel[0].icon.toString() +".png";
     // time = getCustomFormattedDateTime(widget.locmodel[0].localtime.toString(), "EEEE, MMM,DD");
      print(time);
      var currentdate = widget.model.dt;
      var sunrise = widget.model.sunrise;
      var sunsett = widget.model.sunset;
      var dtt = DateTime.fromMillisecondsSinceEpoch(currentdate!);
      d12 = DateFormat('EEEE, MMM,DD').format(dtt); // 12/31/2000, 10:00 PM

      var sunrisedt = DateTime.fromMillisecondsSinceEpoch(sunrise!);
      sunr = DateFormat.jm().format(sunrisedt);
      var  suns = DateTime.fromMillisecondsSinceEpoch(sunsett!);
      sunset = DateFormat.jm().format(suns);


      // main = widget.weathermodel[0].main.toString();
      // des = widget.weathermodel[0].description.toString();
     // final now = new DateTime.now();
    // formatter =    new DateFormat.jm().format(userDate.add(Duration(hours: )));
    });

  }

  currentaddres() {
    if( GlobalKeys.home.currentState!=null){
      GlobalKeys.home.currentState!.setState(() {
     // lat =  GlobalKeys.home.currentState.;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            hSizedBox4,
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  //alignment: Alignment.topRight,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyColors.lightorange,
                    borderRadius: BorderRadius.circular(60)
                  ),
                  child: Center(child: Icon(Icons.clear,color: MyColors.primaryColor,)),
                ),
              ),
            ),
            hSizedBox,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
               padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("${widget.city}",style: MyTextStyle.bodytext1,),
              ),
            ),
            hSizedBox1,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("${d12}",style: MyTextStyle.bodytext3,),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.textValue}",style: MyTextStyle.heading,),

                  widget.weathermodel[0].description  == "haze" ?Image.asset("assets/haze.png",color: MyColors.greycolor,height: 100,width: 100,): Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MyColors.blackColor54,
                      // image: DecorationImage(
                      //   image: NetworkImage('${icon_url}')
                      // )
                    ),

                  ),
                  wSizedBox,
                 // wSizedBox1
                ],
              ),
            ),
            hSizedBox,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("${widget.weathermodel[0].main}",style: MyTextStyle.bodytext2,),
              ),
            ),hSizedBox,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("${widget.weathermodel[0].description}",style: MyTextStyle.bodytext4,),
              ),
            ),
            hSizedBox2,
            Container(
              decoration: BoxDecoration(
                color: MyColors.textColorAbovePrimaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Text("Humidity",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.humidity} %",style: MyTextStyle.bodytext3,),
                      ],),
                      Column(children: [
                        Text("Pressure",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.pressure} hpa",style: MyTextStyle.bodytext3,),
                      ],),
                      Column(children: [
                        Text("Wind",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.windSpeed} m/s",style: MyTextStyle.bodytext3,),
                      ],)
                    ],
                  ),
                  hSizedBox1,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Text("Visibility",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.visibility} m",style: MyTextStyle.bodytext3,),
                      ],),
                      Column(children: [
                        Text("UV Index",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.uvi}",style: MyTextStyle.bodytext3,),
                      ],),
                      Column(children: [
                        Text("DewPoint",style: MyTextStyle.bodytext4,),
                        Text("${widget.model.dewPoint}°C",style: MyTextStyle.bodytext3,),
                      ],)
                    ],
                  ),

                ],
              ),
            ),
            hSizedBox2,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(children: [
                  Image.asset("assets/sunrise.png",height: 15,width: 15,),
                  Text("${sunr}", style: MyTextStyle.bodytext5,)
                ],),
                  Row(children: [
                    Text("${sunset}", style: MyTextStyle.bodytext5,),
                    Image.asset("assets/evning.png",height: 20,width: 20,)
                  ],)
              ],),
            ),
            SizedBox(height: 5,),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: MyColors.gradient2,
               // border: Border.all(color: MyColors.orange)
              ),
            ),
            hSizedBox2,
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text("Forecast",style: MyTextStyle.bodytext2,),
            ),
            Material(
              child: Container(
                padding: EdgeInsets.only(left: 15,right: 10,top: 15),
                height: 100,
                child: ListView.builder(
                    itemCount: widget.hlist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                  return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: _buildlist(widget.hlist[index],index));
                }),
              ),
            ),
            Material(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    itemCount:widget.dailymodel.length,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index){
                      return Container(
                          padding: EdgeInsets.symmetric(vertical: 2,),
                          child: Column(
                            children: [
                              _buildlistday(widget.dailymodel[index],index),
                              SizedBox(height: 5,),
                              Divider()
                            ],
                          ));
                    }),
              ),
            ),
            hSizedBox2,
          ],
        ),
      ),
    );
  }

 List houreForecast =[ ];

  Widget _buildlist(HourlyModel hmodel,int index) {
    return Column(
      children: [
         Text('${new DateFormat.jm().format(today.add(new Duration(hours: index))).toString()}',style: MyTextStyle.bodytext4,),
        hSizedBox1,
         Container(
           height: 20,
           width: 20,
           decoration: BoxDecoration(
             color:  Colors.black,
             borderRadius:  BorderRadius.circular(60)
           ),
           child: Image.asset("assets/weather.png"),
         ),
        hSizedBox1,
     widget.textValue == widget.tempc? Text("${hmodel.temp.toString()}"+"°C",style: MyTextStyle.bodytext4,):  Text("${(double.parse(hmodel.temp.toString()).round() * 9/5) + 32}"+"°F",style: MyTextStyle.bodytext4,),
      ],

    );

  }

  _buildlistday(Daily dmodel ,int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${
    new DateFormat('EEE , MMM,DD').format(today.add(new Duration(days: index))).toString()}',style: MyTextStyle.bodytext6,),
        wSizedBox5,

        widget.textValue == widget.tempc?   Text("${dmodel.temp!.max}" +"/"+ "${dmodel.temp!.min}"+  "°C",style: MyTextStyle.bodytext4,):Text("${(double.parse(dmodel.temp!.max.toString()).round()* 9/5) + 32  }" +"/"+ "${(double.parse(dmodel.temp!.min.toString()).round()* 9/5) + 32 }"+  "°F",style: MyTextStyle.bodytext4,),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color:  MyColors.orange,
              borderRadius:  BorderRadius.circular(60)
          ),
        ),
      ],

    );
  }
  daily() async{
     today = new DateTime.now();
    for(var i=0; i<7; i++){
       new DateFormat('y/m/d').format(today.add(new Duration(days: i+1))).toString();
    }
  }
}
