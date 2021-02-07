import 'dart:math';
import 'dart:convert';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:PhilosophyToday/tools.dart';

import 'PostRouter.dart';

class Post {
  final String title;
  final String body;
  final String imageUrl;
  final String slug;

  Post(this.title, this.body,this.imageUrl,this.slug);
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            height: height,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(image:AssetImage("assets/image/search.png"))),
              ],
            ),
          ),
          Home(),
        ],
      ),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Post>> fetchCategories(String query) async{
    print(query);
    query = query.replaceAll("&", "");
    query = query.replaceAll("=", "");
    query = query.replaceAll("?", "");
    if (query.contains(RegExp("#.*."))){
      final response = await http.get(
          "http://philosophytoday.in/wp-json/wp/v2/posts?tag=$query",
          headers: {"Accept":"application/json"}
      );
    }
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?search=$query",
        headers: {"Accept":"application/json"}
    );
    List<Post> posts = [];
    var convertData=jsonDecode(response.body);
    // print(convertData);
    if (convertData.length==0)return [];
    for (int i = 0; i < convertData.length; i++) {
      String subtitle = convertData[i]["excerpt"]["rendered"];
      String subtitleData=subtitle.replaceAll("<p>","");
      subtitleData=subtitleData.replaceAll("</p>", "");
      posts.add(Post(convertData[i]["title"]["rendered"],subtitleData,convertData[i]["featured_image_urls"]["full"][0],convertData[i]["slug"]));
    }
    return posts;
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Post>(
          hintText: "Search Anything",
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: fetchCategories,
          icon:Icon(Icons.search,color: Colors.redAccent,),
          placeHolder: Container(
            height: height,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(image:AssetImage("assets/image/search.png"))),
              ],
            ),
          ),
          searchBarStyle: SearchBarStyle(
            borderRadius: BorderRadius.only(
              topLeft:Radius.circular(30),
              bottomRight:Radius.circular(30),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            padding: EdgeInsets.only(left:10,right:5,top:5,bottom:5)
          ),
          searchBarController: _searchBarController,
          cancellationWidget:Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 30,
                ),
              ],
            ),
              child: Text(
                  "Cancel",
                style: GoogleFonts.poppins(color: Colors.white,),
              ),
          ),
          shrinkWrap: true,
          emptyWidget: Container(
            height:500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text("Sorry, we found \n nothing.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey,
                        ),
                      ),
                  ),
                  Center(
                    child:SizedBox(
                      child: Image(image:AssetImage("assets/images/noSearch.png")),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onCancelled: () {
            print("Cancelled triggered");
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onError: (Error error){
            return Text(error.toString());
          },
          onItemFound: (Post post, int index) {
            print(post.title);
            print(post.body);
            return Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 30,
                  )
                ]
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading:SizedBox(
                    width:110,
                    height:100,
                    child: CachedNetworkImage(
                        imageUrl:post.imageUrl,
                      fit: BoxFit.fill,
                    ),
                ),
                title: Text(post.title),
                isThreeLine: true,
                subtitle: Text(post.body.truncateTo(80)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostRouter(type:["slugBased",post.slug])));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}