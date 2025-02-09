import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetails extends StatefulWidget {
  final String postImage;
  final String postTitle;
  final String postDescription;
  final Timestamp postedAt;

  final String postedBy;
  final String id;
  final String collectionName;

  PostDetails(
      {Key key,
      this.postImage,
      this.postTitle,
      this.postDescription,
      this.postedAt,
      this.postedBy,
      this.collectionName,
      this.id})
      : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final commentController = TextEditingController();
  final databaseReference = Firestore.instance;

  String uId;
  String userName;
  String image;
  bool isPosting = false;

  String loggedInUserType;

  @override
  void initState() {
    super.initState();
    userData();
  }

  Future<String> userData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    this.setState(() {
      uId = user.uid;
    });
    getUserType();

    return uId;
  }

  void getUserType() async {
    await Firestore.instance
        .collection('users')
        .document(uId)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        userName = ds.data['fullName'];
        loggedInUserType = ds.data['userType'];
        image = ds.data['photoUrl'];
      });
    });
  }

  void fullImage() {
    showModalBottomSheet(
        enableDrag: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PhotoView(
                imageProvider: NetworkImage(widget.postImage),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    String postId = widget.id;

    void postComment() async {
      if (commentController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Write Something", backgroundColor: Colors.red);
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.of(context).pop();
      } else {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          isPosting = true;
        });

        String commentId = Firestore.instance
            .collection("posts")
            .document(postId)
            .collection("comments")
            .document()
            .documentID;

        await Firestore.instance
            .collection("posts")
            .document(postId)
            .collection("comments")
            .document(commentId)
            .setData({
          "commentedBy": userName,
          "comment": commentController.text,
          "image": image,
          "userType": loggedInUserType,
          "time": DateTime.now(),
          "commentId": commentId
        });
        commentController.clear();
        setState(() {
          isPosting = false;
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Posted Successfully", backgroundColor: Colors.green);
        });
      }
    }

    void showCommentInput() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                bool connected = connectivity != ConnectivityResult.none;
                return connected
                    ? Container(
                        height: 100,
                        color: Colors.black12,
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: (!isPosting)
                            ? TextFormField(
                                decoration: InputDecoration(
                                    filled: true,
                                    hintText: "Write Something..."),
                                controller: commentController,
                                textInputAction: TextInputAction.send,
                                onEditingComplete: () => postComment(),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SpinKitWanderingCubes(
                                    color: Colors.blue,
                                    size: 50.0,
                                  ),
                                  Text("Posting")
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
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        centerTitle: true,
        title: Text(
          "Post Details",
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      new BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StreamBuilder(
                          stream: Firestore.instance
                              .collection('users')
                              .document(widget.postedBy)
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          imageUrl:
                                              snapshot.data.data['photoUrl'],
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
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data.data['fullName'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                (snapshot.data.data[
                                                            'isVerified'] ==
                                                        "Verified")
                                                    ? Icon(Icons.verified_user,
                                                        color: Colors.green,
                                                        size: 15)
                                                    : Container(),
                                              ],
                                            ),
                                            Text(timeago.format(
                                                widget.postedAt.toDate())),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: (loggedInUserType == "Admin")
                                          ? Container()
                                          : IconButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext bc) {
                                                      return Container(
                                                        height: 150,
                                                        color: Colors.black
                                                            .withOpacity(.1),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  StreamBuilder(
                                                                stream: Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "users")
                                                                    .document(
                                                                        uId)
                                                                    .collection(
                                                                        "savedPosts")
                                                                    .document(
                                                                        postId)
                                                                    .snapshots(),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return ListTile(
                                                                      leading:
                                                                          Shimmer
                                                                              .fromColors(
                                                                        baseColor:
                                                                            Colors.black,
                                                                        highlightColor:
                                                                            Colors.black12,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.black12,
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              50,
                                                                        ),
                                                                      ),
                                                                      title: Shimmer
                                                                          .fromColors(
                                                                        baseColor:
                                                                            Colors.black,
                                                                        highlightColor:
                                                                            Colors.black12,
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              Colors.black12,
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              50,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    return ListTile(
                                                                      leading: (snapshot.data.data ==
                                                                              null)
                                                                          ? Icon(
                                                                              Icons.bookmark_border,
                                                                              color: Colors.green,
                                                                            )
                                                                          : Icon(
                                                                              Icons.bookmark,
                                                                              color: Colors.green,
                                                                            ),
                                                                      title: Text((snapshot.data.data ==
                                                                              null)
                                                                          ? "Save This Post"
                                                                          : "Already Saved"),
                                                                      onTap:
                                                                          () async {
                                                                        if (snapshot.data.data ==
                                                                            null) {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: (snapshot.data.data == null) ? "Saved Successfully" : "Already Saved");
                                                                          await Firestore
                                                                              .instance
                                                                              .collection(
                                                                                  'users')
                                                                              .document(
                                                                                  uId)
                                                                              .collection(
                                                                                  'savedPosts')
                                                                              .document(
                                                                                  postId)
                                                                              .setData({
                                                                            "postId":
                                                                                postId,
                                                                            "postedBy":
                                                                                widget.postedBy
                                                                          });
                                                                        } else {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Fluttertoast.showToast(
                                                                              msg: (snapshot.data.data == null) ? "Saved Successfully" : "Already Saved");
                                                                        }
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            Divider(
                                                              color: Colors
                                                                  .blueGrey,
                                                              indent: 5,
                                                              endIndent: 5,
                                                              thickness: 1,
                                                            ),
                                                            Expanded(
                                                              child: (widget
                                                                          .postedBy !=
                                                                      uId)
                                                                  ? StreamBuilder(
                                                                      stream: Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "reportedPosts")
                                                                          .document(widget
                                                                              .id)
                                                                          .collection(
                                                                              "reportedBy")
                                                                          .snapshots(),
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return ListTile(
                                                                            leading:
                                                                                Shimmer.fromColors(
                                                                              baseColor: Colors.black,
                                                                              highlightColor: Colors.black12,
                                                                              child: Container(
                                                                                color: Colors.black12,
                                                                                height: 20,
                                                                                width: 50,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Shimmer.fromColors(
                                                                              baseColor: Colors.black,
                                                                              highlightColor: Colors.black12,
                                                                              child: Container(
                                                                                color: Colors.black12,
                                                                                height: 20,
                                                                                width: 50,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else if (snapshot.data ==
                                                                            null) {
                                                                          return ListTile(
                                                                            leading:
                                                                                Shimmer.fromColors(
                                                                              baseColor: Colors.black,
                                                                              highlightColor: Colors.black12,
                                                                              child: Container(
                                                                                color: Colors.black12,
                                                                                height: 20,
                                                                                width: 50,
                                                                              ),
                                                                            ),
                                                                            title:
                                                                                Shimmer.fromColors(
                                                                              baseColor: Colors.black,
                                                                              highlightColor: Colors.black12,
                                                                              child: Container(
                                                                                color: Colors.black12,
                                                                                height: 20,
                                                                                width: 50,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          if (snapshot.data.documents.length !=
                                                                              0) {
                                                                            for (int i = 0;
                                                                                i < snapshot.data.documents.length;
                                                                                i++) {
                                                                              if (snapshot.data.documents[i]['reportedBy'] == uId && snapshot.data.documents[i]['postId'] == postId) {
                                                                                return ListTile(
                                                                                  leading: Icon(
                                                                                    Icons.check,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                  title: Text("Already Reported"),
                                                                                  onTap: () {
                                                                                    Fluttertoast.showToast(msg: "Already Reported");
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                return ListTile(
                                                                                  leading: Icon(
                                                                                    Icons.report,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                  title: Text("Report This Post"),
                                                                                  onTap: () async {
                                                                                    Navigator.of(context).pop();
                                                                                    Fluttertoast.showToast(msg: "Successfully Reported");
                                                                                    await Firestore.instance.collection('reportedPosts').document(widget.id).collection("reportedBy").document(uId).setData({
                                                                                      "postId": postId,
                                                                                      "reportedBy": uId,
                                                                                    });
                                                                                    await Firestore.instance.collection('reportedPosts').document(widget.id).setData({
                                                                                      "postId": postId,
                                                                                    });
                                                                                  },
                                                                                );
                                                                              }
                                                                            }
                                                                          } else {
                                                                            return ListTile(
                                                                              leading: Icon(
                                                                                Icons.report,
                                                                                color: Colors.red,
                                                                              ),
                                                                              title: Text("Report This Post"),
                                                                              onTap: () async {
                                                                                Navigator.of(context).pop();
                                                                                Fluttertoast.showToast(msg: "Successfully Reported");
                                                                                await Firestore.instance.collection('reportedPosts').document(widget.id).collection("reportedBy").document(uId).setData({
                                                                                  "postId": postId,
                                                                                  "reportedBy": uId,
                                                                                });
                                                                                await Firestore.instance.collection('reportedPosts').document(widget.id).setData({
                                                                                  "postId": postId,
                                                                                });
                                                                              },
                                                                            );
                                                                          }

                                                                          return Container();
                                                                        }
                                                                      },
                                                                    )
                                                                  : ListTile(
                                                                      leading:
                                                                          Icon(
                                                                        Icons
                                                                            .do_not_disturb,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      title: Text(
                                                                          "You can't report this post"),
                                                                      subtitle:
                                                                          Text(
                                                                              "This is your post, and you can't report your own post"),
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    });
                                              }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Divider(
                        endIndent: 2,
                        indent: 2,
                        color: Colors.black,
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.postTitle,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Divider(
                        endIndent: 2,
                        indent: 2,
                        color: Colors.black,
                        thickness: .5,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 2, right: 2),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.white),
                            child: CachedNetworkImage(
                              imageUrl: widget.postImage,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SpinKitWave(
                                color: Colors.blue,
                                size: 60.0,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                                icon: Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () => fullImage()),
                          )
                        ],
                      ),
                      Divider(
                        endIndent: 2,
                        indent: 2,
                        color: Colors.black,
                        thickness: .5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.postDescription,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          blurRadius: 20.0,
                        ),
                      ]),
                  child: Column(
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.black12,
                        child: Text(
                          "Comment Section",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => showCommentInput(),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(width: .5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.white, blurRadius: 10),
                                ]),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.only(left: 5),
                            child: Text("Write Something..")),
                      ),
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('posts')
                            .document(postId)
                            .collection('comments')
                            .orderBy("time", descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return LinearProgressIndicator(
                              backgroundColor: Colors.green,
                            );
                          } else if (snapshot.data == null) {
                            return Container(
                              height: 100,
                              child: Column(
                                children: <Widget>[
                                  SpinKitPulse(
                                    color: Colors.blue,
                                    size: 30.0,
                                  ),
                                  Text("No Comments Yet."),
                                ],
                              ),
                            );
                          } else {
                            List<Comment> comments = [];
                            snapshot.data.documents.forEach((doc) {
                              comments.add(Comment.fromDocument(doc));
                            });
                            return Column(
                              children: comments,
                            );
                          }
                        },
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

class Comment extends StatelessWidget {
  final String userName;
  final String usertype;
  final String image;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.userName, this.usertype, this.image, this.comment, this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userName: doc['commentedBy'],
      usertype: doc['userType'],
      image: doc['image'],
      comment: doc['comment'],
      timestamp: doc['time'],
    );
  }

  @override
  Widget build(BuildContext context) {
    String s = userName;
    var pos = s.lastIndexOf(' ');
    String result = (pos != -1) ? s.substring(0, pos) : s;

    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              children: <Widget>[
                Flexible(
                  child: (userName == null)
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.grey[200],
                          child: Container(
                            height: 10,
                            width: 70,
                          ))
                      : Text(
                          result,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                ),
                Flexible(
                  child: (usertype == "Expert")
                      ? Icon(
                          Icons.verified_user,
                          color: Colors.green,
                          size: 15,
                        )
                      : (usertype == "Admin")
                          ? Icon(
                              Icons.verified_user,
                              color: Colors.green,
                              size: 15,
                            )
                          : Container(),
                ),
              ],
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                image,
              ),
            ),
            subtitle: Text(
              comment,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              timeago.format(timestamp.toDate()),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
