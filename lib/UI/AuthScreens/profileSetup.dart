import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/AuthScreens/splashScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/FarmerScreens/farmerMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';

class ProfileSetup extends StatefulWidget {
  final String userId;
  final String userType;
  final String imageUrl;

  ProfileSetup(
      {@required this.userId,
      @required this.userType,
      @required this.imageUrl});
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  TextEditingController fullNameController;
  TextEditingController emailController;
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController userTypeController;
  TextEditingController isVerifiedController;

  String fullName = '';
  String email = '';
  String contact = '';
  String address = '';
  String photoUrl = '';
  String isVerified = '';
  String userType = '';
  String docUrl;
  bool isLoading = false;
  bool isUploadingProfile = false;
  bool isUploadingDocument = false;
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
  }

//for profile picture
  Future getImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image != null) {
      if (mounted)
        setState(() {
          avatarImageFile = File(image.path);
          isUploadingProfile = true;
        });
    }
    uploadProfilePicture();
  }

  Future takePicture() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera);
    if (image != null) {
      if (mounted)
        setState(() {
          avatarImageFile = File(image.path);
          isUploadingProfile = true;
        });
    }
    uploadProfilePicture();
  }

  void chosePicture(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.camera),
                    title: Text('Take Picture'),
                    onTap: () {
                      takePicture();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.images),
                  title: Text('Choose Picture'),
                  onTap: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  //delete previous profile picture
  Future deleteImage() async {
    await FirebaseStorage.instance
        .getReferenceFromUrl(photoUrl)
        .then((value) => value.delete())
        .catchError((onError) {
      print(onError);
    });
  }

