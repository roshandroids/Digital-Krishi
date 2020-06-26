import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetails extends StatefulWidget {
  final String postImage;
  final String postTitle;
  final String postDescription;
  final Timestamp postedAt;
  final bool isOffline;
  final String postedBy;
  final String id;
  final String collectionName;

  PostDetails(
      {Key key,
      this.isOffline,
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

  void showSheet() {
    showModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Full photo",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PhotoView(
                      tightMode: true,
                      imageProvider: NetworkImage(widget.postImage),
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    String id1 = widget.id;

    void postComment() async {
      if (commentController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Write Something", backgroundColor: Colors.red);
      } else {
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
        });

        await Firestore.instance
            .collection("posts")
            .document(id1)
            .collection("comments")
            .add({
          "commentedBy": userName,
          "comment": commentController.text,
          "image": image,
          "userType": loggedInUserType,
          "time": DateTime.now(),
        });
        setState(() {
          commentController.clear();
          Fluttertoast.showToast(
              msg: "Posted Successfully", backgroundColor: Colors.green);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xffff9966), Color(0xffff5e62)])),
        ),
        centerTitle: true,
        title: Text(
          "Post Details",
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
            child: Column(
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

                  if (snapshot.data.data['userType'] == "Admin") {
                    return Container(
                      margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xffffCC95C0),
                            Color(0xfffffDBD4B4),
                            Color(0xfffff7AA1D2)
                          ],
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: .5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Admin",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(Icons.check_circle_outline, size: 15)
                              ],
                            ),
                            Text(timeago.format(widget.postedAt.toDate())),
                          ],
                        ),
                      ),
                    );
                  } else
                    return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: .5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    imageUrl: snapshot.data.data['photoUrl'],
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
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
                                      (snapshot.data.data['userType'] ==
                                              "Doctor")
                                          ? Icon(Icons.check_circle_outline,
                                              size: 15)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(timeago.format(widget.postedAt.toDate())),
                          ],
                        ));
                }),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, left: 12, right: 12),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.postTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            InkWell(
              onTap: () {
                showSheet();
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      new BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 20.0,
                      ),
                    ]),
                margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: widget.postImage,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                          blurRadius: 10.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.postDescription,
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.08),
                          blurRadius: 20.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Comment Section',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          // height: MediaQuery.of(context).size.height / 3,
                          child: StreamBuilder(
                              stream: Firestore.instance
                                  .collection('posts')
                                  .document(id1)
                                  .collection('comments')
                                  .orderBy("time", descending: false)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    child: Center(
                                      child: Column(
                                        children: <Widget>[
                                          CircularProgressIndicator(
                                            backgroundColor: Colors.green,
                                          ),
                                          Text(
                                            "No comments",
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                List<Comment> comments = [];
                                snapshot.data.documents.forEach((doc) {
                                  comments.add(Comment.fromDocument(doc));
                                });
                                if (snapshot.data != null) {
                                  return Column(
                                    children: comments,
                                  );
                                } else {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        "No comments",
                                        style: TextStyle(),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                        OfflineBuilder(
                          connectivityBuilder: (
                            BuildContext context,
                            ConnectivityResult connectivity,
                            Widget child,
                          ) {
                            bool connected =
                                connectivity != ConnectivityResult.none;
                            return connected
                                ? Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.7,
                                            child: TextFormField(
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: commentController,
                                              cursorColor: Colors.black,
                                              decoration: new InputDecoration(
                                                hintText: "Your Comment...",
                                                hintStyle: TextStyle(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: FaIcon(
                                              FontAwesomeIcons.paperPlane),
                                          onPressed: () {
                                            if (commentController.text !=
                                                null) {
                                              postComment();
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Write Something");
                                            }
                                          },
                                          color: Colors.blue[800],
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          splashColor: Colors.grey,
                                        )
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(width: 2),
                                        ),
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                                'lib/Assets/offline.gif'),
                                            Text(
                                              "OOPS, Looks Like your Internet is not working!",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                          },
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
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

    return Column(
      children: <Widget>[
        ListTile(
          title: Row(
            children: <Widget>[
              Flexible(
                child: (userName == null)
                    ? CircularProgressIndicator()
                    : Text(
                        result,
                        style: TextStyle(),
                      ),
              ),
              Flexible(
                child: (usertype == "Doctor")
                    ? Icon(
                        Icons.check_circle_outline,
                        size: 15,
                      )
                    : (usertype == "Admin")
                        ? Icon(
                            Icons.check_circle_outline,
                            size: 15,
                          )
                        : Container(),
              ),
            ],
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(image),
          ),
          subtitle: Text(
            comment,
            style: TextStyle(),
          ),
          trailing: Text(
            timeago.format(timestamp.toDate()),
            style: TextStyle(),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.black,
        ),
      ],
    );
  }
}
