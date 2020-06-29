import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertDetails.dart';
import 'package:digitalKrishi/UI/UsersScreens/FarmerScreens/farmerDetails.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UsersList extends StatefulWidget {
  final String userType;
  UsersList({@required this.userType});
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool showExpert = true;

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (showExpert) {
      if (document['userType'] == "Expert") {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ExpertDetails(
                  viewBy: widget.userType,
                  address: document['address'],
                  collectionName: 'users',
                  email: document['email'],
                  fullName: document['fullName'],
                  userId: document['id'],
                  contact: document['contact'],
                  profileImage: document['photoUrl'],
                  id: document.documentID,
                  userType: document['userType'],
                  isVerified: document['isVerified'],
                  verificationDocument: document['verificationDocument'],
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: (document['isVerified'] == "Verified")
                  ? Color.fromARGB(0xff, 221, 235, 230)
                  : Color.fromARGB(0xff, 255, 153, 153),
            ),
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Row(
                      children: [
                        Text(
                          document['userType'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        (document['isVerified'] == "Verified")
                            ? Icon(
                                Icons.check_circle_outline,
                                size: 15,
                                color: Colors.green,
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
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    } else {
      if (document['userType'] == "Farmer") {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: FarmerDetails(
                    address: document['address'],
                    collectionName: 'users',
                    email: document['email'],
                    fullName: document['fullName'],
                    userId: document['id'],
                    contact: document['contact'],
                    profileImage: document['photoUrl'],
                    id: document.documentID,
                    userType: document['userType'],
                  )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.circular(5),
              color: Color.fromARGB(0xff, 221, 235, 230),
            ),
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    Row(
                      children: [
                        Text(
                          document['userType'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
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
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
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
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: (showExpert)
                ? Text(
                    "Showing Experts",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  )
                : Text(
                    "Showing Farmers",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
          ),
          Divider(
            color: Colors.blueGrey,
            height: 2,
            indent: 10,
            endIndent: 10,
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
                          color: (!showExpert) ? Colors.black12 : Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(
                        "Experts",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: (!showExpert) ? Colors.black : Colors.white),
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
                          color: (!showExpert) ? Colors.green : Colors.black12,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: Text(
                        "Farmers",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: (!showExpert) ? Colors.white : Colors.black),
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
                    physics: BouncingScrollPhysics(),
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
    );
  }
}
