import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVideos extends StatefulWidget {
  @override
  _AddVideosState createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  TextEditingController urlController = TextEditingController();
  Item selectedCategory;
  int _currentValue = 0;
  List videoUrl = [];
  List<Item> users = <Item>[
    const Item(
      'Asparagus ',
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
      'Cabbage',
    ),
    const Item(
      'Cauliflower',
    ),
    const Item(
      'Mushroom',
    ),
    const Item(
      'Beans',
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
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () async {
              await Firestore.instance.collection('videos').document().setData(
                {
                  'title': selectedCategory.name,
                  'videoUrl': videoUrl,
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
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
                  "Select Video Title",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              DropdownButton<Item>(
                hint: Text(
                  "Farming Category",
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
                              color: Colors.black, fontWeight: FontWeight.w500),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: urlController,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        videoUrl.add(urlController.text);
                      });
                      urlController.clear();
                    },
                    child: Text("Add Video"),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: videoUrl.length,
                    itemBuilder: (context, index) {
                      return Text(videoUrl[index]);
                    }),
              )
              // NumberPicker.integer(
              //     initialValue: _currentValue,
              //     minValue: 0,
              //     maxValue: 100,
              //     onChanged: (newValue) =>
              //         setState(() => _currentValue = newValue)),
              // new Text("Current number: $_currentValue"),
              // RaisedButton(
              //   onPressed: () => print(videoUrl),
              //   child: Text("ds"),
              // ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: _currentValue,
              //     itemBuilder: (context, int index) {
              //       return TextFormField(
              //         onChanged: (value) {
              //           videoUrl.add(value);
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
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
