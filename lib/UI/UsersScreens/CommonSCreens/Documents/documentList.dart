import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/bookImage.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/Documents/openPdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class DocumentList extends StatefulWidget {
  final String userType;

  DocumentList({@required this.userType});
  @override
  _DocumentListState createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Documents"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('readingDocuments')
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.black12,
                                    child: Container(
                                      color: Colors.black12,
                                      height: 20,
                                      width: 50,
                                    ),
                                  ),
                                  title: Shimmer.fromColors(
                                    baseColor: Colors.black,
                                    highlightColor: Colors.black12,
                                    child: Container(
                                      color: Colors.black12,
                                      height: 20,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                ButtonBar(
                                  children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.black12,
                                      child: Container(
                                        color: Colors.black12,
                                        height: 10,
                                        width: 50,
                                      ),
                                    ),
                                    Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.black12,
                                      child: Container(
                                        color: Colors.black12,
                                        height: 10,
                                        width: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    if (snapshot.data.documents.length <= 0)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "No Documents available yet !",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SpinKitDoubleBounce(
                              color: Colors.blue,
                              size: 60,
                            ),
                          ],
                        ),
                      );
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                blurRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      alignment: Alignment.bottomLeft,
                                      duration: Duration(milliseconds: 100),
                                      child: OpenPdf(
                                        url: snapshot.data.documents[index]
                                            ["pdfUrl"],
                                      )));
                            },
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: BookImage(
                                      url: snapshot.data.documents[index]
                                          ["pdfUrl"],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return Container(
                                                child: Wrap(
                                                  children: <Widget>[
                                                    ListTile(
                                                        leading: Icon(
                                                          Icons.warning,
                                                          color: Colors.red,
                                                        ),
                                                        title: Text(
                                                            'Delete This Video'),
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();

                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'readingDocuments')
                                                              .document(snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID)
                                                              .delete();

                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Deleted Successfully",
                                                              backgroundColor:
                                                                  Colors.white,
                                                              textColor:
                                                                  Colors.green);
                                                        }),
                                                    ListTile(
                                                      leading: Icon(
                                                        Icons.close,
                                                        color: Colors.green,
                                                      ),
                                                      title: Text('Cancel'),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