//upload profile picture
  Future uploadProfilePicture() async {
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

          Firestore.instance
              .collection('users')
              .document(widget.userId)
              .updateData({
            'photoUrl': photoUrl,
          }).then((data) async {
            if (mounted)
              setState(() {
                isUploadingProfile = false;
              });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            if (mounted)
              setState(() {
                isUploadingProfile = false;
              });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          if (mounted)
            setState(() {
              isUploadingProfile = false;
            });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        if (mounted)
          setState(() {
            isUploadingProfile = false;
          });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      if (mounted)
        setState(() {
          isUploadingProfile = false;
        });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

//delete verification document picture
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
      if (mounted)
        setState(() {
          _image = File(image.path);
          isUploadingDocument = true;
        });
    }
    uploadDocument();
  }

//upload verification document
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

          Firestore.instance
              .collection('users')
              .document(widget.userId)
              .updateData({'verificationDocument': imgUrl}).then((data) async {
            if (mounted)
              setState(() {
                isUploadingDocument = false;
              });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            if (mounted)
              setState(() {
                isUploadingDocument = false;
              });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          if (mounted)
            setState(() {
              isUploadingDocument = false;
            });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        if (mounted)
          setState(() {
            isUploadingDocument = false;
          });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      if (mounted)
        setState(() {
          isUploadingDocument = false;
        });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  //update the profile name, address, contact for user
  void handleUpdateDataUser(context) {
    if (fullNameController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      focusNodeFullName.unfocus();
      focusNodeEmail.unfocus();
      focusNodeContact.unfocus();
      focusNodeAddress.unfocus();

      if (mounted)
        setState(() {
          isLoading = true;
        });

      Firestore.instance
          .collection('users')
          .document(widget.userId)
          .updateData({
        'fullName': fullNameController.text.trim(),
        'contact': contactController.text.trim(),
        'address': addressController.text.trim(),
        'photoUrl': photoUrl,
        'isVerified': isVerifiedController.text.trim(),
        'isFirstTime': 'no',
      }).then((data) async {
        if (mounted)
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(
                msg: "Update success",
                textColor: Colors.red,
                backgroundColor: Colors.black);
          });
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 300),
            child: FarmerMainScreen(
              userId: widget.userId,
              userType: widget.userType,
            ),
          ),
        );
      }).catchError((err) {
        if (mounted)
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: err.toString());
          });
      });
    } else {
      Fluttertoast.showToast(msg: 'Please Enter all details');
    }
  }

  //update the profile name, address, contact for expert
  void handleUpdateDataExpert(context) {
    if ((_image != null || docUrl != null) &&
        fullNameController.text.isNotEmpty &&
        contactController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      focusNodeFullName.unfocus();
      focusNodeEmail.unfocus();
      focusNodeContact.unfocus();
      focusNodeAddress.unfocus();

      if (mounted)
        setState(() {
          isLoading = true;
        });

      Firestore.instance
          .collection('users')
          .document(widget.userId)
          .updateData({
        'fullName': fullNameController.text.trim(),
        'contact': contactController.text.trim(),
        'address': addressController.text.trim(),
        'photoUrl': photoUrl,
        'isVerified': isVerifiedController.text.trim(),
        'isFirstTime': 'no',
      }).then((data) async {
        if (mounted)
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(
                msg: "Update success",
                textColor: Colors.red,
                backgroundColor: Colors.black);
          });
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 300),
            child: ExpertMainScreen(
              userType: widget.userType,
              usrId: widget.userId,
              url: photoUrl,
            ),
          ),
        );
      }).catchError((err) {
        if (mounted)
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: err.toString());
          });
      });
    } else {
      Fluttertoast.showToast(msg: 'Please Enter all details');
    }
  }

  void logOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 300),
        child: SplashScreen(),
      ),
    );
  }

  void logoutAlert(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.signOutAlt),
                    title: Text('Yes, log Out'),
                    onTap: () {
                      logOut(context);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.ban),
                  title: Text('No, Stay logged In'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildProfileListItem(BuildContext context, snapshot) {
      fullNameController =
          TextEditingController(text: snapshot.data.data['fullName']);
      emailController =
          TextEditingController(text: snapshot.data.data['email']);

      isVerifiedController =
          TextEditingController(text: snapshot.data.data['isVerified']);
      userTypeController =
          TextEditingController(text: snapshot.data.data['userType']);

      photoUrl = snapshot.data.data["photoUrl"];
      docUrl = snapshot.data.data['verificationDocument'];

      return Column(
        children: <Widget>[
          // Avatar
          Stack(
            children: <Widget>[
              (!isUploadingProfile)
                  ? Container(
                      width: 150,
                      height: 150,
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            (avatarImageFile == null)
                                ? (photoUrl != ''
                                    ? Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              SpinKitWave(
                                            color: Colors.blue,
                                            size: 60.0,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
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
                                        size: 150.0,
                                        color: Colors.black38,
                                      ))
                                : Material(
                                    child: Image.file(
                                      avatarImageFile,
                                      width: 150.0,
                                      height: 150.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: -10,
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blue,
                                ),
                                onPressed: () => chosePicture(context),
                                highlightColor: Color(0xffaeaeae),
                                iconSize: 30.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 150,
                      width: 150,
                      margin: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SpinKitWave(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          Text("Uploading..")
                        ],
                      ),
                    )
            ],
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
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 10.0),
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

              Container(
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(primaryColor: Color(0xff203152)),
                  child: TextFormField(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "You can't change your email",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 10.0),
                      ),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: Color(0xffaeaeae)),
                    ),
                    controller: emailController,
                  ),
                ),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
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
                      labelText: "Enter Your Contact",
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 10.0),
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
                      labelText: "Enter Your Address",
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 10.0),
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
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "You can't change account type",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.red,
                          textColor: Colors.white);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "User Type",
                      labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff203152)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 10.0),
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

              (widget.userType == "Expert")
                  ? Container(
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
                    )
                  : Container(),
              (widget.userType == "Expert")
                  ? SizedBox(
                      height: 20,
                      child: Text("All field must be filled"),
                    )
                  : Container(),
              (widget.userType == "Expert")
                  ? Stack(
                      children: <Widget>[
                        (!isUploadingDocument)
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: (docUrl != null)
                                    ? CachedNetworkImage(imageUrl: docUrl)
                                    : (_image != null)
                                        ? Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SpinKitWave(
                                      color: Colors.blue,
                                      size: 50.0,
                                    ),
                                    Text("Uploading..")
                                  ],
                                ),
                              ),
                        InkWell(
                          onTap: getDocumentImage,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.5),
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.cameraRetro,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Text(
                                  "Tap to pick image",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          ),

          // Button
          (widget.userType != "Farmer")
              ? InkWell(
                  onTap: () => handleUpdateDataExpert(context),
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
                    child: Text("Proceed to Verification".toUpperCase()),
                  ),
                )
              : InkWell(
                  onTap: () => handleUpdateDataUser(context),
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
                    child: Text("Complete And Proceed".toUpperCase()),
                  ),
                ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        title: Text(
          'Profile Setup',
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              onPressed: () => logoutAlert(context))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  (widget.userType != "Farmer")
                      ? Container(
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
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(widget.userId)
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
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitChasingDots(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                        Text("Uploading..")
                      ],
                    ),
                    color: Colors.black.withOpacity(0.5),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
