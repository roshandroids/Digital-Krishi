import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/customListTile.dart';
import 'package:digitalKrishi/UI/OtherScreens/news.dart';
import 'package:digitalKrishi/UI/OtherScreens/updateProfile.dart';
import 'package:digitalKrishi/UI/UserScreens/marketRate.dart';
import 'package:digitalKrishi/UI/UserScreens/nearByMarket.dart';
import 'package:digitalKrishi/UI/UserScreens/weatherUpdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class MoreSettings extends StatefulWidget {
  @override
  _MoreSettingsState createState() => _MoreSettingsState();
}

class _MoreSettingsState extends State<MoreSettings> {
  String userId;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((firebaseUser) async {
      if (firebaseUser != null) {
        setState(() {
          userId = firebaseUser.uid;
        });
      }
    });
  }

  Widget _buildProfileCard(BuildContext context, snapshot) {
    final String fullName = snapshot.data.data['fullName'];
    final String email = snapshot.data.data['email'];
    final String photoUrl = snapshot.data.data['photoUrl'];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: .5)),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(fullName),
                  Text(email),
                ],
              ),
            ),
          ),
          Container(
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userEdit,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    alignment: Alignment.bottomLeft,
                    duration: Duration(milliseconds: 100),
                    child: UpdateProfile(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(0xff, 32, 168, 74),
      ),
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80.0,
                  color: Color.fromARGB(0xff, 32, 168, 74),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('users')
                              .document(userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator(
                                backgroundColor: Colors.green,
                              );
                            return _buildProfileCard(context, snapshot);
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  alignment: Alignment.bottomLeft,
                                  duration: Duration(milliseconds: 100),
                                  child: WeatherUpdate()));
                        },
                        child: ListWidget(
                          icon: "storm",
                          title: "Weather Update",
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.green,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  alignment: Alignment.bottomLeft,
                                  duration: Duration(milliseconds: 100),
                                  child: MarketRate()));
                        },
                        child: ListWidget(
                          icon: "growth",
                          title: "Today's market price for vegetables",
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.green,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  alignment: Alignment.bottomLeft,
                                  duration: Duration(milliseconds: 100),
                                  child: News()));
                        },
                        child: ListWidget(
                          icon: "newspaper",
                          title: "Agricultural News",
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.green,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  alignment: Alignment.bottomLeft,
                                  duration: Duration(milliseconds: 100),
                                  child: NearByMarket()));
                        },
                        child: ListWidget(
                          icon: "search",
                          title: "Search Nearby vegetable Markets",
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
