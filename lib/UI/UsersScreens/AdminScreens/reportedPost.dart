import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/PostScreens/postDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class ReportedPosts extends StatefulWidget {
  final String uId;
  ReportedPosts({@required this.uId});
  @override
  _ReportedPostsState createState() => _ReportedPostsState();
}

class _ReportedPostsState extends State<ReportedPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Reported Posts',
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection('reports').snapshots(),
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
                            Text("No Posts Available yet")
                          ],
                        ),
                      );
                    return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => _buildListItemPosts(
                          context, snapshot.data.documents[index], 'posts'),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItemPosts(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('posts')
            .document(document['postId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
              backgroundColor: Colors.green,
            );
          if (snapshot.data.data == null)
            return CircularProgressIndicator(
              backgroundColor: Colors.green,
            );
          return InkWell(
              child: Container(
            height: MediaQuery.of(context).size.height / 2,
            margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
            width: MediaQuery.of(context).size.width / 1.6,
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
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .document(snapshot.data.data['PostedBy'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return LinearProgressIndicator(
                          backgroundColor: Colors.green,
                        );
                      if (snapshot.data.data == null)
                        return CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        );
                      return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: .2, color: Colors.blueGrey))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    child: CachedNetworkImage(
                                      height: 60,
                                      width: 60,
                                      imageUrl: snapshot.data.data['photoUrl'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          SpinKitWave(
                                        color: Colors.blue,
                                        size: 60.0,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data.data['fullName'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        (snapshot.data.data['isVerified'] ==
                                                "Verified")
                                            ? Icon(Icons.verified_user,
                                                color: Colors.green, size: 15)
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data.data['PostTitle'],
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: .5, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data.data['PostImage'],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitWave(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: PostDetails(
                            postImage: snapshot.data.data['PostImage'],
                            postTitle: snapshot.data.data['PostTitle'],
                            postDescription:
                                snapshot.data.data['PostDescription'],
                            postedAt: snapshot.data.data['PostedAt'],
                            postedBy: snapshot.data.data['PostedBy'],
                            id: document.documentID,
                            collectionName: collectionName,
                          )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: Shimmer.fromColors(
                      baseColor: Colors.green,
                      highlightColor: Colors.black12,
                      child: Text(
                        "Read More..",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: .5,
                  color: Colors.blueGrey,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('posts')
                                      .document(document.documentID)
                                      .collection('likes')
                                      .where('like', isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
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
                                    if (snapshot.data == null)
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

                                    return Text(
                                      snapshot.data.documents.length
                                              .toString() +
                                          " Likes",
                                      style: TextStyle(),
                                    );
                                  }),
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('posts')
                                      .document(document.documentID)
                                      .collection('likes')
                                      .document(snapshot.data.data['PostedBy'])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.thumbsUp,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {});
                                    } else {
                                      return IconButton(
                                        icon: snapshot.data.data == null
                                            ? FaIcon(
                                                FontAwesomeIcons.thumbsUp,
                                                color: Colors.blue,
                                              )
                                            : FaIcon(
                                                snapshot.data["like"]
                                                    ? FontAwesomeIcons
                                                        .solidThumbsUp
                                                    : FontAwesomeIcons.thumbsUp,
                                                color: Colors.blue,
                                                size: 30,
                                              ),
                                        onPressed: () {
                                          Firestore.instance
                                              .collection('posts')
                                              .document(document.documentID)
                                              .collection('likes')
                                              .document(snapshot
                                                  .data.data['PostedBy'])
                                              .setData({
                                            "like": snapshot.data.data == null
                                                ? true
                                                : !snapshot.data["like"]
                                          });
                                        },
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('posts')
                                      .document(document.documentID)
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
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
                                    if (snapshot.data == null)
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
                                    return Text(
                                      snapshot.data.documents.length
                                              .toString() +
                                          " Comments",
                                      style: TextStyle(),
                                    );
                                  }),
                              IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.commentDots,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: PostDetails(
                                            postImage:
                                                snapshot.data.data['PostImage'],
                                            postTitle:
                                                snapshot.data.data['PostTitle'],
                                            postDescription: snapshot
                                                .data.data['PostDescription'],
                                            postedAt:
                                                snapshot.data.data['PostedAt'],
                                            postedBy:
                                                snapshot.data.data['PostedBy'],
                                            id: document.documentID,
                                            collectionName: collectionName,
                                          )),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(snapshot.data.data['PostedBy'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return LinearProgressIndicator(
                                  backgroundColor: Colors.green,
                                );
                              } else if (snapshot.data.data == null) {
                                return CircularProgressIndicator(
                                  backgroundColor: Colors.green,
                                );
                              } else if (snapshot.data.data['userType'] ==
                                  "Admin") {
                                return InkWell(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return OfflineBuilder(
                                            connectivityBuilder: (
                                              BuildContext context,
                                              ConnectivityResult connectivity,
                                              Widget child,
                                            ) {
                                              bool connected = connectivity !=
                                                  ConnectivityResult.none;
                                              return connected
                                                  ? Container(
                                                      color: Colors.black
                                                          .withOpacity(.1),
                                                      child: Wrap(
                                                        children: <Widget>[
                                                          ListTile(
                                                              leading: Icon(
                                                                Icons.warning,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              title: Text(
                                                                  'Remove This Post'),
                                                              onTap: () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .document(
                                                                        widget
                                                                            .uId)
                                                                    .collection(
                                                                        'savedPosts')
                                                                    .document(
                                                                        document[
                                                                            'postId'])
                                                                    .delete();

                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Removed Successfully",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    textColor:
                                                                        Colors
                                                                            .white);
                                                              }),
                                                          Divider(
                                                            color:
                                                                Colors.blueGrey,
                                                            thickness: 1,
                                                            indent: 20,
                                                            endIndent: 10,
                                                          ),
                                                          ListTile(
                                                            leading: Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            title:
                                                                Text('Cancel'),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 100,
                                                      child: Offline(),
                                                    );
                                            },
                                            child: Container(),
                                          );
                                        });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(8),
                                      child: Image.asset(
                                        'lib/Assets/Images/delete.png',
                                        height: 30,
                                      )),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
  }
}
