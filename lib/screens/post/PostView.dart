import 'dart:convert';

import 'package:PhilosophyToday/Services/dataManager.dart';
import 'package:PhilosophyToday/screens/tools/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import "package:http/http.dart" as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> fetchDescription(String username) async {
  final response2 = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/users",
      headers: {"Accept": "application/json"});
  var convertData2 = jsonDecode(response2.body);
  for (int i; i <= convertData2.length; i++) {
    print(i);
    if (convertData2[i]["name"] == username) {
      return convertData2[i]["description"].toString();
    }
  }
  return "";
}

class PostView extends StatelessWidget {
  final String title;
  final String featuredImage;
  final String subtitle;
  final String textData;
  final String shortLink;
  final String tags;
  final String category;
  final String authorName;
  final String authorEmail;
  final String authorImage;
  final String authorDescription;
  final String slug;
  PostView(
      {this.title,
      this.subtitle,
      this.featuredImage,
      this.shortLink,
      this.textData,
      this.tags,
      this.authorEmail,
      this.authorImage,
      this.authorName,
      this.category,
      this.authorDescription,
      this.slug});
  @override
  Widget build(BuildContext context) {
    postViewed(
      title,
      subtitle,
      featuredImage,
      shortLink,
      textData,
      tags,
      authorEmail,
      authorImage,
      authorName,
      category,
      authorDescription,
    );
    return Hero(
      tag: slug,
      child: Material(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 80,
                  color: Theme.of(context).primaryColor,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      width: 50,
                      imageUrl: authorImage,
                    ),
                    title: Text(
                      "Author:  " + authorName,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: featuredImage,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Theme.of(context).shadowColor,
                      )
                    ],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: PostData(
                    title: title,
                    textData: textData,
                    shortLink: shortLink,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PostData extends StatelessWidget {
  final String textData;
  final String title;
  final String shortLink;
  PostData({this.title, this.textData, this.shortLink});
  @override
  Widget build(BuildContext context) {
    var unescape = new HtmlUnescape();
    return Column(
      children: [
        Text(
          unescape.convert(title),
          style: Theme.of(context).textTheme.headline1,
        ),
        Divider(),
        Html(
          data: textData,
          onLinkTap: (url) async {
            eprint(url);
            await launch(url);
          },
        ),
        Divider(),
        ShareButtons(
          shortLink: shortLink,
        ),
      ],
    );
  }
}

class ShareButtons extends StatelessWidget {
  final String shortLink;
  ShareButtons({this.shortLink});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Share.share('Check out this post from philosophy today: $shortLink');
      },
      child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                MdiIcons.share,
              ),
              Text("Share", style: Theme.of(context).textTheme.headline3),
            ],
          )),
    );
  }
}
