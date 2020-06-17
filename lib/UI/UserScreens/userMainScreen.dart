import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/marketRate.dart';
import 'package:digitalKrishi/UI/UserScreens/nearByMarket.dart';
import 'package:digitalKrishi/UI/UserScreens/userHomeScreen.dart';
import 'package:digitalKrishi/UI/UserScreens/userProfileScreen.dart';
import 'package:digitalKrishi/UI/UserScreens/weatherUpdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserMainScreen extends StatefulWidget {
  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen>
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
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              UserHomeScreen(),
              MarketRate(),
              WeatherUpdate(),
              NearByMarket(),
              UserProfileScreen(
                userId: userId,
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.green,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              indicatorColor: Colors.green,
              unselectedLabelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  icon: FaIcon(FontAwesomeIcons.home),
                  text: "Home Screen",
                ),
                Tab(
                  icon: Icon(Icons.attach_money),
                  text: "Price Screen",
                ),
                Tab(
                  icon: Icon(Icons.cloud_circle),
                  text: "Share Screen",
                ),
                Tab(
                  icon: Icon(Icons.shop),
                  text: "Market Screen",
                ),
                Tab(
                  icon: CachedNetworkImage(
                      height: 30,
                      width: 30,
                      imageUrl:
                          "https://img.icons8.com/plasticine/2x/user.png"),
                  text: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
