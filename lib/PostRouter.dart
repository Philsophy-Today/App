import 'dart:convert';

import 'package:PhilosophyToday/PostView.dart';
import 'package:PhilosophyToday/postSearch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import "package:http/http.dart" as http;

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class PostRouter extends StatelessWidget {
  final List<String> type;
  final String url;
  PostRouter({this.type,this.url});

  Future<String> fetchDescription(String username) async{
    print(username);
    final response2 = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/users",
        headers: {"Accept":"application/json"}
    );
    var convertData2=jsonDecode(response2.body);
    print(convertData2);
    for(int i; i<=convertData2.length;i++){
      if (convertData2[i]["name"]==username){
        return convertData2[i]["description"].toString();
      }
    }
    return "";
  }

  Future<List> fetchDynamic(List type) async {
    if(type[0]=='slugBased'){
      String url = "http://philosophytoday.in/wp-json/wp/v2/posts?slug="+type[1].toString()+"&_embed";
      debugPrint(url);
      final response = await http.get(url);
      var convertData = jsonDecode(response.body);
      return convertData;

    } else {
      String url = "http://philosophytoday.in/wp-json/wp/v2/posts?_emded";
      debugPrint(url);
      final response = await http.get(url);
      var convertData = jsonDecode(response.body);
      return convertData;
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // toolbarHeight: 50,
          leading: Container(
            // margin: EdgeInsets.only(top:10),
            child: IconButton(
              icon: Icon(Icons.menu, size: 40,color: Colors.black87,), // change this size and style
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          actions: [
            Container(
              // margin: EdgeInsets.only(top:5),
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.black87),
                iconSize: 50,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search()));
                  },
              ),
            ),
          ],
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child:Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: "https://philosophytoday.in/wp-content/uploads/2021/01/cropped-cropped-Untitled-14-1.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Visit Website"),
              ),
              ListTile(
                title: Text("Request for a contributor"),
              ),
              ListTile(
                title: Text("Alpha"),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: fetchDynamic(type),
            builder: (context,snapshot){
              if (snapshot.hasData){
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
                  authorImage: wpPost["_embedded"]["author"][0]["avatar_urls"]["96"],
                );
              } else {
                return Center(
                  child: SizedBox(
                    height: 50,
                    width:50,
                    child:CircularProgressIndicator(),
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

