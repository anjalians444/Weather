import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather/globalkey.dart';
import 'package:weather/screens/Home.dart';
import 'package:weather/screens/weather.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Location location = new Location();
  late bool _serviceEnabled ;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissiongrantedd();
    navigator();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/weather_logo.png',
      splashIconSize: 200,
      nextScreen: Home(key: GlobalKeys.home,),
      splashTransition: SplashTransition.rotationTransition,
     // PageTransitionType pageTransitionType = PageTransitionType.downToUp,
    );
      // Container(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       fit: BoxFit.fill,
      //       colorFilter:
      //       ColorFilter.mode(Colors.blue.withOpacity(0.60),
      //           BlendMode.dstATop),
      //       image: AssetImage("assets/background.png"),
      //     )
      //   ),
      //   child:Center(child: Image.asset("assets/weather_logo.png",height: 100,width: 100 ,),)
      // ),
//    );
  }
  permissiongrantedd()async{
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        _locationData = await location.getLocation();
        // Future.delayed(Duration(milliseconds: 2)).then((_)  {
        //   print("open dialog");
        //   address=="" ? _showModalBottomSheet() : null;
        // });
        return;
      }
    }
    // else{
    //     Future.delayed(Duration(milliseconds: 2)).then((_)  {
    //        address==""|| address == null? _showModalBottomSheet() : null;
    //     });
    //   }
  }

  navigator() async{
    await Future.delayed(Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
    });
  }
}
