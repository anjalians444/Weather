import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:weather/globalkey.dart';
import 'package:weather/model/LocationModel.dart';
import 'package:weather/model/WeatherModel.dart';
import 'package:weather/model/currenmodel.dart';
import 'package:weather/screens/Weather_details.dart';
import 'package:weather/services/Webservices.dart';
import 'package:weather/widget/mycolor.dart';
import 'package:weather/widget/sizedBox.dart';

class WeatherPage extends StatefulWidget {
 // List <Current> model = [];
 // List <LocationModel> locmodel = [];
 String lat ="";
 String longi ="";
 String address = "";
   WeatherPage({Key? key,required this.address,required this.lat,required this.longi}) : super(key: key);
//required this.model,required this.locmodel
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  bool isSwitched = false;
  var textValue = "";
  String tempc = "";
  String tempf ="";
  String windkph ="";
  String winddir ="";
  bool load = false;
  String city = "";
  List<Weatherlist> wlist = [];
  List<CurrentModel> cmodel = [];
  List<Daily> dlist = [];
  List<HourlyModel> hlist = [];
  String url ="";
  String des ="";
  String temp = "";
  int num = 0;

  //String

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // city = widget.locmodel[0].name.toString();
      url = "https://api.openweathermap.org/data/2.5/onecall?lat=${widget.lat}&lon=${widget.longi}&exclude=alerts&appid=dcf95ed21773ea83a9fc1f29c2f76647&units=metric";

    });
    getdata();
  }
  getdata() async{
 setState(() {
   load = true;
 });
    await WebServices.getData(url,cmodel,wlist,dlist,hlist);
    setState(() {
      temp = cmodel[0].temp.toString();
      num = double.parse(temp).round();
      tempf = "${(num * 9/5) + 32}"+"°F";
      textValue =tempf;
      des = wlist[0].description.toString();
     // tempf = cmodel[0].temp.toString()+"°F";
  load = false;
    });

    print("num${num}");
    print("lat ${widget.lat}");
    print("des${des}");
  }

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        // tempc = cmodel[0].temp.toString()+"°C";
         tempc = "${num}"+"°C";
         textValue = tempc;
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        // tempf = cmodel[0].temp.toString()+"°F";
        // tempf = "${(num * 9/5) + 32}";
         textValue = tempf;
      });
      print('Switch Button is OFF');
    }//
  }
  String? _result;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: load == true? Container(
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       child: Center(
         child: CircularProgressIndicator(
           color: MyColors.skyblue,
         ),
       ),
     ) :Column(
       children: [
         hSizedBox4,
         hSizedBox,
         Material(
           elevation: 8,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(30.0)
           ),
           child: GestureDetector(
             onTap: () async {
               var result = await showSearch<String>(
                 context: context,
                 delegate: SearchResultDelegate(),
               );
               setState(() => _result = result);
             },
             child: Container(
               padding: EdgeInsets.symmetric(horizontal: 20),
               height: 50,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30.0)
               ),
               child: Center(
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(children: [   Icon(Icons.search,color: MyColors.blackColor,size: 20,),
                       hSizedBox4,
                       Text("Search City", style: TextStyle(color: MyColors.blackColor,fontWeight: FontWeight.w500),),
                     ],),
                     hSizedBox5,
                     Container(
                         alignment: Alignment.center,
                         child: Icon(Icons.location_searching,color: MyColors.blackColor,size: 30,))

                   ],
                 ),
               ),
             ),
           ),
         ),

         hSizedBox3,
         Container(
          // pa dding: EdgeInsets.only(left: 22),
           alignment: Alignment.center,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 child: Text("F°",style: TextStyle(color: MyColors.blackColor,fontSize: 25,fontWeight: FontWeight.w700),),),
               Switch(
                 onChanged: toggleSwitch,
                 value: isSwitched,
                 activeColor: Colors.blue,
                 activeTrackColor: Colors.yellow,
                 inactiveThumbColor: Colors.redAccent,
                 inactiveTrackColor: Colors.orange,
               ),
               Container(child: Text("C°",style: TextStyle(color: MyColors.blackColor,fontSize: 25,fontWeight: FontWeight.w700),),),

             ],
           ),
         ),
         // Image.asset("assets/mb.png",height: 60,width: 60,color: MyColors.whiteColor,),
       //  hSizedBox,

         Material(
           child: Container(
             height: MediaQuery.of(context).size.height * 0.77,
             child: ListView.builder(
                itemCount: 1,
                 itemBuilder: (context,index){
               return GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (_) => WeatherDetails(key: GlobalKeys.home, city: widget.address, textValue: textValue,model: cmodel[0], weathermodel: wlist, dailymodel:dlist, hlist: hlist, tempc: tempc,)));
                 },
                 child: _buildcard(),
               );
             }),
           ),
         )
          ],
     ),
    );
  }

   _buildcard() {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 20,right: 20,bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: MyColors.lightsky
      ),
      child: Center(
        child: ListTile(

          leading:   Container(
            margin: EdgeInsets.only(top: 8),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70.0),
                color: MyColors.orange
            ),
          ),
          title: Text(widget.address,style: TextStyle(color: MyColors.blackColor,fontWeight: FontWeight.w600,fontSize: 18),),
          subtitle: Text("${des}",style: TextStyle(color: MyColors.blackColor,fontWeight: FontWeight.w600,fontSize: 14)),
          trailing:  Text("${textValue}",textAlign: TextAlign.center,maxLines: 1,style: TextStyle(color: MyColors.blackColor,fontWeight: FontWeight.w700,fontSize: 30),)

        ),
      ),
    );
  }
}

class SearchResultDelegate extends SearchDelegate<String> {
  List<String> data = nouns.take(100).toList();

  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = data.where((e) => e.contains(query) && e.startsWith(query)).toList();
    else
      listToShow = data;

    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var noun = listToShow[i];
        return ListTile(
          title: Text(noun),
          onTap: () => close(context, noun),
        );
      },
    );
  }
}