import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  final String uId;
  AddTask({@required this.uId});
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  DateTime _eventDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Task"),
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
      key: _key,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextFormField(
                        controller: _title,
                        validator: (value) =>
                            (value.isEmpty) ? "Please Enter title" : null,
                        style: TextStyle(fontSize: 20.0),
                        decoration: InputDecoration(
                            labelText: "Task Title",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextFormField(
                        controller: _description,
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) =>
                            (value.isEmpty) ? "Please Enter description" : null,
                        style: TextStyle(fontSize: 20.0),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: "Task Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          new BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.green,
                        ),
                        title: Text("Choose Date(YYYY-MM-DD)"),
                        subtitle: Text(
                            "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _eventDate,
                              firstDate: DateTime(_eventDate.year - 5),
                              lastDate: DateTime(_eventDate.year + 5));
                          if (picked != null) {
                            setState(() {
                              _eventDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.green,
                        child: MaterialButton(
                          onPressed: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isUploading = true;
                              });
                              await Firestore.instance
                                  .collection("users")
                                  .document(widget.uId)
                                  .collection("task")
                                  .document()
                                  .setData({
                                "title": _title.text.trim(),
                                "description": _description.text.trim(),
                                "date": _eventDate,
                                "mark": true
                              });

                              setState(() {
                                isUploading = false;
                                _title.clear();
                                _description.clear();
                                _eventDate = DateTime.now();
                                Fluttertoast.showToast(
                                    msg: "Added Successfully");
                              });
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(fontSize: 20.0).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (isUploading)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SpinKitHourGlass(
                            color: Colors.white,
                            size: 50,
                          ),
                          Text(
                            "Adding Your Task..",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white),
                          ),
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
