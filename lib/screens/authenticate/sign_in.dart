import 'package:PhilosophyToday/Services/auth.dart';
import 'package:PhilosophyToday/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';



bool validateStructure(String value){
  String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}
bool isValidEmail(String value) {
  return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(value);
}


class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading=false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = new TextEditingController();
    TextEditingController emailController = new TextEditingController();
    return loading ? Loader() : MaterialApp(
      home: Scaffold(
          body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:30,left:20,right:20),
                  child:Container(
                    padding: EdgeInsets.only(top:5,bottom:5),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      border: Border.all(
                        color: Colors.indigoAccent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(1, 1, 1, 0.1),
                          blurRadius: 20.0, // soften the shadow
                          spreadRadius: 5.0, //extend the shadow
                          offset: Offset(
                            1.0, // Move to right 10  horizontally
                            15.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: FlatButton(
                      onPressed: () async {
                        await _auth.googleSignIn();
                      },
                      child: Row(
                        children: <Widget>[
                          Image(
                              image: AssetImage("assets/images/googleLogo.png")),
                          Padding(
                            padding: EdgeInsets.only(left:40,),
                            child: Text(
                              "Sign In With Google",
                              style: GoogleFonts.getFont('Poppins',
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    child: Center(
                        child: Icon(MdiIcons.account,color: Colors.indigoAccent,size: 150,),
                    ),
                ),
                Container(
                    child:Center(
                      child: Text("Log In",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                        ),
                      ),
                    )
                ),
                Container(
                  width:10,
                  padding:EdgeInsets.only(left:30,right:40,top:30,bottom:20),
                  child: TextFormField(
                    validator: (val){
                      if(isValidEmail(val)){
                        return null;
                      }else{
                        return "Please use a valid email.";
                      }
                    },
                    controller: emailController,
                    textAlign: TextAlign.center,
                    obscureText: false,
                    decoration: InputDecoration(
                        labelStyle: new TextStyle(color:Colors.indigoAccent ,fontSize: 20),
                        labelText: "Email",
                        contentPadding: EdgeInsets.all(0),
                        ),
                  ),
                ),
                Container(
                  width:10,
                  padding:EdgeInsets.only(left:30,right:40,top:15,bottom:40),
                  child: TextFormField(
                    validator: (val){
                      if(val.isNotEmpty){
                        return null;
                      } else {
                        return "Please put your password.";
                      }
                    },
                    controller: passwordController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelStyle: new TextStyle(color: Colors.indigoAccent ,fontSize: 20),
                        labelText: "Password",
                        contentPadding: EdgeInsets.all(0),
                      ),
                  ),
                ),
                SizedBox(
                  child: Center(child: Text(error,style: TextStyle(color: Colors.red),)),
                ),
                Container(
                    child: Container(
                      width:10,
                      padding: EdgeInsets.only(left:50,right:50,top:10,bottom:10),
                      child:Container(
                        width:10,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(84, 109, 254,0.2),
                              blurRadius: 50.0, // soften the shadow
                              spreadRadius: 10.0, //extend the shadow
                              offset: Offset(
                                15.0, // Move to right 10  horizontally
                                15.0, // Move to bottom 10 Vertically
                              ),
                            ),
                          ],
                        ),
                        child:FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(()=>loading=true);
                              dynamic result = await _auth.signInWithEmailAndPassword(emailController.text, passwordController.text);
                              if (result==null) {
                                setState((){
                                  error='Wrong credentials.';
                                  loading=false;
                                });
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    )
                ),
                Divider(),
                Center(
                    child: FlatButton(
                      child: Container(
                        child: Text("Sign Up",
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onPressed: (){
                        widget.toggleView();
                      },
                    ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
