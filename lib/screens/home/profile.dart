import 'package:PhilosophyToday/Services/auth.dart';
import 'package:PhilosophyToday/Services/dataManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    final AuthService _auth = AuthService();
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
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.3),
                                blurRadius: 30.0, // soften the shadow
                                spreadRadius: 4.0, //extend the shadow
                                offset: Offset(
                                  0.0, // Move to right 10  horizontally
                                  10.0, // Move to bottom 10 Vertically
                                ),
                              ),
                            ],
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
                                      fit: BoxFit.cover,
                                    ),
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
                        )),
                    Container(
                      child: FutureBuilder(
                        future: getUserName(),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data,
                                style: Theme.of(context).textTheme.headline2);
                          } else {
                            return Text("Hii Anonymous",
                                style: Theme.of(context).textTheme.headline2);
                          }
                        },
                      ),
                    ),
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
                    onPressed: () async {
                      await _auth.signOut();
                    },
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
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "The data report is not available",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color.fromRGBO(93, 119, 254, 0.6),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Text("You are currently signed in."),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.0, bottom: 40.0),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(enabled: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 1),
                        FlSpot(2, 2),
                        FlSpot(3, 3),
                        FlSpot(4, 4),
                        FlSpot(5, 3)
                      ],
                      isCurved: true,
                      barWidth: 2,
                      colors: [
                        Colors.orange,
                      ],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [
                          Colors.indigo,
                          Colors.indigoAccent,
                        ],
                        cutOffY: 0,
                        applyCutOffY: true,
                      ),
                      aboveBarData: BarAreaData(
                        show: false,
                        colors: [Colors.indigoAccent.withOpacity(0.5)],
                        cutOffY: 12,
                        applyCutOffY: true,
                      ),
                      dotData: FlDotData(
                        show: true,
                      ),
                    ),
                  ],
                  minY: 0,
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 5,
                        // textStyle: yearTextStyle,
                        getTextStyles: (double value) {
                          return const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          );
                        },
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return '2016';
                            case 1:
                              return '2017';
                            case 2:
                              return '2018';
                            case 3:
                              return '2019';
                            case 4:
                              return '2020';
                            case 5:
                              return '2021';

                            default:
                              return '';
                          }
                        }),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (double value) {
                        return const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        );
                      },
                      getTitles: (value) {
                        return '\$ ${value + 100}';
                      },
                    ),
                  ),
                  axisTitleData: FlAxisTitleData(
                      leftTitle: AxisTitle(
                        showTitle: true,
                        titleText: 'Value',
                        margin: 10,
                        textStyle: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      bottomTitle: AxisTitle(
                          showTitle: true,
                          margin: 10,
                          titleText: 'Year',
                          textStyle:
                              TextStyle(fontSize: 13, color: Colors.white),
                          textAlign: TextAlign.right)),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (double value) {
                      return value == 1 ||
                          value == 2 ||
                          value == 3 ||
                          value == 4;
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
