import 'package:PhilosophyToday/models/user.dart';
import 'package:PhilosophyToday/screens/authenticate/sign_in.dart';
import 'package:PhilosophyToday/screens/home/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/register.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool showSignIn =true;
  void toggleView(){
    setState(() {
      return showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user == null){
      if (showSignIn==true){
          return SignIn(toggleView:toggleView);
      }else{
        return Register(toggleView:toggleView);
      }

    } else {
      return MainView();
    }
  }
}