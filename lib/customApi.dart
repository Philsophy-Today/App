import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_html/flutter_html.dart';

Future<List> fetchPosts() async{
  final response = await http.get(
      "http://philosophytoday.in/wp-json/wp/v2/posts",
    headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}
main() {
  runApp(Home());
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Container(
          child:FutureBuilder(
            future: fetchPosts(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map wpPost = snapshot.data[index];
                        return Container(
                          //height:260,
                          margin: EdgeInsets.only(bottom:20,right:10,left:10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 100,
                                offset: Offset(0,5)
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: SizedBox(
                                  width: 500,
                                  height:200,
                                  child: CachedNetworkImage(
                                    imageUrl: wpPost['featured_image_urls']['large'][0],
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                child:Text(wpPost['title']['rendered']),
                              ),
                              Container(
                                child:Html(data:wpPost['excerpt']['rendered'])
                              ),
                              // Container(
                              //   child:FractionallySizedBox(
                              //     widthFactor: 1.0,
                              //     child: Row(
                              //       children: [
                              //         ListTile(
                              //           leading: Icon(MdiIcons.account),
                              //           title: Text("This is author name"),
                              //         ),
                              //         ListTile(
                              //           leading: Icon(MdiIcons.calendar),
                              //           title: Text("21/2/21"),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        );
                      });
                } else {
                  return Text("Cannot retrieve data");
                }
              } else {
                return CircularProgressIndicator();
              }
            }
        ),
        ),
      ),
    );
  }
}
