import 'package:PhilosophyToday/screens/home/notifications.dart';
import 'package:PhilosophyToday/screens/home/profile.dart';
import 'package:PhilosophyToday/screens/home/setting.dart';
import 'package:PhilosophyToday/screens/search/postSearch.dart';
import 'package:PhilosophyToday/screens/tools/Style.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:PhilosophyToday/main.dart' show currentTheme;
import 'package:url_launcher/url_launcher.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:PhilosophyToday/Services/auth.dart';
import 'package:PhilosophyToday/main.dart' show currentTheme, setTheme, isDarkModeEnabled;

import 'HomePage.dart';
bool loginAccepted = true;
final _scaffoldKey = new GlobalKey<ScaffoldState>();
class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}
void checkDarkModeEnabled(){
  if (currentTheme==ThemeMode.dark){
    isDarkModeEnabled=true;
  } else{
    isDarkModeEnabled=false;
  }
}
class SearchAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.search,
        ),
        iconSize: 50,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}
class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return MaterialApp(
      theme:lightTheme,
      darkTheme: darkTheme,
      themeMode: currentTheme,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: Container(
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: 40,
                color: Colors.indigoAccent,
              ), // change this size and style
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          actions: [
            SearchAction(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50),
                        ),
                      ),
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.asset("assets/Icon/icon.png",fit: BoxFit.cover,),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(MdiIcons.web),
                title: const Text("Visit Website"),
                onTap: () async {
                  await launch("https://philosophytoday.in");
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.account),
                title: const Text("Request for a contributor"),
                onTap: () async {
                  await launch(
                      "https://philosophytoday.in/online-internship-philosophy-today/");
                },
              ),
              ListTile(
                leading: Icon(MdiIcons.pen),
                title: const Text("Essay Competition"),
                onTap: () async {
                  await launch(
                      "https://philosophytoday.in/2nd-philosophy-today-essay-competition-2021/");
                },
              ),
              ListTile(
                  leading: const Icon(MdiIcons.weatherNight),
                  title: const Text("Dark Mode"),
                  trailing: DayNightSwitcher(
                    isDarkModeEnabled: isDarkModeEnabled,
                    onStateChanged: (darkMode) {
                      setState(() {
                        if (currentTheme==ThemeMode.dark){
                          currentTheme=ThemeMode.light;
                          isDarkModeEnabled=darkMode;
                          setTheme('lightTheme');
                        } else {
                          currentTheme=ThemeMode.dark;
                          isDarkModeEnabled=darkMode;
                          setTheme("darkTheme");
                        }
                      });
                    },
                  )
              ),
              ListTile(
                  leading: Icon(MdiIcons.logout),
                  title: const Text("Log Out"),
                  onTap: () async {
                    await _auth.signOut();
                  }
              ),
            ],
          ),
        ),
        body: MainViewThemed(),
      ),
    );
  }
}


class MainViewThemed extends StatefulWidget {
  @override
  _MainViewThemedState createState() => _MainViewThemedState();
}

class _MainViewThemedState extends State<MainViewThemed> with AutomaticKeepAliveClientMixin<MainViewThemed> {
  @override
  bool get wantKeepAlive => true;
  int _bottomNavIndex = 0;
  List<Widget> pages = [MainBody(), Notifications(), Profile(), Setting()];
  List<IconData> iconList = [
    MdiIcons.home,
    MdiIcons.email,
    MdiIcons.account,
    Icons.settings
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(_bottomNavIndex);
    print(currentTheme);
    return Scaffold(
      body: pages[_bottomNavIndex], //destination screen
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.plus),
        backgroundColor: Theme.of(context).hoverColor,
        foregroundColor: Colors.white,
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        elevation: 0,
        activeColor: Theme.of(context).hoverColor,
        inactiveColor: Colors.white,
        splashRadius: 20,
        splashColor: Theme.of(context).hoverColor,
        backgroundColor: Theme.of(context).primaryColorDark,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
