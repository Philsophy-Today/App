// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
//
// main() {
//   runApp(Home());
// }
//
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   final Firestore _db = Firestore.instance;
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   @override
//   void initState(){
//     super.initState();
//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async{
//         print("onMessage: $message ");
//         final snackbar = SnackBar(
//           content:Text(message['notification']['title']),
//           action: SnackBarAction(
//             label:'GO',
//             onPressed: ()=>null,
//           ),
//         );
//         Scaffold.of(context).showSnackBar(snackbar);
//       }
//     );
//     _fcm.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Container(
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child:SizedBox(
//                 height:50,
//                 width: 50,
//                   child:CircularProgressIndicator(),
//               )
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
