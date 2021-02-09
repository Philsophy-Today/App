import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:PhilosophyToday/all_posts.dart';
import 'package:PhilosophyToday/tools.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;


import 'HomePage.dart';

String messageTitle = "Empty";
String notificationAlert = "alert";

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<List> fetchCategories() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/categories",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}
Future<List> fetchTags() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/tags",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}
Future<String> fetchMaxPosts() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/posts?per_page=1",
      headers: {"Accept":"application/json"}
  );
  Map convertData=response.headers;
  String maxPostLength = convertData["x-wp-total"];
  return maxPostLength;
}
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }
  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory=await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  var box = await Hive.openBox("myBox");
  List data = await fetchCategories();
  String maxPostLength = await fetchMaxPosts();
  List tagData= await fetchTags();
  eprint(tagData);
  box.put("categories", data);
  box.put("postLength", maxPostLength);
  box.put("tags",tagData);
  runApp(
    MaterialApp(
      title: 'Google Sign In',
      home: MainRouter(),
    ),
  );
}

class MainRouter extends StatefulWidget {
  @override
  _MainRouterState createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {

  String messageTitle = "Empty";
  String notificationAlert = "alert";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
