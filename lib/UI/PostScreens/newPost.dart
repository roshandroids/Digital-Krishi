import 'dart:io';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    print(userEmail);
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
          print("Post Picture uploaded");
          imgUrl = url;
        });
        print("Download URL :$url");
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
      print("eroor");
      Fluttertoast.showToast(msg: 'Please fill all fields');
    }
  }

  takePicture() async {
    print('Picker is called');
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose any option",
            style: TextStyle(),
          ),
          content: Text(
            "You can choose image from gallery or take picture from camera",
            style: TextStyle(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.orange,
                  size: 30,
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  takePicture();
                  Navigator.of(context).pop();
                },
              ),
            ),
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.cloudUploadAlt,
                  color: Colors.orange,
                  size: 30,
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  getImage();
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0xff, 241, 241, 254),
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
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xffff9966), Color(0xffff5e62)])),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                          maxLines: 5,
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
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: (_image != null)
                                ? Image.file(_image)
                                : Container(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.cameraRetro),
                                          Text(
                                            "Choose or take a picture",
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(5)),
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
                            CircularProgressIndicator(
                              backgroundColor: Colors.green,
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
