import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/addTraining.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class AllTrainings extends StatefulWidget {
  final String userType;
  final String userId;
  AllTrainings({@required this.userType, @required this.userId});
  @override
  _AllTrainingsState createState() => _AllTrainingsState();
}

class _AllTrainingsState extends State<AllTrainings> {
  bool isLoading = false;
  bool isDeleting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Training Lists"),
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
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance.collection('trainings').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return LinearProgressIndicator(
                    backgroundColor: Colors.green,
                  );
                if (snapshot.data.documents.length <= 0)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitThreeBounce(
                          color: Colors.green,
                          size: 30.0,
                        ),
                        Text("No trainings Available yet")
                      ],
                    ),
                  );
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildListTrainings(
                      context, snapshot.data.documents[index], 'trainings'),
                );
              }),
          (!isLoading)
              ? Container()
              : (isDeleting)
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(.5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Booking your Seat..",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SpinKitHourGlass(
                              color: Colors.white,
                              size: 60,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
        ],
      ),
      floatingActionButton: (widget.userType == "Admin")
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: AddTraining(),
                  ),
                );
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.green),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          : Container(),
    );
  }

  Widget _buildListTrainings(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    Timestamp bookingDate = document["date"];
    String date = DateFormat('MMM dd,yyyy').format(bookingDate.toDate());

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, .5), blurRadius: 1)
          ]),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              document['trainingTitle'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 20,
                    ),
                    Text(
                      document["address"],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Text(
                  date.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 8, bottom: 10),
            child: Text(
              document["description"],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Seat Capacity : " + document['seatCapacity'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  "Remaining Seats : " + document["remainingSeats"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          (widget.userType != "Admin")
              ? (int.parse(document['remainingSeats']) <= 0)
                  ? Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width / 3,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.redAccent[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, .5),
                                blurRadius: 1),
                          ]),
                      child: Text(
                        "Bookiing Full",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : StreamBuilder(
                      stream: Firestore.instance
                          .collection("trainings")
                          .document(document.documentID)
                          .collection("users")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.black12,
                            child: Container(
                              color: Colors.black12,
                              height: 50,
                              width: 100,
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.black12,
                            child: Container(
                              color: Colors.black12,
                              height: 50,
                              width: 100,
                            ),
                          );
                        } else {
                          if (snapshot.data.documents.length != 0) {
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              if (snapshot.data.documents[i]['bookedBy'] ==
                                  widget.userId) {
                                return Container(
                                  margin: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(0, 0, 0, .5),
                                            blurRadius: 1),
                                      ]),
                                  child: Text(
                                    "Already Booked",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                );
                              } else {
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext bc) {
                                          return Container(
                                            height: 100,
                                            color: Colors.black12,
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                    ),
                                                    trailing:
                                                        Icon(Icons.arrow_right),
                                                    title: Text(
                                                        'Book This Taining'),
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (mounted)
                                                        setState(() {
                                                          isLoading = true;
                                                        });

                                                      await Firestore.instance
                                                          .collection(
                                                              "trainings")
                                                          .document(document
                                                              .documentID)
                                                          .updateData({
                                                        "remainingSeats":
                                                            (int.parse(document[
                                                                        'remainingSeats']) -
                                                                    1)
                                                                .toString()
                                                      });
                                                      await Firestore.instance
                                                          .collection(
                                                              "trainings")
                                                          .document(document
                                                              .documentID)
                                                          .collection("users")
                                                          .document()
                                                          .setData({
                                                        "bookedBy":
                                                            widget.userId
                                                      });
                                                      if (mounted)
                                                        setState(() {
                                                          isLoading = false;
                                                        });

                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Booked Successfully",
                                                          backgroundColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white);
                                                    },
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: .5,
                                                  color: Colors.black,
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    leading: Icon(
                                                      Icons.cancel,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    trailing:
                                                        Icon(Icons.arrow_right),
                                                    title: Text('Cancel'),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, .5),
                                              blurRadius: 1),
                                        ]),
                                    child: Text(
                                      "Book Now",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                );
                              }
                            }
                          } else {
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return Container(
                                        height: 100,
                                        color: Colors.black12,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                ),
                                                trailing:
                                                    Icon(Icons.arrow_right),
                                                title:
                                                    Text('Book This Taining'),
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  if (mounted)
                                                    setState(() {
                                                      isLoading = true;
                                                    });

                                                  await Firestore.instance
                                                      .collection("trainings")
                                                      .document(
                                                          document.documentID)
                                                      .updateData({
                                                    "remainingSeats":
                                                        (int.parse(document[
                                                                    'remainingSeats']) -
                                                                1)
                                                            .toString()
                                                  });
                                                  await Firestore.instance
                                                      .collection("trainings")
                                                      .document(
                                                          document.documentID)
                                                      .collection("users")
                                                      .document()
                                                      .setData({
                                                    "bookedBy": widget.userId
                                                  });
                                                  if (mounted)
                                                    setState(() {
                                                      isLoading = false;
                                                    });

                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booked Successfully",
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white);
                                                },
                                              ),
                                            ),
                                            Divider(
                                              thickness: .5,
                                              color: Colors.black,
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.cancel,
                                                  color: Colors.blueGrey,
                                                ),
                                                trailing:
                                                    Icon(Icons.arrow_right),
                                                title: Text('Cancel'),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width / 3,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, .5),
                                          blurRadius: 1),
                                    ]),
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return Container(
                                      height: 100,
                                      color: Colors.black12,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.check_circle_outline,
                                                color: Colors.green,
                                              ),
                                              trailing: Icon(Icons.arrow_right),
                                              title: Text('Book This Taining'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                if (mounted)
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                await Firestore.instance
                                                    .collection("trainings")
                                                    .document(
                                                        document.documentID)
                                                    .updateData({
                                                  "remainingSeats": (int.parse(
                                                              document[
                                                                  'remainingSeats']) -
                                                          1)
                                                      .toString()
                                                });
                                                await Firestore.instance
                                                    .collection("trainings")
                                                    .document(
                                                        document.documentID)
                                                    .collection("users")
                                                    .document()
                                                    .setData({
                                                  "bookedBy": widget.userId
                                                });
                                                if (mounted)
                                                  setState(() {
                                                    isLoading = false;
                                                  });

                                                Fluttertoast.showToast(
                                                    msg: "Booked Successfully",
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white);
                                              },
                                            ),
                                          ),
                                          Divider(
                                            thickness: .5,
                                            color: Colors.black,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.cancel,
                                                color: Colors.blueGrey,
                                              ),
                                              trailing: Icon(Icons.arrow_right),
                                              title: Text('Cancel'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width / 3,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, .5),
                                        blurRadius: 1),
                                  ]),
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                      },
                    )
              : InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            height: 100,
                            color: Colors.black12,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    trailing: Icon(Icons.arrow_right),
                                    title: Text('Delete This Taining'),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      if (mounted)
                                        setState(() {
                                          isDeleting = true;
                                        });

                                      await Firestore.instance
                                          .collection("trainings")
                                          .document(document.documentID)
                                          .delete();

                                      if (mounted)
                                        setState(() {
                                          isDeleting = false;
                                        });

                                      Fluttertoast.showToast(
                                          msg: "Delete Successfully",
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white);
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: .5,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.cancel,
                                      color: Colors.blueGrey,
                                    ),
                                    trailing: Icon(Icons.arrow_right),
                                    title: Text('Cancel'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .5),
                              blurRadius: 1),
                        ]),
                    child: Text(
                      "Delete Training",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
