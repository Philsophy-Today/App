import 'dart:convert';

import 'package:PhilosophyToday/screens/post/PostView.dart';
import 'package:PhilosophyToday/screens/search/postSearch.dart';
import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:PhilosophyToday/main.dart' show currentTheme;


import '../tools/Style.dart';

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class PostRouter extends StatelessWidget {
  final List<String> type;
  final String url;
  PostRouter({this.type, this.url});

  Future<String> fetchDescription(String username) async {
    print(username);
    final response2 = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/users",
        headers: {"Accept": "application/json"});
    var convertData2 = jsonDecode(response2.body);
    print(convertData2);
    for (int i; i <= convertData2.length; i++) {
      if (convertData2[i]["name"] == username) {
        return convertData2[i]["description"].toString();
      }
    }
    return "";
  }

  Future<List> fetchDynamic(List type,[String url = ""]) async {
    if (type[0] == 'slugBased') {
      String url = "http://philosophytoday.in/wp-json/wp/v2/posts?slug=" +
          type[1].toString() +
          "&_embed";
      debugPrint(url);
      final response = await http.get(url);
      var convertData = jsonDecode(response.body);
      return convertData;
    }if (type[0]=='cUrlBased'){
      debugPrint(url);
      final response = await http.get(url);
      var convertData = jsonDecode(response.body);
      return convertData;
    } else {
      String url = "http://philosophytoday.in/wp-json/wp/v2/posts?_embed";
      debugPrint(url);
      final response = await http.get(url);
      var convertData = jsonDecode(response.body);
      return convertData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: currentTheme,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          // toolbarHeight: 50,
          leading: Container(
            // margin: EdgeInsets.only(top:10),
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: 40,
                color: Colors.indigoAccent,
              ), // change this size and style
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          actions: [
            Container(
              // margin: EdgeInsets.only(top:5),
              child: IconButton(
                icon: Icon(Icons.search),
                iconSize: 50,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Search()));
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.asset(
                          "assets/Icon/icon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(MdiIcons.web),
                title: const Text("Visit Website"),
                onTap: () async {
                  await launch("https://philosophytoday.in");
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.account),
                title: const Text("Request for a contributor"),
                onTap: () async {
                  await launch(
                      "https://philosophytoday.in/online-internship-philosophy-today/");
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.pen),
                title: const Text("Essay Competition"),
                onTap: () async {
                  await launch(
                      "https://philosophytoday.in/2nd-philosophy-today-essay-competition-2021/");
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: fetchDynamic(type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map wpPost = snapshot.data[0];
                // debugPrint(wpPost.toString());
                // Map wpPost = snapshot.data['0'];
                return PostView(
                  title: wpPost["title"]["rendered"],
                  subtitle: wpPost["excerpt"]["rendered"],
                  featuredImage: wpPost["featured_image_urls"]["full"][0],
                  shortLink: wpPost["jetpack_shortlink"],
                  textData: wpPost["content"]["rendered"],
                  tags: wpPost["tags"].toString(),
                  authorEmail: wpPost["_embedded"]["author"][0]["link"],
                  authorName: wpPost["_embedded"]["author"][0]["name"],
                  authorImage: wpPost["_embedded"]["author"][0]["avatar_urls"]
                      ["96"],
                );
              } else {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(backgroundColor: Colors.indigoAccent,),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
