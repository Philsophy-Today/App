import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';

void main() {
  runApp(HomePage());
}

extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (this.length <= maxLength) ? this : '${this.substring(0, maxLength)}...';
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

bool loginAccepted = true;
final _scaffoldKey = new GlobalKey<ScaffoldState>();

Future<List> fetchPosts() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/posts",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}

Future<List> fetchHighlight() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/posts?category=Alerts&&per_page=5",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}

Future<List> fetchTags() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/tags?per_page=10",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}

Future<List> fetchCategories() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/categories",
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CustomAppBar());
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {},
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
                  Text(
                      "Philosophy Today",
                    style: GoogleFonts.dancingScript(
                      fontSize: 20,
                      color: Color.fromRGBO(30, 114, 190, 1),
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
      body: MainBody(),
    );
  }
}

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      children: [
        SizedBox(
            height: 260,
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Your Stories",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    ),
                  ),
                  Container(
                      height: 230,
                      child:FutureBuilder(
                        future: fetchPosts(),
                        builder: (context,snapshot){
                          if (snapshot.hasData){
                            bool first;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder:(BuildContext context, int index){
                                if (index==0){first=true;}else{first=false;}
                                Map wpPost = snapshot.data[index];
                                return Container(
                                  child:CardWidget(
                                    first: first,
                                    title: wpPost['title']['rendered'].toString().truncateTo(25),
                                    imageUrl: wpPost['featured_image_urls']['large'][0],
                                  )
                                );
                              },
                            );
                          }else{
                            return Center(
                              child: SizedBox(
                                height: 50,
                                width:50,
                                child:CircularProgressIndicator()
                              ),
                            );
                          }
                        },
                      )
                  ),
                ],
              ),
            )),
        Container(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Popular Tags",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
              future: fetchTags(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        Map wpPost = snapshot.data[index];
                        return TagBox(tagText: wpPost["name"].toString().capitalize());
                      },
                  );
                }else{
                  return Center(
                    child: SizedBox(
                        height: 50,
                        width:50,
                        child:CircularProgressIndicator()
                    ),
                  );
                }
              },
            )
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Trending Topics",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
            height: 150,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: FutureBuilder(
              future: fetchCategories(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        Map wpPost = snapshot.data[index];
                        return ImageTagBox(
                          imageUrl: ("https://images.unsplash.com/photo-1583791031293-194839d9f8d9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTR8fHBoaWxvc29waHl8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
                          tagText: wpPost["name"],
                        );
                      }
                  );
                }else{
                  return Center(
                    child: SizedBox(
                        height: 50,
                        width:50,
                        child:CircularProgressIndicator()
                    ),
                  );
                }
              },
            ),
        ),
        Divider(),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 420,
          child: FutureBuilder(
            future: fetchPosts(),
            builder: (context,snapshot){
              if (snapshot.hasData){
                bool first;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder:(BuildContext context, int index){
                    if (index==0){first=true;}else{first=false;}
                    Map wpPost = snapshot.data[index];
                    return Container(
                        child:PostCard(
                          first: first,
                          title: wpPost['title']['rendered'].toString(),
                          subtitle: wpPost['excerpt']['rendered'],
                          imageUrl: wpPost['featured_image_urls']['large'][0],
                        )
                    );
                  },
                );
              }else{
                return Center(
                  child: SizedBox(
                      height: 50,
                      width:50,
                      child:CircularProgressIndicator()
                  ),
                );
              }
            },
          )
        ),
      ],
    );
  }
}

random(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}

List randomColors() {
  int r = random(80, 250);
  int g = random(80, 250);
  int b = random(80, 250);
  int tr;
  int tb;
  int tg;
  if (Color.fromRGBO(r, g, b, 1).computeLuminance() > 0.4) {
    tr = 50;
    tg = 50;
    tb = 50;
  } else {
    tr = 255;
    tg = 255;
    tb = 255;
  }
  return [Color.fromRGBO(r, g, b, 1), Color.fromRGBO(tr, tg, tb, 1)];
}

class TagBox extends StatelessWidget {
  final String tagText;
  TagBox({this.tagText});
  @override
  Widget build(BuildContext context) {
    double varFontSize = 13;
    if (tagText.length <= 8) {
      varFontSize = 20;
    } else if (tagText.length > 8 && tagText.length <= 12) {
      varFontSize = 15;
    } else {
      varFontSize = 10;
    }
    List a = randomColors();
    return Container(
      margin: EdgeInsets.only(right: 10, top: 20, bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: a[0],
          blurRadius: 10,
        )
      ], color: a[0], borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          "#" + tagText,
          softWrap: true,
          style: GoogleFonts.poppins(
            fontSize: varFontSize,
            fontWeight: FontWeight.w800,
            color: a[1],
          ),
        ),
      ),
    );
  }
}

class ImageTagBox extends StatelessWidget {
  final String tagText;
  final String imageUrl;
  ImageTagBox({this.tagText, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                imageUrl: imageUrl,
              ),
            ),
          ),
          Text(
            tagText,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final bool first;
  final String imageUrl;
  final String title;
  final String subtitle;

  PostCard({this.first, this.imageUrl, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    double leftVar = 0;
    if (first == true) {
      leftVar = 50;
    } else {
      leftVar = 0;
    }
    String subtitleData=subtitle.replaceAll("<p>","");
    subtitleData=subtitleData.replaceAll("</p>", "");
    // var htmlParsedData=parse(subtitle);
    // print(htmlParsedData.outerHtml);
    // String subtitleData=htmlParsedData.getElementsByTagName('p')[0].children[0].text;
    // String subtitleData="alpha";
    return Container(
      margin: EdgeInsets.only(left: leftVar, right: 20, bottom: 50),
      width: 310,
      // height: 450,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                    subtitleData.truncateTo(80),
                  style: GoogleFonts.poppins(
                    fontSize: 15,fontWeight: FontWeight.w500,color:Color.fromRGBO(0, 0, 0, 0.8)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final bool first;
  final String imageUrl;
  final String title;
  CardWidget({this.first, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    double leftVar = 0;
    if (first == true) {
      leftVar = 50;
    } else {
      leftVar = 0;
    }
    return Container(
      margin: EdgeInsets.only(left: leftVar, right: 20, bottom: 20),
      width: 250,
      height: 150,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 250,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Container(width:50,height:50,child: CircularProgressIndicator(value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
