import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  UserProfileScreen({@required this.userId});
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String photoUrl;
  File avatarImageFile;
  final nameController = TextEditingController();

  Widget _buildProfileCard(BuildContext context, snapshot) {
    photoUrl = snapshot.data.data['photoUrl'];
    return Container(
      child: (snapshot.data.data['photoUrl'] != null)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: snapshot.data.data['photoUrl'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
          : Container(
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  strokeWidth: 2,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                floating: true,
                pinned: true,
                snap: true,
                stretch: true,
                backgroundColor: Colors.black12,
                flexibleSpace: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black12,
                        ),
                      );
                    if (snapshot.data.data == null)
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black12,
                        ),
                      );
                    return _buildProfileCard(context, snapshot);
                  },
                ),
              ),
            ];
          },
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(),
          ),
        ),
      ),
    );
  }
}
