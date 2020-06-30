import 'dart:io';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMarketDetails extends StatefulWidget {
  @override
  _AddMarketDetailsState createState() => _AddMarketDetailsState();
}

class _AddMarketDetailsState extends State<AddMarketDetails> {
  bool _isLoading = false;
  final picker = ImagePicker();

  TextEditingController marketName = TextEditingController();
  TextEditingController marketDescription = TextEditingController();
  LatLng locationCoords;

  final databaseReference = Firestore.instance;
  String imgUrl;
  File _image;
  String _errorMessage;

  void _post(BuildContext context) async {
    if (marketName.text.isNotEmpty &&
        marketDescription.text.isNotEmpty &&
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

        await databaseReference.collection('shops').document().setData(
          {
            'shopName': marketName.text.trim(),
            'description': marketDescription.text.trim(),
            'thumbNail': imgUrl,
            'markerId': 1,
            'locationCoords':
                GeoPoint(locationCoords.latitude, locationCoords.longitude),
          },
        );
        setState(() {
          _isLoading = false;
          Fluttertoast.showToast(msg: 'Uploaded Successfully');
          marketName.clear();
          marketDescription.clear();
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

  Future getImage() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
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
          'Add New Markets',
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      TextFormField(
                        controller: marketName,
                        onSaved: (postTitle) => postTitle = postTitle.trim(),
                        decoration: InputDecoration(
                          labelText: "Market Name",
                          hintText: "Market Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: marketDescription,
                        onSaved: (postDescription) =>
                            postDescription = postDescription.trim(),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: "News Portal URL",
                          hintText: "News Portal URL",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Select News Portal Logo",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          getImage();
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
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Image.file(
                                        _image,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
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
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                        'Upload',
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
