import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:PhilosophyToday/screens/wrapper.dart';
import 'package:PhilosophyToday/splash/intro.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import "package:http/http.dart" as http;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/auth.dart';
import 'models/user.dart';

String messageTitle = "Empty";
String notificationAlert = "alert";

Future<List> fetchCategories() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/categories",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("categoryData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("categoryData");
    return convertData;
  }
}

Future<List> fetchTags() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/tags",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("tagsData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("tagsData");
    return convertData;
  }
}

Future<String> fetchMaxPosts() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?per_page=1",
        headers: {"Accept": "application/json"});
    var convertData = response.headers;
    String maxPostLength = convertData['x-wp-total'];
    box.put("maxPostLength", maxPostLength);
    return maxPostLength;
  } catch (e) {
    final convertData = box.get("maxPostLength");
    return convertData;
  }
}

void setTheme(theme) async {
  var box = await Hive.openBox("myBox");
  box.put("theme", theme.toString());
}

ThemeMode currentTheme;
bool isDarkModeEnabled;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  var box = await Hive.openBox("myBox");
  List data = await fetchCategories();
  String maxPostLength = await fetchMaxPosts();
  List tagData = await fetchTags();
  if (box.get("theme") == null) {
    box.put("theme", "lightTheme");
  }
  box.put("categories", data);
  box.put("postLength", maxPostLength);
  box.put("tags", tagData);
  runApp(IntroCheck());
  if (box.get("theme") == "lightTheme") {
    currentTheme = ThemeMode.light;
    isDarkModeEnabled = false;
  } else {
    currentTheme = ThemeMode.dark;
    isDarkModeEnabled = true;
  }
}

class MainRouter extends StatefulWidget {
  @override
  _MainRouterState createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  late FirebaseMessaging messaging;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamProvider<User>.value(
        value: AuthService().user,
        child: Wrapper(),
      ),
    );
  }
}

class IntroCheck extends StatefulWidget {
  @override
  _IntroCheckState createState() => _IntroCheckState();
}

class _IntroCheckState extends State<IntroCheck>
    with AfterLayoutMixin<IntroCheck> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    print(_seen);
    print("Seen @@@@@@@###########");
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new MainRouter()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new SplashIntro()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    checkFirstSeen();
    return MaterialApp(
      home: Builder(
        builder: (context) => Container(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              children: [
                Center(
                  child: Lottie.asset(
                      'assets/animations/Loading/infinity-loop.json'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
