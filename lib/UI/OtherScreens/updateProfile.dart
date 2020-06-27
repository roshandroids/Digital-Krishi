import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:digitalKrishi/UI/PostScreens/postDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:timeago/timeago.dart' as timeago;

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final userTypeController = TextEditingController();
  final isVerifiedController = TextEditingController();

  String photoUrl;
  String userEmail;
  String userId;
  bool isLoading = false;
  File avatarImageFile;
  String imgUrl;
  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeContact = FocusNode();
  final FocusNode focusNodeAddress = FocusNode();
  final FocusNode focusNodeIsVerified = FocusNode();

  @override
  void initState() {
    super.initState();
    userData();
  }

  Future<String> userData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    this.setState(() {
      userId = user.uid;
      userEmail = user.email;
    });
    print(userId);
    return user.uid;
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  //delete previous pic
  Future deleteImage() async {
    await FirebaseStorage.instance
        .getReferenceFromUrl(photoUrl)
        .then((value) => value.delete())
        .catchError((onError) {
      print(onError);
    });
  }

  Future uploadFile() async {
    String fileName = basename(avatarImageFile.path);
    StorageReference reference =
        FirebaseStorage.instance.ref().child('user_profile').child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          deleteImage();
          photoUrl = downloadUrl;

          Firestore.instance.collection('users').document(userId).updateData({
            'fullName': fullNameController.text.trim(),
            'contact': contactController.text.trim(),
            'address': addressController.text.trim(),
            'photoUrl': photoUrl,
          }).then((data) async {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeFullName.unfocus();
    focusNodeEmail.unfocus();
    focusNodeContact.unfocus();
    focusNodeAddress.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document(userId).updateData({
      'fullName': fullNameController.text.trim(),
      'contact': contactController.text.trim(),
      'address': addressController.text.trim(),
      'photoUrl': photoUrl,
    }).then((data) async {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(
            msg: "Update success",
            textColor: Colors.red,
            backgroundColor: Colors.black);
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
        Fluttertoast.showToast(msg: err.toString());
      });
    });
  }

  Widget _buildProfileListItem(BuildContext context, snapshot) {
    fullNameController.text = snapshot.data.data['fullName'];

    emailController.text = snapshot.data.data['email'];
    contactController.text = snapshot.data.data['contact'];
    addressController.text = snapshot.data.data['address'];
    isVerifiedController.text = snapshot.data.data['isVerified'];
    userTypeController.text = snapshot.data.data['userType'];

    photoUrl = snapshot.data.data["photoUrl"];

    //for events
    Widget _buildListItemPosts(BuildContext context, DocumentSnapshot document,
        String collectionName) {
      Timestamp timestamp = document['PostedAt'];
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetails(
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
            margin: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    blurRadius: 20.0,
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: document['PostImage'],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitWave(
                          color: Colors.blue,
                          size: 60.0,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        document['PostTitle'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        timeago.format(timestamp.toDate()),
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                InkWell(
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
                        'lib/Assets/Images/delete.png',
                        height: 30,
                      )),
                ),
              ],
            ),
          ));
    }

    return Container(
      color: Colors.black12,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                bool connected = connectivity != ConnectivityResult.none;
                return connected
                    ? Container(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              (avatarImageFile == null)
                                  ? (photoUrl != ''
                                      ? Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xfff5a623)),
                                              ),
                                              width: 150.0,
                                              height: 150.0,
                                              padding: EdgeInsets.all(20.0),
                                            ),
                                            imageUrl: photoUrl,
                                            width: 150.0,
                                            height: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          clipBehavior: Clip.hardEdge,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 90.0,
                                          color: Colors.black38,
                                        ))
                                  : Material(
                                      child: Image.file(
                                        avatarImageFile,
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(45.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                              Positioned(
                                left: 45,
                                bottom: -10,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                  onPressed: getImage,
                                  highlightColor: Color(0xffaeaeae),
                                  iconSize: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                      )
                    : Container(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              (avatarImageFile == null)
                                  ? (photoUrl != ''
                                      ? Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xfff5a623)),
                                              ),
                                              width: 150.0,
                                              height: 150.0,
                                              padding: EdgeInsets.all(20.0),
                                            ),
                                            imageUrl: photoUrl,
                                            width: 150.0,
                                            height: 150.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          clipBehavior: Clip.hardEdge,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 90.0,
                                          color: Colors.black38,
                                        ))
                                  : Material(
                                      child: Image.file(
                                        avatarImageFile,
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(45.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                              Positioned(
                                left: 45,
                                bottom: -10,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please check Your Internet connection");
                                  },
                                  highlightColor: Color(0xffaeaeae),
                                  iconSize: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                      );
              },
              child: Container(),
            ),

            // Input
            Column(
              children: <Widget>[
                // full name

                Container(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Color(0xff203152)),
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 10.0),
                        ),
                        hintText: 'Full Name',
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff203152)),
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Color(0xffaeaeae)),
                      ),
                      controller: fullNameController,
                      style: TextStyle(),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),

                SizedBox(
                  height: 30,
                ),

                Tooltip(
                  waitDuration: Duration(seconds: 5),
                  message: "You cannot change your email",
                  child: Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Color(0xff203152)),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 10.0),
                          ),
                          hintText: 'Email',
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff203152)),
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Color(0xffaeaeae)),
                        ),
                        controller: emailController,
                        style: TextStyle(),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Color(0xff203152)),
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 10.0),
                        ),
                        hintText: 'Contact',
                        labelText: 'Contact',
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff203152)),
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Color(0xffaeaeae)),
                      ),
                      controller: contactController,
                      style: TextStyle(),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),

                SizedBox(
                  height: 30,
                ),

                Container(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Color(0xff203152)),
                    child: TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 2.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.red, width: 10.0),
                        ),
                        hintText: 'Address',
                        labelText: 'Address',
                        labelStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff203152)),
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: Color(0xffaeaeae)),
                      ),
                      controller: addressController,
                      style: TextStyle(),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),

                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Color(0xff203152)),
                    child: TextField(
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 10.0),
                          ),
                          enabled: false,
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Color(0xffaeaeae)),
                          labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff203152)),
                          labelText: 'Account Type'),
                      controller: userTypeController,
                      style: TextStyle(),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),

            SizedBox(
              height: 30,
            ),
            // Button
            OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                bool connected = connectivity != ConnectivityResult.none;
                return connected
                    ? InkWell(
                        onTap: handleUpdateData,
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff06beb6), Color(0xff48b1bf)]),
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Update".toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                    : Offline();
              },
              child: Container(),
            ),
            SizedBox(
              height: 30,
            ),

            StreamBuilder(
                stream: Firestore.instance
                    .collection('posts')
                    .where("PostedBy", isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LinearProgressIndicator(
                      backgroundColor: Colors.green,
                    );
                  } else {
                    if (snapshot.data.documents.length <= 0) {
                      return Container();
                    }
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10),
                          child: Text(
                            'My Posts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            // itemExtent: 200,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) =>
                                _buildListItemPosts(context,
                                    snapshot.data.documents[index], 'posts'),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xffff9966), Color(0xffff5e62)])),
          ),
          title: Text(
            'User Profile',
            style: TextStyle(
                color: Color(0xff203152), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    );
                  if (snapshot.data.data == null)
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    );
                  return _buildProfileListItem(context, snapshot);
                },
              ),
              Positioned(
                child: isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xfff5a623))),
                        ),
                        color: Colors.black.withOpacity(0.5),
                      )
                    : Container(),
              ),
            ],
          ),
        ));
  }
}
