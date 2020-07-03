import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UploadDocument extends StatefulWidget {
  @override
  _UploadDocumentState createState() => _UploadDocumentState();
}

class _UploadDocumentState extends State<UploadDocument> {
  String pdfUrl;
  String fileName;

  File pdf;
  int rating = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void chooseFile() async {
    pdf = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf']);

    if (mounted)
      setState(() {
        fileName = basename(pdf.path);
      });
  }

  void uploadFile() async {
    if (pdf != null) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      try {
        StorageReference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('reading_documents')
            .child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(pdf);
        var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        var url = downUrl.toString();
        await Firestore.instance
            .collection('readingDocuments')
            .document()
            .setData({
          'pdfUrl': url,
        });
      } catch (e) {
        if (mounted)
          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: e.message);
            print(e.message);
          });
      }
      if (mounted)
        setState(() {
          pdf = null;
          isLoading = false;
          fileName = null;
          Fluttertoast.showToast(msg: "Upload Successful");
        });
    } else {
      Fluttertoast.showToast(msg: "Please choose a file");
    }
  }

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
        actions: <Widget>[
          (!isLoading)
              ? IconButton(
                  icon: Icon(Icons.cloud_upload),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    uploadFile();
                  })
              : Container(),
        ],
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
          "Upload Documents",
          style:
              TextStyle(color: Color(0xff203152), fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    new BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (fileName == null)
                        ? Container()
                        : Container(
                            child: Text(fileName),
                          ),
                    InkWell(
                      onTap: () {
                        if (mounted)
                          setState(() {
                            fileName = "";
                          });
                        chooseFile();
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Text(
                          "Choose File",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            (isLoading)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(.4),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "uploading...",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SpinKitHourGlass(
                            color: Colors.white,
                            size: 40,
                          )
                        ],
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
