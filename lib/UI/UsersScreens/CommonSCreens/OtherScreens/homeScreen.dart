import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/NewsScreen/listNewsPortal.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/NewsScreen/readNews.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VideoScreens/allCategoryvideos.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VideoScreens/listvideos.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String userType;
  HomeScreen({@required this.userType});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildListNews(BuildContext context, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ReadNews(
                  url: document['url'],
                )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.18,
        margin: EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .5),
            blurRadius: 1.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: document['siteLogo'],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => SpinKitWave(
                    color: Colors.blue,
                    size: 50.0,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                document['siteName'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListVideos(BuildContext context, DocumentSnapshot document) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: ListVideos(
                      documentId: document.documentID,
                      userType: widget.userType,
                      category: document['title'],
                      videoUrl: document['videoUrl'],
                    )));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
            ),
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width / 2.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  "https://i3.ytimg.com/vi/${YoutubePlayer.convertUrlToId(document['videoUrl'][0])}/sddefault.jpg"))),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Center(
                          child: ((document['videoUrl'].length - 1) >= 1)
                              ? Text(
                                  "+" +
                                      (document['videoUrl'].length - 1)
                                          .toString() +
                                      " more",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    document['title'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Widget _buildListItemExpert(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpertDetails(
                      viewBy: widget.userType,
                      verificationDocument: document['verificationDocument'],
                      profileImage: document['photoUrl'],
                      fullName: document['fullName'],
                      email: document['email'],
                      userId: document['id'],
                      contact: document['contact'],
                      userType: document['userType'],
                      address: document['address'],
                      isVerified: document["isVerified"],
                      id: document.documentID,
                      collectionName: collectionName,
                    )),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 1.0,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: CachedNetworkImage(
                      imageUrl: document['photoUrl'],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              document['fullName'],
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          (document['isVerified'] == "Verified")
                              ? Icon(
                                  Icons.verified_user,
                                  color: Colors.green,
                                  size: 15,
                                )
                              : Container(),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          document['email'],
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void showInfo(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.black.withOpacity(.1),
              margin: EdgeInsets.all(20),
              child: Text(
                "You can directly contact the available farming experties, if you need any help. You can contact the through direct call or chat with them.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        // physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: true,
              pinned: false,
              snap: false,
              stretch: true,
              backgroundColor: Colors.black12,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                background: Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: true,
                    animationCurve: Curves.linear,
                    animationDuration: Duration(milliseconds: 700),
                    dotSize: 4.0,
                    dotIncreasedColor: Colors.red,
                    dotColor: Colors.black,
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomCenter,
                    dotVerticalPadding: 0.0,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    images: [
                      CachedNetworkImage(
                          placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 60.0,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fweather.jpg?alt=media&token=6a5fddd4-1dd7-4573-b122-1df595875061"),
                      CachedNetworkImage(
                          placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 60.0,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fnews.jpg?alt=media&token=de9b5d02-8491-47d9-84d6-37d8c575de0e"),
                      CachedNetworkImage(
                          placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 60.0,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Ffertilizer.jpg?alt=media&token=f796864d-225b-43a8-a4e8-dddf60133ebd"),
                      CachedNetworkImage(
                          placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 60.0,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fmap.jpg?alt=media&token=a8f1e852-2c37-40a5-86bd-724c02b1708d"),
                    ]),
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .4),
                          blurRadius: 1.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 0, top: 10),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: FaIcon(
                                    FontAwesomeIcons.newspaper,
                                    color: Colors.green,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "News Portals",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    alignment: Alignment.bottomLeft,
                                    duration: Duration(milliseconds: 100),
                                    child: ListNewsPortal(
                                      userType: widget.userType,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('newsPortal')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator(
                                backgroundColor: Colors.black12,
                              );
                            if (snapshot.data.documents.length <= 0)
                              return Stack(
                                children: [
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "News Portals not available currently !",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              );
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => _buildListNews(
                                context,
                                snapshot.data.documents[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .5),
                          blurRadius: 1.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5, right: 0, top: 10),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: FaIcon(
                                    FontAwesomeIcons.youtube,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Agriculture Videos",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllCategoryVideos(
                                          userType: widget.userType,
                                        )));
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 160,
                        child: StreamBuilder(
                          stream: Firestore.instance
                              .collection('videos')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return LinearProgressIndicator(
                                backgroundColor: Colors.black12,
                              );
                            if (snapshot.data.documents.length <= 0)
                              return Stack(
                                children: [
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.green,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Videos not available !",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              );
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => _buildListVideos(
                                context,
                                snapshot.data.documents[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                (widget.userType != "Expert")
                    ? Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .5),
                                blurRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 0, top: 10),
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: Image.asset(
                                        'lib/Assets/Images/expert.png',
                                        color: Colors.green,
                                        height: 30,
                                        width: 30,
                                      )),
                                      Expanded(
                                        child: Text(
                                          "Farming Experties",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.live_help),
                                    onPressed: () => showInfo(context),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 200,
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('users')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return LinearProgressIndicator(
                                      backgroundColor: Colors.green,
                                    );
                                  } else {
                                    var users = [];
                                    for (int i = 0;
                                        i < snapshot.data.documents.length;
                                        i++) {
                                      if (snapshot.data.documents[i]
                                              ["userType"] ==
                                          "Expert") {
                                        if (snapshot.data.documents[i]
                                                ["isVerified"] ==
                                            "Verified") {
                                          users.add(snapshot.data.documents[i]);
                                        }
                                      }
                                    }
                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: users.length,
                                      itemBuilder: (context, index) =>
                                          _buildListItemExpert(
                                              context, users[index], 'users'),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
