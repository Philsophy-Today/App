import 'dart:convert';

import 'package:PhilosophyToday/main.dart' show currentTheme, setTheme;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../post/PostRouter.dart';
import '../tools/Style.dart';
import '../tools/tools.dart';

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class PostList extends StatelessWidget {
  final String type;
  final String slug;
  PostList({this.type, this.slug});
  @override
  Widget build(BuildContext context) {
    void backToHome() {
      Navigator.pop(context);
    }

    return MaterialApp(
        darkTheme: darkTheme,
        theme: lightTheme,
        themeMode: currentTheme,
        home: Builder(
          builder: (context) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColorDark,
                elevation: 0,
                // toolbarHeight: 50,
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () => backToHome(),
                ),
                actions: [
                  Container(
                    // margin: EdgeInsets.only(top:5),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {},
                    ),
                  ),
                ],
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
            );
          },
        ));
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
      color: Theme.of(context).primaryColor,
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
            print("==>>  " + snapshot.hasError.toString());
            return Container(
              color: Theme.of(context).primaryColor,
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
                      child: Text(
                        "hmmmmmmm.....",
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
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).hoverColor,
                    ),
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
      color: Theme.of(context).primaryColor,
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
                  type: "slugBased",
                  slug: wpPost["slug"],
                );
              },
            );
          } else if (snapshot.hasError &&
              snapshot.connectionState != ConnectionState.done) {
            print("==>>" + snapshot.hasError.toString());
            print("==>" + snapshot.toString());
            return Container(
              color: Theme.of(context).primaryColor,
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
                      child: Text(
                        "hmmmmmmm.....",
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
            print("waiting for connection using progress indicator");
            return Container(
              color: Theme.of(context).primaryColor,
              height: height,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).hoverColor,
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class PostsList extends StatefulWidget {
  double height = 400;
  Widget widget;
  PostsList([this.height, this.widget]);
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  Future<List> fetchTags() async {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?per_page=100",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    return convertData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: widget.height,
      child: FutureBuilder(
        future: fetchTags(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 && widget.widget != null) {
                  return widget.widget;
                }
                Map wpPost = snapshot.data[index];
                return PostCard(
                  imageUrl: wpPost['featured_image_urls']['large'][0],
                  title: wpPost['title']['rendered'].toString(),
                  subtitle: wpPost['excerpt']['rendered'],
                );
              },
            );
          } else {
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).hoverColor,
                  ),
                ),
              ),
            );
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
      color: Theme.of(context).primaryColor,
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
                color: Theme.of(context).primaryColor,
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
                      placeholder: (context, url) {
                        return Container(
                          child: Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).hoverColor),
                            ),
                          ),
                        );
                      },
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: Text(unescape.convert(title),
                      style: Theme.of(context).textTheme.headline2),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(subtitleData.truncateTo(100),
                        style: Theme.of(context).textTheme.headline4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
