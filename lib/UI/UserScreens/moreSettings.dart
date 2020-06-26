import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/customListTile.dart';
import 'package:digitalKrishi/CustomComponents/popupMenu.dart';
import 'package:digitalKrishi/UI/OtherScreens/allCategoryvideos.dart';
import 'package:digitalKrishi/UI/OtherScreens/calculate.dart';
import 'package:digitalKrishi/UI/OtherScreens/fertilizerCalculate.dart';
import 'package:digitalKrishi/UI/OtherScreens/listNewsPortal.dart';
import 'package:digitalKrishi/UI/OtherScreens/listvideos.dart';
import 'package:digitalKrishi/UI/OtherScreens/updateProfile.dart';
import 'package:digitalKrishi/UI/UserScreens/marketRate.dart';
import 'package:digitalKrishi/UI/UserScreens/nearByMarket.dart';
import 'package:digitalKrishi/UI/UserScreens/weatherUpdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class MoreSettings extends StatefulWidget {
  @override
  _MoreSettingsState createState() => _MoreSettingsState();
}

class _MoreSettingsState extends State<MoreSettings> {
  String userId;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'My Profile', icon: Icons.account_box),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
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

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/AuthMainScreen');
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      logoutAlert(context);
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UpdateProfile()));
    }
  }

  void logoutAlert(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.signOutAlt),
                    title: Text('Yes, log Out'),
                    onTap: () {
                      logOut();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.ban),
                  title: Text('No, Stay logged In Picture'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void showTools() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 100,
            color: Colors.black12,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                      leading: Image.asset(
                        'lib/Assets/Images/pesticide.png',
                        height: 30,
                        width: 30,
                      ),
                      trailing: Icon(Icons.arrow_right),
                      title: Text('Fertilizer Calculator'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Calculate(
                                  url: "https://agritechnepal.com/calc/seed/",
                                )));
                      }),
                ),
                Expanded(
                  child: ListTile(
                    leading: Image.asset(
                      'lib/Assets/Images/seeds.png',
                      height: 30,
                      width: 30,
                    ),
                    trailing: Icon(Icons.arrow_right),
                    title: Text('Seed calculator'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Calculate(
                                url:
                                    "https://agritechnepal.com/calc/fertilizer/",
                              )));
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildProfileCard(BuildContext context, snapshot) {
    final String fullName = snapshot.data.data['fullName'];

    final String photoUrl = snapshot.data.data['photoUrl'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        border: Border.all(width: 1),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => SpinKitWave(
                  color: Colors.blue,
                  size: 50.0,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(left: 5, bottom: 5),
              padding: EdgeInsets.all(8),
              child: Text(
                "Hello, " + fullName,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: PopupMenuButton<Choice>(
                    onSelected: onItemMenuPress,
                    itemBuilder: (BuildContext context) {
                      return choices.map((Choice choice) {
                        return PopupMenuItem<Choice>(
                            value: choice,
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  choice.icon,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                Container(
                                  width: 10.0,
                                ),
                                Text(
                                  choice.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                              ],
                            ));
                      }).toList();
                    },
                  ),
                ),
              ],
              expandedHeight: 300.0,
              floating: true,
              pinned: false,
              snap: true,
              stretch: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                      );
                    if (snapshot.data.data == null)
                      return Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.grey[100],
                        child: Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                      );
                    return _buildProfileCard(context, snapshot);
                  },
                ),
              ),
            ),
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            alignment: Alignment.bottomLeft,
                            duration: Duration(milliseconds: 100),
                            child: MarketRate(
                              url:
                                  'https://nepalicalendar.rat32.com/vegetable/embed.php',
                            )));
                  },
                  child: ListWidget(
                    icon: "growth",
                    title: "Today's market price for vegetables",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            alignment: Alignment.bottomLeft,
                            duration: Duration(milliseconds: 100),
                            child: ListNewsPortal()));
                  },
                  child: ListWidget(
                    icon: "newspaper",
                    title: "Agricultural News",
                  ),
                ),
                GestureDetector(
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            alignment: Alignment.bottomLeft,
                            duration: Duration(milliseconds: 100),
                            child: AllCategoryVideos()));
                  },
                  child: ListWidget(
                    icon: "video",
                    title: "Agricultural Videos",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showTools();
                  },
                  child: ListWidget(
                    icon: "calculator",
                    title: "Calculation Tools",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
