import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/fullPhoto.dart';
import 'package:flutter/material.dart';

class FarmerDetails extends StatefulWidget {
  final String profileImage;
  final String fullName;
  final String email;
  final String userId;
  final String contact;
  final String userType;
  final String address;
  final String id;
  final String collectionName;

  FarmerDetails(
      {Key key,
      this.profileImage,
      this.fullName,
      this.email,
      this.userId,
      this.contact,
      this.userType,
      this.address,
      this.collectionName,
      this.id})
      : super(key: key);

  @override
  _FarmerDetailsState createState() => _FarmerDetailsState();
}

class _FarmerDetailsState extends State<FarmerDetails> {
  final databaseReference = Firestore.instance;
  String userEmail;

  @override
  Widget build(BuildContext context) {
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
          "Farmer Details",
          style: TextStyle(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FullPhoto(url: widget.profileImage)));
                },
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.height,
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
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: widget.profileImage,
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
                            blurRadius: 20.0,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Details :".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Text(
                            "Full Name:- " + widget.fullName,
                            style: TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          Text(
                            "Email:- " + widget.email,
                            style: TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          Text(
                            "Contact:- " + widget.contact,
                            style: TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          Divider(),
                          Text(
                            "Address:- " + widget.address,
                            style: TextStyle(fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
