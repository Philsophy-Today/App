import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

int pageNum=1;
String url="http://philosophytoday.in/wp-json/wp/v2/posts?per_page=5&page=";

Future<List> fetchPosts({pageNum}) async{
  if (pageNum==null){
    pageNum=1;
  } else {
    pageNum+=1;
  }
  String fullUrl=url+pageNum.toString();
  final response = await http.get(fullUrl,
      headers: {"Accept":"application/json"}
  );
  var convertData=jsonDecode(response.body);
  return convertData;
}
main() {
  runApp(Home());
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: FutureBuilder(
            future: fetchPosts(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: 5,
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
                                        Column(
                                          children: [
                                            SizedBox(width:30,height:30,child: CircularProgressIndicator(value: downloadProgress.progress)),
                                          ],
                                        ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                child:Text(wpPost['title']['rendered']),
                              ),
                              Container(
                                  child:Html(data:wpPost['excerpt']['rendered']),

                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return Text("Cannot retrieve data");
                }
              } else {
                return Container(
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Center(
                      child:SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(),
                      )
                    ),
                  ),
                );
              }
            }
        ),
      ),
    );
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 500) {
      setState(() {
        items.addAll(new List.generate(42, (index) => 'Inserted $index'));
      });
    }
  }

}
