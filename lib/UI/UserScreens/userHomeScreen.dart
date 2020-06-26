import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/allCategoryvideos.dart';
import 'package:digitalKrishi/UI/OtherScreens/listNewsPortal.dart';
import 'package:digitalKrishi/UI/OtherScreens/listvideos.dart';
import 'package:digitalKrishi/UI/OtherScreens/readNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  Widget _buildListNews(BuildContext context, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReadNews(
                      url: document['url'],
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.18,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(width: .1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
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
          ],
        ),
      ),
    );
  }

  Widget _buildListVideos(BuildContext context, DocumentSnapshot document) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListVideos(
                      category: document['title'],
                      videoUrl: document['videoUrl'],
                    )));
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        width: MediaQuery.of(context).size.width / 2.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 50.0,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          imageUrl:
                              "https://i3.ytimg.com/vi/${YoutubePlayer.convertUrlToId(document['videoUrl'][0])}/sddefault.jpg"),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(20)),
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
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Text(
                document['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: true,
              pinned: false,
              snap: true,
              stretch: true,
              backgroundColor: Colors.black12,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
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
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fweather.jpg?alt=media&token=6a5fddd4-1dd7-4573-b122-1df595875061"),
                      CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fnews.jpg?alt=media&token=de9b5d02-8491-47d9-84d6-37d8c575de0e"),
                      CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Ffertilizer.jpg?alt=media&token=f796864d-225b-43a8-a4e8-dddf60133ebd"),
                      CachedNetworkImage(
                          imageUrl:
                              "https://firebasestorage.googleapis.com/v0/b/digital-krishi-9430b.appspot.com/o/slider_images%2Fmap.jpg?alt=media&token=a8f1e852-2c37-40a5-86bd-724c02b1708d"),
                    ]),
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.black12,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(width: .5, color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
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
                                FaIcon(
                                  FontAwesomeIcons.newspaper,
                                  color: Colors.green,
                                ),
                                Text(
                                  "Agriculture News",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
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
                                    child: ListNewsPortal(),
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
                      border: Border.all(width: .5, color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
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
                                FaIcon(
                                  FontAwesomeIcons.youtube,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Agriculture Videos",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AllCategoryVideos()));
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              );
                            return ListView.builder(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
