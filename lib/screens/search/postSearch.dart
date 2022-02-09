import 'dart:convert';

import 'package:PhilosophyToday/main.dart' show currentTheme;
// import 'package:flappy_search_bar/flappy_search_bar.dart';
// import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

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
  // final SearchBarController<Post> _searchBarController = SearchBarController();
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
      body: SafeArea(child: Text('')),
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
