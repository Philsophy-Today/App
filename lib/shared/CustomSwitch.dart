import 'package:PhilosophyToday/Services/dataManager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassicSwitchText extends StatefulWidget {
  bool isSwitched;
  final String mainText;
  final String subText;

  ClassicSwitchText(
      {Key key,
        @required this.isSwitched,
        @required this.mainText,
        @required this.subText})
      : super(key: key);

  @override
  _ClassicSwitchTextState createState() {
    return _ClassicSwitchTextState();
  }
}

class _ClassicSwitchTextState extends State<ClassicSwitchText> {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(left:20,right: 20),
        width: width,
        child: Row(
          children: [
            Container(
              width: width - width / 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.mainText,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    widget.subText,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            Spacer(),
            Switch(
              activeColor: Theme.of(context).primaryColorDark,
              value: widget.isSwitched,
              inactiveThumbColor: Theme.of(context).primaryColorDark,
              activeTrackColor: Colors.greenAccent,
              inactiveTrackColor:Colors.redAccent,
              onChanged: (value) async{
                setState(() {
                        final snackBar = SnackBar(
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              'Settings saved',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            backgroundColor: Theme.of(context).hoverColor,
                          duration:Duration(milliseconds: 800),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                    widget.isSwitched = value;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}