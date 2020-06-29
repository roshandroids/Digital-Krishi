import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/popupMenu.dart';
import 'package:digitalKrishi/UI/AuthScreens/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class AdminHome extends StatefulWidget {
  final String uId;
  AdminHome({@required this.uId});
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  void onItemMenuPress(Choice choice) {
    logoutAlert(context);
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 300),
        child: SplashScreen(),
      ),
    );
  }

  void logoutAlert(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 120,
            color: Colors.black12,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                      leading: FaIcon(FontAwesomeIcons.signOutAlt),
                      title: Text('Yes, log Out'),
                      onTap: () {
                        logOut();
                        Navigator.of(context).pop();
                      }),
                ),
                Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
                Expanded(
                  child: ListTile(
                    leading: FaIcon(FontAwesomeIcons.ban),
                    title: Text('No, Stay logged In'),
                    onTap: () {
                      Navigator.of(context).pop();
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
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
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
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              actionsIconTheme: IconThemeData(
                color: Colors.black,
              ),
              expandedHeight: 300.0,
              floating: true,
              pinned: false,
              stretch: true,
              snap: true,
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
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.uId)
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
            physics: BouncingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
