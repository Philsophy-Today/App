import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:PhilosophyToday/Services/dataManager.dart';
import 'package:PhilosophyToday/screens/post/ListPost.dart';
import 'package:PhilosophyToday/screens/tools/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../post/PostRouter.dart';

bool loginAccepted = true;
var unescape = new HtmlUnescape();
Future<List> fetchPosts() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?per_page=20",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("postsData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("postsData");
    return convertData;
  }
}

Future<List> fetchHighlight() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/posts?categories=5&&per_page=5",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("highlightData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("highlightData");
    return convertData;
  }
}

Future<List> fetchTags() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/tags?per_page=10",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("fetchedTagsData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("fetchedTagsData");
    return convertData;
  }
}

Future<List> fetchCategories() async {
  var box = await Hive.openBox("websiteData");
  try {
    final response = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/categories",
        headers: {"Accept": "application/json"});
    var convertData = jsonDecode(response.body);
    box.put("fetchedCategoriesData", convertData);
    return convertData;
  } catch (e) {
    final convertData = box.get("fetchedCategoriesData");
    return convertData;
  }
}

int random(min, max) {
  var rn = new Random();
  return min + rn.nextInt(max - min);
}

List<Color> randomColor() {
  List<Color> colorsList = [
    Colors.orangeAccent,
    Colors.indigoAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.green,
    Colors.deepPurpleAccent,
  ];
  return [colorsList[random(0, colorsList.length - 1)], Colors.white];
}

List buildColorList(length) {
  List data = [];
  for (int i = 0; i < length; i++) {
    data.add(randomColor());
  }
  return data;
}

