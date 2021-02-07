import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;


class PostView extends StatefulWidget {
  String title;
  String featuredImage;
  String subtitle;
  String textData;
  String shortLink;
  String tags;
  String category;
  String authorName;
  String authorEmail;
  String authorImage;
  String authorDescription;

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
  _PostViewState createState() => _PostViewState();
}
class _PostViewState extends State<PostView> {

  Future<String> fetchDescription(String username) async{
    final response2 = await http.get(
        "http://philosophytoday.in/wp-json/wp/v2/users",
        headers: {"Accept":"application/json"}
    );
    var convertData2=jsonDecode(response2.body);
    for(int i; i<=convertData2.length;i++){
      print(i);
      if (convertData2[i]["name"]==username){
        return convertData2[i]["description"].toString();
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              Container(
                width:double.maxFinite,
                margin: EdgeInsets.only(bottom:20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ]
                ),
                child: ListTile(
                  leading: Container(
                    child: CachedNetworkImage(
                      imageUrl: widget.authorImage,
                    ),
                  ),
                  title: Container(
                    child: Text(
                        "Author:  "+widget.authorName,
                        style:GoogleFonts.poppins(
                          fontSize:18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        )
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom:20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: CachedNetworkImage(imageUrl: widget.featuredImage,),
              ),
              Container(
                margin: EdgeInsets.only(bottom:20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Text(
                        widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 23,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Html(data:widget.textData),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
