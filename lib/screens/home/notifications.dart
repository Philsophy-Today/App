import 'package:PhilosophyToday/screens/post/ListPost.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PostsList(800, TypesWidget());
  }
}

class TypesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20, top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PostList(type: "categories",slug: "ethics",);
                      }),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/healthCard.png"),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 20)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PostList(type: "categories",slug: "education",);
                      }),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      image: DecorationImage(
                        image: AssetImage("assets/images/educationCard.png"),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor, blurRadius: 20)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return PostList(type: "categories",slug: "article",);
                      }),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      image: DecorationImage(
                        image: AssetImage("assets/images/scienceCard.png"),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor, blurRadius: 20)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                          return PostList(type: "categories",slug: "mind",);
                      }),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      image: DecorationImage(
                        image: AssetImage("assets/images/mindCard.png"),
                        fit: BoxFit.contain,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor, blurRadius: 20)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
