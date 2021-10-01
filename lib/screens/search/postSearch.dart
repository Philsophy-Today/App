import 'dart:convert';

import 'package:PhilosophyToday/main.dart' show currentTheme;
import 'package:PhilosophyToday/screens/tools/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../post/PostRouter.dart';
import '../tools/Style.dart';

class Post {
  final String title;
  final String body;
  final String imageUrl;
  final String slug;

  Post(this.title, this.body, this.imageUrl, this.slug);
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: currentTheme,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: Home(),
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

  Future<List<Post>> fetchCategories(String query) async {
    print(query);
    query = query.replaceAll("&", "");
    query = query.replaceAll("=", "");
    query = query.replaceAll("?", "");
    query = query.replaceAll("#", "");
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?search=$query",
        headers: {"Accept": "application/json"});
    List<Post> posts = [];
    var convertData = jsonDecode(response.body);
    // print(convertData);
    if (convertData.length == 0) return [];
    for (int i = 0; i < convertData.length; i++) {
      String subtitle = convertData[i]["excerpt"]["rendered"];
      String subtitleData = subtitle.replaceAll("<p>", "");
      subtitleData = subtitleData.replaceAll("</p>", "");
      posts.add(Post(
          convertData[i]["title"]["rendered"],
          subtitleData,
          convertData[i]["featured_image_urls"]["full"][0],
          convertData[i]["slug"]));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    var unescape = new HtmlUnescape();
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Post>(
          hintText: "Search Anything",
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: fetchCategories,
          textStyle: Theme.of(context).textTheme.headline3,
          header: Text("alpha"),
          icon: Icon(
            Icons.search,
            color: Colors.redAccent,
          ),
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
                  child: Image(
                    image: AssetImage("assets/image/search.png"),
                  ),
                ),
              ],
            ),
          ),
          searchBarStyle: SearchBarStyle(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5)),
          searchBarController: _searchBarController,
          cancellationWidget: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(MdiIcons.close, color: Colors.white),
          ),
          shrinkWrap: true,
          emptyWidget: Container(
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Sorry, we found \n nothing.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      child: Image(
                          image: AssetImage("assets/images/noSearch.png")),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onCancelled: () {
            Fluttertoast.showToast(
                msg: "Search cancelled",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 1,
          onError: (Error error) {
            return Text(error.toString());
          },
          onItemFound: (Post post, int index) {
            return Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                leading: SizedBox(
                  width: 100,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(unescape.convert(post.title).truncateTo(60)),
                isThreeLine: true,
                subtitle: Text(
                  post.body.truncateTo(40),
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PostRouter(type: ["slugBased", post.slug])));
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
