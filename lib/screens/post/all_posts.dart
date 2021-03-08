import 'dart:convert';
import 'file:///F:/FlutterProjects/Philosophy_Today/PhilosophyToday/lib/screens/search/postSearch.dart';
import 'file:///F:/FlutterProjects/Philosophy_Today/PhilosophyToday/lib/screens/tools/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'PostRouter.dart';

class AllPosts extends StatefulWidget {
  @override
  _AllPostsState createState() => _AllPostsState();
}

final _scaffoldKey = new GlobalKey<ScaffoldState>();
List infinitePosts=[];
int totalPosts=int.parse(maxPost());
int infinitePostPageCount=1;
Future<List> fetchInfinitePosts(int pageNum) async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/posts?per_page=5&page=$pageNum",
      headers: {"Accept":"application/json"}
  );
  List convertData=jsonDecode(response.body);
  return convertData;
}
void getNewDataInfinite() async {
  List alpha = await fetchInfinitePosts(infinitePostPageCount);
  for(int i=0;i<=alpha.length-1;i++){
    Map a={
      "title":alpha[i]["title"]["rendered"],
      "subTitle":alpha[i]["excerpt"]["rendered"],
      "imageUrl":alpha[i]["featured_image_urls"]["large"][0],
      "slug":alpha[i]["slug"],
    };
    infinitePosts.add(a);
  }
  eprint(infinitePostPageCount);
  infinitePostPageCount++;
}

bool isPostAvailable(){
  if (totalPosts > infinitePosts.length){
    return true;
  } else {
    return false;
  }
}
class _AllPostsState extends State<AllPosts> {
  ScrollController controller;

  @override
  void initState(){
    super.initState();
    controller=new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }
  void _scrollListener() {
    if (controller.position.extentAfter < 100) {
      setState(() {
        eprint("firred");
        getNewDataInfinite();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    getNewDataInfinite();
    double height = MediaQuery. of(context).size.height;
    return MaterialApp(
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
        body: SizedBox(
            height: height,
            child:Container(
                padding: EdgeInsets.only(left:10,right:10),
                child:Builder(
                    builder:(BuildContext context){
                      eprint(infinitePosts.length);
                      return ListView.builder(
                        itemCount: infinitePosts.length,
                        controller: controller,
                        itemBuilder: (context, index) {
                          var data=infinitePosts[index];
                          return new LinePostCard(
                              title: data["title"],
                              subtitle:data["subTitle"],
                              imageUrl: data["imageUrl"],
                              slug:data["slug"]
                          );
                        },
                      );
                    }
                )
            )
        ),
      ),
    );
  }
}
class LinePostCard extends StatelessWidget {
  final bool first;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String slug;
  final String type;

  LinePostCard({this.first, this.imageUrl, this.title, this.subtitle, this.slug,this.type});

  @override
  Widget build(BuildContext context) {
    double leftVar = 0;
    if (first == true) {
      leftVar = 50;
    } else {
      leftVar = 0;
    }
    String subtitleData = subtitle.replaceAll("<p>", "");
    subtitleData = subtitleData.replaceAll("</p>", "");
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: 310,
      // height: 450,
      child: GestureDetector(
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return PostRouter(type: [type,slug],);
            }),
          );
        },
        child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Container(
            child: Column(
              children: [
                Container(
                  width: 400,
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
                    subtitleData.truncateTo(100),
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
