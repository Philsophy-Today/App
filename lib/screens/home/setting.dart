import 'package:PhilosophyToday/shared/CustomSwitch.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  Setting({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
        child:ListView(
          children: [
            Center(
              child: Text("Settings",style: Theme.of(context).textTheme.headline1,),
            ),
            SizedBox(height: 30,),
            ClassicSwitchText(isSwitched: true,mainText:"Cache all website data.",subText: "All the data will be stored on device for faster loading.",),
            SizedBox(height: 30,),
            ClassicSwitchText(isSwitched: false,mainText:"Recommend posts on your watching.",subText: "You will see customised posts which will be recommended by our engine.",),
            SizedBox(height: 30,),
            ClassicSwitchText(isSwitched: false,mainText:"Use system storage for storing user data.",subText: "All the data user data will be stored on your device but not on cloud.",),
            SizedBox(height: 30,),
            ClassicSwitchText(isSwitched: false,mainText:"Store data with encryption",subText: "All the data should be encrypted with AES encryption.",),
          ],
        )
    );
  }
}