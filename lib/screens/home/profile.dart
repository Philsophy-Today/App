
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:hive/hive.dart';

Future getViewedPostData() async {
  try {
    var box = await Hive.openBox("websiteData");
    List data = box.get("viewedPostData");
    return data;
  } catch (e) {
    print(e);
    return {};
  }
}

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 60.0,
                      spreadRadius: 10.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(400),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 20.0,
                            spreadRadius: 4.0,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(400),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://images.unsplash.com/photo-1480455624313-e29b44bbfde1?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29uJTIwbWFsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                        ),
                      ),
                    ),
                    Container(
                        child: Text("Random Person",
                            style: Theme.of(context).textTheme.headline2)),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.account,
                                  color: Theme.of(context).hoverColor,
                                  size: 30,
                                ),
                                Text(
                                  "12K",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Text(
                                  "People\nReached",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.fileDocument,
                                  color: Theme.of(context).hoverColor,
                                  size: 30,
                                ),
                                Text(
                                  "12K",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Text(
                                  "Posts\nRead",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.thumbUp,
                                  color: Theme.of(context).hoverColor,
                                  size: 30,
                                ),
                                Text(
                                  "12K",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Text(
                                  "Like\nEngaged",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline4,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlineButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                        color: Colors.indigoAccent,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  OutlineButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Data Report",
                      style: GoogleFonts.poppins(
                        color: Colors.indigoAccent,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              child:Text("You are currently signed in."),
            )
          ],
        ),
      ),
    );
  }
}