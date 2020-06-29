import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/PostScreens/newPost.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/PostScreens/postDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Feeds extends StatefulWidget {
  Feeds({Key key}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  String userId;
  String loggedInUserType;
  bool liked = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        if (mounted) {
          setState(() {
            userId = firebaseUser.uid;
          });
        }
      }
    });
  }

  Widget _buildListItemPosts(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    String postedBy = document['PostedBy'];
    Timestamp timestamp = document['PostedAt'];

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
                  .document(postedBy)
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
                            bottom:
                                BorderSide(width: .2, color: Colors.blueGrey))),
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
                                placeholder: (context, url) => SpinKitWave(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data.data['fullName'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  (snapshot.data.data['userType'] == "Doctor")
                                      ? Icon(Icons.check_circle_outline,
                                          size: 15)
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              timeago.format(
                                timestamp.toDate(),
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ));
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              document['PostTitle'],
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
                  imageUrl: document['PostImage'],
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
                      postImage: document['PostImage'],
                      postTitle: document['PostTitle'],
                      postDescription: document['PostDescription'],
                      postedAt: document['PostedAt'],
                      postedBy: document['PostedBy'],
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
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                );
                              if (snapshot.data == null)
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                );

                              return Text(
                                snapshot.data.documents.length.toString() +
                                    " Likes",
                                style: TextStyle(),
                              );
                            }),
                        StreamBuilder(
                            stream: Firestore.instance
                                .collection('posts')
                                .document(document.documentID)
                                .collection('likes')
                                .document(userId)
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
                                              ? FontAwesomeIcons.solidThumbsUp
                                              : FontAwesomeIcons.thumbsUp,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                  onPressed: () {
                                    Firestore.instance
                                        .collection('posts')
                                        .document(document.documentID)
                                        .collection('likes')
                                        .document(userId)
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
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                );
                              if (snapshot.data == null)
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.grey[100],
                                  child: Container(
                                    height: 10,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                );
                              return Text(
                                snapshot.data.documents.length.toString() +
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
                                      postImage: document['PostImage'],
                                      postTitle: document['PostTitle'],
                                      postDescription:
                                          document['PostDescription'],
                                      postedAt: document['PostedAt'],
                                      postedBy: document['PostedBy'],
                                      id: document.documentID,
                                      collectionName: collectionName,
                                    )),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userId)
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
                        } else if (snapshot.data.data['userType'] == "Admin") {
                          return InkWell(
                            onTap: () async {
                              await FirebaseStorage.instance
                                  .getReferenceFromUrl(document['PostImage'])
                                  .then((value) => value.delete())
                                  .catchError((onError) {
                                print(onError);
                              });
                              await Firestore.instance
                                  .collection('posts')
                                  .document(document.documentID)
                                  .delete();

                              Fluttertoast.showToast(
                                  msg: "Deleted Successfully",
                                  toastLength: Toast.LENGTH_LONG,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                            },
                            child: Container(
                                margin: EdgeInsets.all(8),
                                child: Image.asset(
                                  'lib/Assets/delete.png',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 80.0,
              floating: true,
              pinned: false,
              snap: true,
              stretch: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: FlexibleSpaceBar(
                  centerTitle: true,
                  background: StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userId)
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
                        if (snapshot.data.data['userType'] == "Admin") {
                          return Container();
                        } else {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      alignment: Alignment.bottomLeft,
                                      duration: Duration(milliseconds: 250),
                                      child: NewPost()));
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.1, color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                    child: CachedNetworkImage(
                                      height: 70,
                                      width: 70,
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
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Hello, " +
                                                snapshot.data.data['fullName'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "Would you like to ask anything?",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance.collection('posts').snapshots(),
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
                        physics: BouncingScrollPhysics(),
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
      ),
    );
  }
}
