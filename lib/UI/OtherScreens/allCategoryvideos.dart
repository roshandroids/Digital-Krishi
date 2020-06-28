import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/listvideos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AllCategoryVideos extends StatefulWidget {
  @override
  _AllCategoryVideosState createState() => _AllCategoryVideosState();
}

class _AllCategoryVideosState extends State<AllCategoryVideos> {
  Widget _buildListvideos(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ListVideos(
                  category: document['title'],
                  videoUrl: document['videoUrl'],
                )));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 0,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Shimmer.fromColors(
                    baseColor: Colors.black,
                    highlightColor: Colors.black12,
                    child: Text(
                      document['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                )),
            Container(
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("All Videos"),
          leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
              Color(0xff1D976C),
              Color(0xff11998e),
              Color(0xff1D976C),
            ])),
          ),
        ),
        body: Container(
          child: StreamBuilder(
              stream: Firestore.instance.collection('videos').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LinearProgressIndicator(
                    backgroundColor: Colors.green,
                  );
                if (snapshot.data.documents.length <= 0)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitThreeBounce(
                          color: Colors.green,
                          size: 30.0,
                        ),
                        Text("No Videos Available yet")
                      ],
                    ),
                  );
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildListvideos(
                      context, snapshot.data.documents[index], 'videos'),
                );
              }),
        ));
  }
}
