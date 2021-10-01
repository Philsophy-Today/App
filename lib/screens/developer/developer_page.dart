import 'package:PhilosophyToday/screens/home/HomePage.dart';
import 'package:PhilosophyToday/screens/tools/Style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class DeveloperPage extends StatefulWidget {
  @override
  _DeveloperPageState createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
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
            var isExpanded = false;
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
                body: ListView(
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://images.unsplash.com/photo-1509023464722-18d996393ca8?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=720&q=80",
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: Text(
                              "Kumar Saptam",
                              style: Theme.of(context).textTheme.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          ChipFunctionCard(
                            onTap: () async {
                              await launch(
                                  "https://www.buymeacoffee.com/sapython");
                            },
                            textColor: Colors.white,
                            text: "Buy me a \ncoffee",
                            slug: "article",
                            icon: MdiIcons.coffee,
                            iconColor: Colors.orange,
                            backgroundColor: Theme.of(context).backgroundColor,
                          ),
                          Spacer(),
                          ChipFunctionCard(
                            onTap: () async {
                              await launch("https://sapython.me");
                            },
                            textColor: Colors.white,
                            text: "Visit \n website",
                            slug: "article",
                            icon: MdiIcons.web,
                            iconColor: Colors.pink,
                            backgroundColor: Theme.of(context).backgroundColor,
                          ),
                          Spacer(),
                          ChipFunctionCard(
                            onTap: () async {
                              await launch("https://twitter.com/saptam_kumar");
                            },
                            textColor: Colors.white,
                            text: "Tweet \n me",
                            slug: "article",
                            icon: MdiIcons.twitter,
                            iconColor: Colors.lightBlueAccent,
                            backgroundColor: Theme.of(context).backgroundColor,
                          ),
                        ],
                      ),
                    ),
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                            isExpanded: isExpanded,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                leading: Icon(MdiIcons.codeBraces),
                                title: Text(
                                  "About the developer",
                                ),
                              );
                            },
                            body: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur cursus tincidunt commodo. Nunc justo nisi, vestibulum facilisis porta vestibulum, ultrices volutpat arcu. Quisque nec dui mattis, fringilla magna in, vulputate enim. Fusce ut euismod ligula, id laoreet ex. "))
                      ],
                    ),
                    Center(
                      child: Text(
                        'Animations and icons from IconScout',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ));
          },
        ));
  }
}
