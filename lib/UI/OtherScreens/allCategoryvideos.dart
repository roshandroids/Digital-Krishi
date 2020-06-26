import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/listvideos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            MaterialPageRoute(
                builder: (context) => ListVideos(
                      category: document['title'],
                      videoUrl: document['videoUrl'],
                    )));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
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
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: Expanded(
          child: StreamBuilder(
              stream: Firestore.instance.collection('videos').snapshots(),
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
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "There are no videos uploaded yet",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  );
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildListvideos(
                      context, snapshot.data.documents[index], 'videos'),
                );
              }),
        ),
      ),
    );
  }
}
