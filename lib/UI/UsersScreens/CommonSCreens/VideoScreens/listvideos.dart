import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VideoScreens/playVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class ListVideos extends StatefulWidget {
  final String category;
  final List videoUrl;
  final String userType;
  final String documentId;
  ListVideos(
      {@required this.videoUrl,
      @required this.category,
      @required this.userType,
      @required this.documentId});
  @override
  _ListVideosState createState() => _ListVideosState();
}

class _ListVideosState extends State<ListVideos> {
  String title;
  String thumbnail;

  Future<String> getVideo(String videoUrl) async {
    var jsonData = await getDetail(videoUrl);

    return jsonData['title'];
  }

  Future<dynamic> getDetail(String userUrl) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$userUrl&format=json";

    //store http request response to res variable
    var res = await http.get(embedUrl);

    try {
      if (res.statusCode == 200) {
        //return the json from the response

        return json.decode(res.body);
      } else {
        //return null if status code other than 200
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      //return null if error
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.category),
      ),
      body: Container(
        child: ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.videoUrl.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: PlayVideo(
                                url: widget.videoUrl[index],
                              )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 1.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                      future: getVideo(widget.videoUrl[index]),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: Colors.grey[100],
                                            child: Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                        return Text(
                                          snapshot.data,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        );
                                      }),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    Firestore.instance
                                        .collection('videos')
                                        .document(widget.documentId)
                                        .updateData({
                                      "videoUrl": FieldValue.arrayRemove(
                                          [widget.videoUrl[index]]),
                                    });
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                        msg: "Deleted Successfully",
                                        backgroundColor: Colors.white,
                                        textColor: Colors.green);
                                  })
                            ],
                          ),
                          Text(index.toString()),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => SpinKitWave(
                                      color: Colors.blue,
                                      size: 60.0,
                                    ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                imageUrl:
                                    "https://i3.ytimg.com/vi/${YoutubePlayer.convertUrlToId(widget.videoUrl[index])}/sddefault.jpg"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
