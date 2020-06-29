import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerificationRequest extends StatefulWidget {
  final String userType;
  VerificationRequest({@required this.userType});
  @override
  _VerificationRequestState createState() => _VerificationRequestState();
}

class _VerificationRequestState extends State<VerificationRequest> {
  Widget _buildListUser(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpertDetails(
                      viewBy: widget.userType,
                      profileImage: document['photoUrl'],
                      fullName: document['fullName'],
                      email: document['email'],
                      userId: document['id'],
                      contact: document['contact'],
                      userType: document['userType'],
                      verificationDocument: document['verificationDocument'],
                      address: document['address'],
                      isVerified: document["isVerified"],
                      id: document.documentID,
                      collectionName: collectionName,
                    )),
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 10),
          width: MediaQuery.of(context).size.width / 1.6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                new BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 10.0,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: CachedNetworkImage(
                    imageUrl: document['photoUrl'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      document['fullName'],
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      document['email'],
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.black),
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
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Text(
                "Pending verification Request of Experts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator(
                      backgroundColor: Colors.green,
                    );
                  } else {
                    var userPastEvents = [];
                    for (int i = 0; i < snapshot.data.documents.length; i++) {
                      if (snapshot.data.documents[i]["userType"] == "Expert") {
                        if (snapshot.data.documents[i]["isVerified"] ==
                            "Not Verified") {
                          userPastEvents.add(snapshot.data.documents[i]);
                        }
                      }
                    }
                    if (userPastEvents.length >= 1) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: userPastEvents.length,
                        itemBuilder: (context, index) => _buildListUser(
                            context, userPastEvents[index], 'users'),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitPouringHourglass(
                              size: 60,
                              color: Colors.green,
                            ),
                            Text(
                              "No verification Request yet",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ));
  }
}