class MainBody extends StatefulWidget {
  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.only(bottom: 20),
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColorDark,
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: getUserName(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "Hii " +
                                      snapshot.data
                                          .toString()
                                          .split(" ")[0]
                                          .capitalize(),
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.white),
                                );
                              } else {
                                return Text(
                                  "Hii Anonymous",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.white),
                                );
                              }
                            },
                          ),
                          Text(
                            "Welcome Back!",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: FutureBuilder(
                          future: getUserImage(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasData) {
                              bool _validURL =
                                  Uri.parse(snapshot.data).isAbsolute;
                              if (!_validURL) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(snapshot.data,
                                      fit: BoxFit.cover),
                                );
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                      imageUrl: snapshot.data,
                                      fit: BoxFit.cover),
                                );
                              }
                            } else {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: "https://via.placeholder.com/150",
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 250,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChipCard(
                          text: "Ethics",
                          icon: MdiIcons.face,
                          iconColor: Colors.white,
                          backgroundColor: Theme.of(context).disabledColor,
                          slug: "ethics",
                        ),
                        ChipCard(
                            text: "Books",
                            icon: MdiIcons.book,
                            iconColor: Colors.white,
                            backgroundColor: Theme.of(context).disabledColor,
                            slug: "book-launch"),
                        ChipCard(
                          text: "Most Liked",
                          slug: "article",
                          icon: MdiIcons.heart,
                          iconColor: Colors.white,
                          backgroundColor: Theme.of(context).disabledColor,
                        ),
                      ],
                    )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ChipCard(
                            text: "Mind",
                            slug: "philosophy-of-mind",
                            icon: MdiIcons.brain,
                            iconColor: Colors.white,
                            backgroundColor: Theme.of(context).disabledColor,
                          ),
                          ChipCard(
                            text: "Political",
                            slug: "social-political-philosophy",
                            icon: MdiIcons.accountChildCircle,
                            iconColor: Colors.white,
                            backgroundColor: Theme.of(context).disabledColor,
                          ),
                          ChipCard(
                            text: "Latest",
                            slug: "latest-findings-in-philosophy",
                            icon: MdiIcons.message,
                            iconColor: Colors.white,
                            backgroundColor: Theme.of(context).disabledColor,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text("Popular Tags",
              style: Theme.of(context).textTheme.headline2),
        ),
        Container(
          height: 150,
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: fetchTags(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List colors = buildColorList(snapshot.data.length);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map wpPost = snapshot.data[index];
                    return TagBox(
                      tagText: unescape
                          .convert(wpPost["name"].toString().capitalize()),
                      colors: colors[index],
                    );
                  },
                );
              } else {
                return Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).hoverColor)),
                );
              }
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: SizedBox(
            height: 300,
            child: Container(
              color: Color.fromRGBO(20, 20, 20, 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      "Your Stories",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Container(
                    height: 260,
                    child: FutureBuilder(
                      future: fetchHighlight(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          bool first;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                first = true;
                              } else {
                                first = false;
                              }
                              Map wpPost = snapshot.data[index];
                              return CardWidget(
                                first: first,
                                title: unescape
                                    .convert(
                                        wpPost['title']['rendered'].toString())
                                    .truncateTo(80),
                                imageUrl: wpPost['featured_image_urls']['large']
                                    [0],
                                slug: wpPost["slug"],
                                type: "slugBased",
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).hoverColor)),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text("Trending Topics",
              style: Theme.of(context).textTheme.headline2),
        ),
        Container(
          height: 150,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: FutureBuilder(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map wpPost = snapshot.data[index];
                    var item = wpPost["description"].toString();
                    var document = parse(item);
                    var imageElement = document
                        .getElementsByTagName("img")
                        .where((e) => e.attributes.containsKey('src'))
                        .map((e) => e.attributes['src'])
                        .toList();
                    if (imageElement.length == 0) {
                      imageElement.add("https://via.placeholder.com/250");
                    }
                    return ImageTagBox(
                      imageUrl: imageElement[0],
                      tagText: unescape.convert(wpPost["name"]),
                    );
                  },
                );
              } else {
                return Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).hoverColor)),
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 420,
          child: FutureBuilder(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                bool first;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      first = true;
                    } else {
                      first = false;
                    }
                    Map wpPost = snapshot.data[index];
                    return PostCard(
                      first: first,
                      title: unescape
                          .convert(wpPost['title']['rendered'].toString()),
                      subtitle: unescape
                          .convert(wpPost['excerpt']['rendered'].toString()),
                      imageUrl:
                          wpPost['featured_image_urls']['large'].length > 0
                              ? wpPost['featured_image_urls']['large'][0]
                              : '',
                      slug: wpPost["slug"],
                    );
                  },
                );
              } else {
                return Center(
                  child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).hoverColor)),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class TagBox extends StatelessWidget {
  final String tagText;
  final List colors;
  TagBox({this.tagText, this.colors});
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PostList(
              type: "tags",
              slug: tagText,
            );
          }),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, top: 20, bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: colors[0],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(
            "#" + tagText,
            softWrap: true,
            style: GoogleFonts.poppins(
              fontSize: varFontSize,
              fontWeight: FontWeight.w800,
              color: colors[1],
            ),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PostList(
              type: "categories",
              slug: tagText,
            );
          }),
        );
      },
      child: Container(
        width: 130,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10, top: 20),
              decoration: BoxDecoration(
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
            Flexible(
              child: Text(
                tagText,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.headline2,
              ),
            )
          ],
        ),
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

  PostCard({this.first, this.imageUrl, this.title, this.subtitle, this.slug});

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return PostRouter(type: ["slugBased", slug]);
          }),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: leftVar, right: 20, bottom: 50),
        width: 310,
        // height: 450,
        child: Card(
          elevation: 20,
          shadowColor: Theme.of(context).shadowColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              Container(
                width: 300,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: Text(title.truncateTo(45),
                    style: Theme.of(context).textTheme.headline2),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Text(
                  subtitleData.truncateTo(80),
                  style: Theme.of(context).textTheme.headline4,
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
  final String slug;
  final String type;
  CardWidget({this.first, this.imageUrl, this.title, this.slug, this.type});

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
      height: 200,
      child: Hero(
        tag: slug,
        child: Material(
          color: Colors.transparent,
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
              shadowColor: Theme.of(context).shadowColor,
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
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Text(title, style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChipCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color iconColor;
  final String slug;
  ChipCard(
      {this.text, this.icon, this.backgroundColor, this.iconColor, this.slug});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return PostList(
                type: "categories",
                slug: slug,
              );
            },
          ),
        );
      },
      child: SizedBox(
        width: 100,
        height: 110,
        child: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: this.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                this.icon,
                color: this.iconColor,
                size: 30,
              ),
              Text(
                this.text,
                style: GoogleFonts.poppins(fontSize: 13, color: this.iconColor),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChipFunctionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final String slug;
  final Function onTap;
  ChipFunctionCard(
      {this.text,
      this.icon,
      this.backgroundColor,
      this.iconColor,
      this.slug,
      this.onTap,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColor,
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 110,
        child: Container(
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: this.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                this.icon,
                color: this.iconColor,
                size: 30,
              ),
              Text(
                this.text,
                style: GoogleFonts.poppins(fontSize: 13, color: this.textColor),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
