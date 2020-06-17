import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/marketRate.dart';
import 'package:digitalKrishi/UI/UserScreens/userHomeScreen.dart';
import 'package:digitalKrishi/UI/UserScreens/userProfileScreen.dart';
import 'package:digitalKrishi/UI/UserScreens/weatherUpdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpertMainScreen extends StatefulWidget {
  final double longitude;
  final double latitude;
  ExpertMainScreen({this.latitude, this.longitude});
  @override
  _ExpertMainScreenState createState() => _ExpertMainScreenState();
}

class _ExpertMainScreenState extends State<ExpertMainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String userId;
  @override
  void initState() {
    super.initState();
    getUserData();
    _tabController = TabController(length: 5, vsync: this);
  }

  void getUserData() async {
    await FirebaseAuth.instance.currentUser().then((firebaseUser) {
      if (firebaseUser != null) {
        if (mounted) {
          setState(() {
            userId = firebaseUser.uid;
          });
        }
      }
    });
    await registerNotification();
    await configLocalNotification();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Null> registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    });

    firebaseMessaging.getToken().then((token) {
      Firestore.instance
          .collection('users')
          .document(userId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
    return null;
  }

  Future<Null> configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    return null;
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'com.digital_krishi.digital_krishi',
      'Digital Krishi',
      'Digital Platform to connect Farmer with Experts',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(0xff, 102, 57, 182),
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                enabled: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(Icons.book),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Search Your Book By Category",
                    hintStyle: TextStyle(
                      fontSize: 18,
                    )),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              UserHomeScreen(),
              MarketRate(),
              WeatherUpdate(),
              UserProfileScreen(
                userId: userId,
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            controller: _tabController,
            labelColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            indicatorColor: Colors.green,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: FaIcon(FontAwesomeIcons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.collections_bookmark),
                text: "Saved",
              ),
              Tab(
                icon: Icon(Icons.share),
                text: "Share",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
