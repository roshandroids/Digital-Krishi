import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/exitAppAlert.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/ChatScreens/usersChatList.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/OtherScreens/feeds.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/OtherScreens/homeScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/OtherScreens/moreSettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FarmerMainScreen extends StatefulWidget {
  final String userType;
  FarmerMainScreen({@required this.userType});
  @override
  _FarmerMainScreenState createState() => _FarmerMainScreenState();
}

class _FarmerMainScreenState extends State<FarmerMainScreen>
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
    _tabController = TabController(length: 4, vsync: this);
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
    return WillPopScope(
      onWillPop: () => ExitAppAlert().onBackPress(context: context),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                HomeScreen(
                  userType: widget.userType,
                ),
                Feeds(),
                UsersChatList(),
                MoreSettings(
                  userId: userId,
                  userType: widget.userType,
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Color.fromARGB(0xff, 25, 125, 35),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                indicatorPadding: EdgeInsets.only(bottom: 5),
                indicatorColor: Color.fromARGB(0xff, 25, 125, 35),
                unselectedLabelColor: Colors.blueGrey,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                unselectedLabelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                tabs: <Widget>[
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.home),
                    text: "Home",
                  ),
                  Tab(
                    icon: Icon(Icons.forum),
                    text: "Forum",
                  ),
                  Tab(
                    icon: Icon(Icons.chat),
                    text: "Messages",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.more_horiz,
                    ),
                    text: "More",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
