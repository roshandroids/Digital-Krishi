import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/FarmerScreens/addTask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

class ToDoTaskList extends StatefulWidget {
  final String uId;
  ToDoTaskList({@required this.uId});
  @override
  _ToDoTaskListState createState() => _ToDoTaskListState();
}

class _ToDoTaskListState extends State<ToDoTaskList> {
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Widget _buildListBooks(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    Timestamp date = document["date"];
    String formattedDate =
        DateFormat('MMM dd,yyyy | hh:mm').format(date.toDate());
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 5.0,
          ),
        ],
        color: (document['mark']) ? Colors.red[50] : Colors.green[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          isThreeLine: true,
          onTap: () async {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                    height: 150,
                    color: Colors.black12,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Text('Mark Incolmpete'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.uId)
                                  .collection("task")
                                  .document(document.documentID)
                                  .updateData({"mark": true});
                              Fluttertoast.showToast(
                                  msg: "Marked Incomplete",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Text('Mark Complete'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.uId)
                                  .collection("task")
                                  .document(document.documentID)
                                  .updateData({"mark": false});
                              Fluttertoast.showToast(
                                  msg: "Marked Complete",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                            },
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Text('Delete Task'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.uId)
                                  .collection("task")
                                  .document(document.documentID)
                                  .delete();
                              Fluttertoast.showToast(
                                  msg: "Successfully Deleted",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          leading: (document['mark'] == true)
              ? Icon(
                  Icons.notifications_active,
                  color: Colors.red[700],
                  size: 30,
                )
              : Icon(
                  Icons.done_all,
                  color: Colors.green,
                  size: 30,
                ),
          title: Text(
            document['title'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "Deadline",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          subtitle: Text(
            document["description"],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("To Do Task List"),
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
            TableCalendar(
              calendarController: _calendarController,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(widget.uId)
                      .collection("task")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.black12,
                              child: Container(
                                color: Colors.black12,
                                height: 50,
                                width: 50,
                              ),
                            ),
                            title: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.black12,
                              child: Container(
                                color: Colors.black12,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          );
                        },
                      );
                    if (snapshot.data.documents.length <= 0)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitDoubleBounce(
                              color: Colors.blue,
                              size: 50,
                            ),
                            Text(
                              "You Don't Have Any Pending Task",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      );

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => _buildListBooks(
                          context, snapshot.data.documents[index], 'toDo'),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  alignment: Alignment.bottomLeft,
                  duration: Duration(milliseconds: 100),
                  child: AddTask(
                    uId: widget.uId,
                  )));
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
