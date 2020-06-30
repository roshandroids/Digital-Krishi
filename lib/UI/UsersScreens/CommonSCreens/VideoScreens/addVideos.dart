import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddVideos extends StatefulWidget {
  @override
  _AddVideosState createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  TextEditingController urlController = TextEditingController();
  Item selectedCategory;
  bool isUploading = false;
  List videoUrl = [];
  List<Item> users = <Item>[
    const Item(
      'Asparagus Farming',
    ),
    const Item(
      'Tomato Farming',
    ),
    const Item(
      'Rice Farming',
    ),
    const Item(
      'Potato Farming',
    ),
    const Item(
      'Cabbage Farming',
    ),
    const Item(
      'Cauliflower Farming',
    ),
    const Item(
      'Mushroom Farming',
    ),
    const Item(
      'Beans Farming',
    ),
  ];
  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Add New Video"),
        actions: <Widget>[
          (isUploading)
              ? Container()
              : IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (selectedCategory != null &&
                        videoUrl.length != 0 &&
                        urlController.text != null) {
                      setState(() {
                        isUploading = true;
                      });
                      try {
                        await Firestore.instance
                            .collection('videos')
                            .document()
                            .setData(
                          {
                            'title': selectedCategory.name,
                            'videoUrl': videoUrl,
                          },
                        );
                        setState(() {
                          videoUrl.length = 0;
                          selectedCategory = null;
                          isUploading = false;
                        });
                      } catch (e) {
                        setState(() {
                          isUploading = false;
                        });
                        print(e);
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Please Enter all Data");
                    }
                  },
                ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Select Vegetable Category",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  DropdownButton<Item>(
                    hint: Text(
                      "None",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: selectedCategory,
                    onChanged: (Item value) {
                      setState(() {
                        selectedCategory = value;
                        print(value.name);
                      });
                    },
                    items: users.map((Item user) {
                      return DropdownMenuItem<Item>(
                        value: user,
                        child: Row(
                          children: <Widget>[
                            Text(
                              user.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "How many videos you would like to add ?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextField(
                          controller: urlController,
                          decoration: InputDecoration(
                            labelText: "Enter The Video URl",
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (urlController.text.isNotEmpty) {
                                setState(() {
                                  videoUrl.add(urlController.text);
                                });
                                urlController.clear();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please Insert Url");
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                boxShadow: [
                                  new BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    blurRadius: 2.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Add Url To List",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          (videoUrl.length != 0)
                              ? InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    setState(() {
                                      videoUrl.length = 0;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red[600],
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(width: .5)),
                                    height: 40,
                                    width: 70,
                                    child: Text(
                                      "Clear List",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 40,
                                  width: 70,
                                ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: ListView.builder(
                          itemCount: videoUrl.length,
                          itemBuilder: (context, index) {
                            return Text(
                              videoUrl[index],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            );
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          (isUploading)
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(.1),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitHourGlass(
                          color: Colors.green,
                          size: 60,
                        ),
                        Text(
                          "Uploading Please Wait..",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class Item {
  const Item(
    this.name,
  );
  final String name;
}
