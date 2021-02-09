import 'dart:convert';

import 'package:PhilosophyToday/tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
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

  PostView({
    this.title,
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
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ]),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: authorImage,
                  ),
                  title: Text("Author:  " + authorName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ],
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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ],
                ),
                child:PostData(title:title,textData: textData),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PostData extends StatelessWidget {
  final String textData;
  final String title;
  PostData({this.title,this.textData});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 23,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        Html(
          data: textData,
          onLinkTap: (url) async {
            eprint(url);
            await launch(url);
          },
        ),
      ],
    );
  }
}
