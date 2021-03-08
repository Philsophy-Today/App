import 'dart:convert';

import '../post/PostRouter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../tools/tools.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:PhilosophyToday/main.dart' show currentTheme, setTheme;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:html_unescape/html_unescape.dart';

import '../tools/Style.dart';

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class PostList extends StatelessWidget {
  final String type;
  final String slug;
  PostList({this.type, this.slug});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: darkTheme,
      theme:lightTheme,
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
                onPressed: () {},
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
                        child: Image.asset("assets/Icon/icon.png",fit: BoxFit.cover,),
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
        body: Builder(builder: (context) {
          if (type == "tags") {
            return TagList(tags: slug);
          } else if (type == "categories") {
            return CategoryList(tags: slug);
          } else if (type == "posts") {
            return PostsList();
          } else {
            return HotPostList();
          }
        }),
      ),
    );
  }
}

class TagList extends StatefulWidget {
  final String tags;
  TagList({this.tags});

  @override
  _TagListState createState() => _TagListState();

}

class _TagListState extends State<TagList> {
  Future<List> fetchTags(String tags) async {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?tags=$tags",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    if (convertData.length == 0) {
      debugPrint("error");
      return Future.error("No data");
    }
    return convertData;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var tag = tagToId(widget.tags);
    eprint(tag);
    return Container(
      child: FutureBuilder(
        future: fetchTags(tag),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map wpPost = snapshot.data[index];
                return PostCard(
                  imageUrl: wpPost['featured_image_urls']['large'][0],
                  title: wpPost['title']['rendered'].toString(),
                  subtitle: wpPost['excerpt']['rendered'],
                  slug: wpPost["slug"],
                  type: "slugBased",
                );
              },
            );
          } else if (snapshot.hasError) {
            return Container(
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Sorry, we found \n nothing.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lobster(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        child: Image(
                          image: AssetImage("assets/images/notFound.png"),
                        ),
                      ),
                    ),
                    Center(
                        child: Text("hmmmmmmm.....",
                            style: GoogleFonts.frijole(
                                color: Colors.orange,
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 50,
                                  )
                                ],
                            ),
                        ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  final String tags;
  CategoryList({this.tags});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Future<List> fetchCategories(String tags) async {
    int category = categoryToId(tags);
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?categories=$category",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    if (convertData.length == 0) {
      debugPrint("error");
      return Future.error("No data");
    }
    return convertData;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: FutureBuilder(
        future: fetchCategories(widget.tags),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map wpPost = snapshot.data[index];
                return PostCard(
                  imageUrl: wpPost['featured_image_urls']['large'][0],
                  title: wpPost['title']['rendered'].toString(),
                  subtitle: wpPost['excerpt']['rendered'],
                  type:"slugBased",
                  slug:wpPost["slug"],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Container(
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Sorry, we found \n nothing.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lobster(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        child: const Image(
                          image: AssetImage("assets/images/notFound.png"),
                        ),
                      ),
                    ),
                    Center(
                        child: Text("hmmmmmmm.....",
                            style: GoogleFonts.frijole(
                                color: Colors.orange,
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey,
                                    blurRadius: 50,
                                  )
                                ],
                            ),
                        ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              height: height,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PostsList extends StatefulWidget {
  final String tags;
  PostsList({this.tags});

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  Future<List> fetchTags(String tags) async {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?tag=$tags",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    return convertData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchTags(widget.tags),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map wpPost = snapshot.data[index];
                return PostCard(
                  imageUrl: wpPost['featured_image_urls']['large'][0],
                  title: wpPost['title']['rendered'].toString(),
                  subtitle: wpPost['excerpt']['rendered'],
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class HotPostList extends StatefulWidget {
  final String tags;
  HotPostList({this.tags});

  @override
  _HotPostListState createState() => _HotPostListState();
}

class _HotPostListState extends State<HotPostList> {
  Future<List> fetchTags(String tags) async {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?tag=$tags",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    return convertData;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: FutureBuilder(
        future: fetchTags(widget.tags),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != []) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map wpPost = snapshot.data[index];
                  eprint(snapshot.data);
                  return PostCard(
                    imageUrl: wpPost['featured_image_urls']['large'][0],
                    title: wpPost['title']['rendered'].toString(),
                    subtitle: wpPost['excerpt']['rendered'],
                  );
                },
              );
            } else {
              return Container(
                height: height,
                width: double.maxFinite,
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
              );
            }
          } else {
            return Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final bool first;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String slug;
  final String type;

  PostCard(
      {this.first,
      this.imageUrl,
      this.title,
      this.subtitle,
      this.slug,
      this.type});

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
    var unescape = new HtmlUnescape();
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: 310,
      // height: 450,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return PostRouter(
                type: [type, slug],
              );
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
                      unescape.convert(title),
                    style: Theme.of(context).textTheme.headline2
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(
                    subtitleData.truncateTo(100),
                    style: Theme.of(context).textTheme.headline4
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
