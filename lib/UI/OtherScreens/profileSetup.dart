import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileSetup extends StatefulWidget {
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  TextEditingController fullNameController;
  TextEditingController emailController;
  TextEditingController contactController;
  TextEditingController addressController;
  TextEditingController userTypeController;
  TextEditingController isVerifiedController;

  String id = '';
  String fullName = '';
  String email = '';
  String contact = '';
  String address = '';
  String photoUrl = '';
  String isVerified = '';
  String userType = '';
  String userEmail;
  bool isLoading = false;
  File avatarImageFile;
  final picker = ImagePicker();

  String imgUrl;
  File _image;
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
    final String email = user.email.toString();
    this.setState(() {
      userEmail = email;
      id = user.uid;
    });

    return email;
  }

//for profile picture
  Future getImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        avatarImageFile = File(image.path);
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

          Firestore.instance.collection('users').document(id).updateData({
            'fullName': fullNameController.text.trim(),
            'email': emailController.text.trim(),
            'contact': contactController.text.trim(),
            'address': addressController.text.trim(),
            'photoUrl': photoUrl,
            'userType': userTypeController.text.trim(),
            'isVerified': isVerifiedController.text.trim()
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

  void handleUpdateData(context) {
    if (_image != null) {
      focusNodeFullName.unfocus();
      focusNodeEmail.unfocus();
      focusNodeContact.unfocus();
      focusNodeAddress.unfocus();

      setState(() {
        isLoading = true;
      });

      Firestore.instance.collection('users').document(id).updateData({
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
        'contact': contactController.text.trim(),
        'address': addressController.text.trim(),
        'photoUrl': photoUrl,
        'userType': userTypeController.text.trim(),
        'isVerified': isVerifiedController.text.trim(),
        'isFirstTime': 'no',
      }).then((data) async {
        setState(() {
          isLoading = false;
          Fluttertoast.showToast(
              msg: "Update success",
              textColor: Colors.red,
              backgroundColor: Colors.black);
        });
        Navigator.of(context).pushReplacementNamed('/PendingVerification');
      }).catchError((err) {
        setState(() {
          isLoading = false;
          Fluttertoast.showToast(msg: err.toString());
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Please Choose the verification document');
    }
  }

  Future deleteDocument() async {
    await FirebaseStorage.instance
        .getReferenceFromUrl(imgUrl)
        .then((value) => value.delete())
        .catchError((onError) {
      print(onError);
    });
  }

//for verification document
  Future getDocumentImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        isLoading = true;
      });
    }
    uploadDocument();
  }

  Future uploadDocument() async {
    String fileName = basename(_image.path);
    StorageReference reference = FirebaseStorage.instance
        .ref()
        .child('verification_document')
        .child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          deleteDocument();
          imgUrl = downloadUrl;

          Firestore.instance.collection('users').document(id).updateData({
            'fullName': fullNameController.text.trim(),
            'email': emailController.text.trim(),
            'contact': contactController.text.trim(),
            'address': addressController.text.trim(),
            'photoUrl': photoUrl,
            'userType': userTypeController.text.trim(),
            'isVerified': isVerifiedController.text.trim(),
            'verificationDocument': imgUrl
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

  @override
  Widget build(BuildContext context) {
    Widget _buildProfileListItem(BuildContext context, snapshot) {
      fullNameController =
          TextEditingController(text: snapshot.data.data['fullName']);
      emailController =
          TextEditingController(text: snapshot.data.data['email']);
      contactController =
          TextEditingController(text: snapshot.data.data['contact']);
      addressController =
          TextEditingController(text: snapshot.data.data['address']);
      isVerifiedController =
          TextEditingController(text: snapshot.data.data['isVerified']);
      userTypeController =
          TextEditingController(text: snapshot.data.data['userType']);

      photoUrl = snapshot.data.data["photoUrl"];

      return Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Avatar
                Container(
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        (avatarImageFile == null)
                            ? (photoUrl != ''
                                ? Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45.0)),
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
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(20.0),
                ),

                // Input
                Column(
                  children: <Widget>[
                    // full name
                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff203152)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff203152)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 10.0),
                            ),
                            hintText: 'Full Name',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Color(0xffaeaeae)),
                          ),
                          controller: fullNameController,
                          onChanged: (value) {
                            fullName = value;
                          },
                          focusNode: focusNodeFullName,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Email

                    Tooltip(
                      waitDuration: Duration(seconds: 5),
                      message: "You cannot change your email",
                      child: Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: Color(0xff203152)),
                          child: TextFormField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "E-mail",
                              labelStyle: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff203152)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 10.0),
                              ),
                              hintText: 'Email',
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: Color(0xffaeaeae)),
                            ),
                            controller: emailController,
                            onChanged: (value) {
                              email = value;
                            },
                            focusNode: focusNodeEmail,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Contact

                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff203152)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Contact",
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff203152)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 10.0),
                            ),
                            hintText: 'Contact',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Color(0xffaeaeae)),
                          ),
                          controller: contactController,
                          onChanged: (value) {
                            contact = value;
                          },
                          focusNode: focusNodeContact,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //address

                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff203152)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Address",
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff203152)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 10.0),
                            ),
                            hintText: 'Address',
                            contentPadding: EdgeInsets.all(5.0),
                            hintStyle: TextStyle(color: Color(0xffaeaeae)),
                          ),
                          controller: addressController,
                          onChanged: (value) {
                            address = value;
                          },
                          focusNode: focusNodeAddress,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff203152)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "User Type",
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff203152)),
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
                          ),
                          controller: userTypeController,
                          onChanged: (value) {
                            userType = value;
                          },
                          // focusNode: focusNodeAddress,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: Color(0xff203152)),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Is Verified",
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff203152)),
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
                          ),
                          controller: isVerifiedController,
                          onChanged: (value) {
                            isVerified = value;
                          },
                          // focusNode: focusNodeAddress,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: getDocumentImage,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Choose or take a picture"),
                                ),
                              ),
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),

                // Button
                InkWell(
                  onTap: () => handleUpdateData(context),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text("Request Account Verification".toUpperCase()),
                  ),
                ),
              ],
            ),
          ),

          // Loading
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
                  ),
                  color: Colors.black.withOpacity(0.5),
                )
              : Container(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          'Profile Setup',
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        new BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Text(
                      "You have created your account as Farming Expert, Now you have to update your profile along with verification document which will then be verified by our admin.",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator(
                            backgroundColor: Colors.green,
                          );
                        return _buildProfileListItem(context, snapshot);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
