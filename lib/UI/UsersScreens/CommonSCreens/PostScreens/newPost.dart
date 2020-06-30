import 'dart:io';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String userEmail;
  String uId;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final picker = ImagePicker();
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
      uId = user.uid;
    });
    return email;
  }

  TextEditingController postTitle = TextEditingController();
  TextEditingController postDescription = TextEditingController();

  final databaseReference = Firestore.instance;
  String imgUrl;
  File _image;
  String _errorMessage;

  void _post(BuildContext context) async {
    if (postTitle.text.isNotEmpty &&
        postDescription.text.isNotEmpty &&
        _image != null) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        String fileName = basename(_image.path);
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('post_pictures')
            .child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = downUrl.toString();
        setState(() {
          imgUrl = url;
        });

        await databaseReference.collection('posts').document().setData(
          {
            'PostedBy': uId,
            'PostTitle': postTitle.text.trim(),
            'PostDescription': postDescription.text.trim(),
            'PostImage': imgUrl,
            'PostedAt': DateTime.now(),
          },
        );
        setState(() {
          _isLoading = false;
          Fluttertoast.showToast(msg: 'Posted Successfully');
          postTitle.clear();
          postDescription.clear();
          _image = null;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          Fluttertoast.showToast(msg: _errorMessage);
        });
      }
    } else {
      Fluttertoast.showToast(msg: 'Please fill all fields');
    }
  }

  takePicture() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera);

    if (image != null) {
      _image = File(image.path);
      setState(() {});
    }
  }

  Future getImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  void _choosePictureOption(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "Select Any",
      buttons: [
        DialogButton(
          child: Text(
            "Take New",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            takePicture();
            Navigator.of(context).pop();
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Open Gallery",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            getImage();
            Navigator.of(context).pop();
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Add Post Upadte',
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    TextFormField(
                      controller: postTitle,
                      onSaved: (postTitle) => postTitle = postTitle.trim(),
                      decoration: InputDecoration(
                        labelText: "Post Title",
                        hintText: "Post Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: postDescription,
                      onSaved: (postDescription) =>
                          postDescription = postDescription.trim(),
                      textInputAction: TextInputAction.done,
                      maxLength: 250,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: "Post Description",
                        hintText: "Post Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        _choosePictureOption(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(
                          children: <Widget>[
                            (_image != null)
                                ? Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 150,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                  ),
                            Container(
                              alignment: Alignment.center,
                              height: 150,
                              color: Colors.black54,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FaIcon(
                                    FontAwesomeIcons.cameraRetro,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Tap to get image",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                            ? InkWell(
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  _post(context);
                                },
                                child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                        child: Text(
                                      'Post',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ))),
                              )
                            : Offline();
                      },
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            _isLoading
                ? Positioned.fill(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Uploading! Please Wait :)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
