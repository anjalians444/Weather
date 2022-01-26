import 'package:flutter/material.dart';
import 'package:weather/widget/mycolor.dart';
class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  _DrawersState createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.skyblue,
            ),
            child: Text(
              'Weather App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle_outlined,color: MyColors.skyblue,),
            title: Text('Invite',style: TextStyle(color: MyColors.skyblue),),
          ),
          ListTile(
            leading: Icon(Icons.contact_phone_outlined,color: MyColors.skyblue,),
            title: Text('Contact us',style: TextStyle(color: MyColors.skyblue)),
          ),
        ],
      ),

    );
  }
}
