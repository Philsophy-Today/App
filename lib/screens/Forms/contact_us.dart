import 'package:PhilosophyToday/screens/home/main_view.dart';
import 'package:PhilosophyToday/screens/tools/Style.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}
final _scaffoldKey = new GlobalKey<ScaffoldState>();
class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: currentTheme,
        home: Builder(
          builder: (context){
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColorDark,
                elevation: 0,
                // toolbarHeight: 50,
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () => MaterialPageRoute(builder: (context) {return MainView();}),
                ),
                actions: [
                  Container(
                    // margin: EdgeInsets.only(top:5),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              body:ContactUs()
            );
          },
        )
    );
  }
}


class ContactUs extends StatefulWidget {
  ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:20,horizontal:10),
      child: Form(
        child: Column(
          children: [
            Container(
              child:Text("Contact Us",style:Theme.of(context).textTheme.headline2)
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 40, top: 20),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle:
                  new TextStyle(color: Colors.indigoAccent, fontSize: 20),
                  labelText: "Title",
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 40, top: 20),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.center,
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle:
                  new TextStyle(color: Colors.indigoAccent, fontSize: 20),
                  labelText: "Message",
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}