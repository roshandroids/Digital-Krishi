import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digitalKrishi/UI/OtherScreens/playVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class ListVideos extends StatefulWidget {
  final String category;
  final List videoUrl;
  ListVideos({this.videoUrl, this.category});
  @override
  _ListVideosState createState() => _ListVideosState();
}

class _ListVideosState extends State<ListVideos> {
  String title;
  String thumbnail;
  YoutubePlayerController _controller;
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
        margin: EdgeInsets.all(10),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlayVideo(
                                url: widget.videoUrl[index],
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: .5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                  return Text(
                                    snapshot.data,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  );
                                }),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
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
