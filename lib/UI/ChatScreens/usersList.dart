import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/ChatScreens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool showExpert = true;
  bool isLoading = false;
  String currentUserId;
  String loggedInUserType;

  bool isoffline = false;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then(
      (firebaseUser) {
        if (firebaseUser != null) {
          setState(
            () {
              currentUserId = firebaseUser.uid;
            },
          );
          getUserType();
        }
      },
    );
  }

  void getUserType() async {
    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        loggedInUserType = ds.data['userType'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(.1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select User Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showExpert = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (!showExpert)
                                ? Colors.black12
                                : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          "All Experts",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color:
                                  (!showExpert) ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          showExpert = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: (!showExpert)
                                ? Colors.blueGrey
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: Text(
                          "All Farmers",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color:
                                  (!showExpert) ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 2,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: (showExpert)
                  ? Text(
                      "Showing Available Experts",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    )
                  : Text(
                      "Showing Available Farmers",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 2,
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  } else if (snapshot.data.documents.length <= 0) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (!showExpert) {
      if (document['id'] == currentUserId) {
        return Container();
      } else if (document['userType'] == "Admin") {
        return Container();
      } else if (document['userType'] == "Expert") {
        return Container();
      } else {
        if (document['userType'] == "Farmer") {
          return Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                peerId: document.documentID,
                                peerAvatar: document['photoUrl'],
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[500],
                  ),
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Material(
                            child: document['photoUrl'] != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                      width: 50.0,
                                      height: 50.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: document['photoUrl'],
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 70.0,
                                    color: Colors.grey,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Row(
                            children: [
                              Text(
                                document['userType'],
                                style: TextStyle(),
                              ),
                              (document['isVerified'] == 'Verified')
                                  ? Icon(
                                      Icons.check_circle_outline,
                                      size: 15,
                                      color: Colors.red,
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  document['fullName'] ?? 'Not available',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              ),
                              Container(
                                child: Text(
                                  document['email'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.blueGrey,
                height: 2,
                indent: 10,
                endIndent: 10,
              ),
            ],
          );
        } else {
          return Container();
        }
      }
    } else {
      if (document['id'] == currentUserId) {
        return Container();
      } else if (document['userType'] == "Admin") {
        return Container();
      } else if (document['userType'] == "Expert" &&
          document['isVerified'] == 'Not Verified') {
        return Container();
      } else {
        if (document['userType'] == "Expert" &&
            document['isVerified'] == "Verified") {
          return Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                peerId: document.documentID,
                                peerAvatar: document['photoUrl'],
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[500]),
                  padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                  margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Material(
                            child: document['photoUrl'] != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                      width: 50.0,
                                      height: 50.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: document['photoUrl'],
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 70.0,
                                    color: Colors.grey,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          Row(
                            children: [
                              Text(
                                document['userType'],
                                style: TextStyle(),
                              ),
                              (document['isVerified'] == 'Verified')
                                  ? Icon(
                                      Icons.check_circle_outline,
                                      size: 15,
                                      color: Colors.red,
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  document['fullName'] ?? 'Not available',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              ),
                              Container(
                                child: Text(
                                  document['email'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.blueGrey,
                height: 2,
                indent: 10,
                endIndent: 10,
              ),
            ],
          );
        } else {
          return Container();
        }
      }
    }
  }
}
