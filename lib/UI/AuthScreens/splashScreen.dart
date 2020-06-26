import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/AdminScreens/adminMainScreen.dart';
import 'package:digitalKrishi/UI/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/OtherScreens/profileSetup.dart';
import 'package:digitalKrishi/UI/UserScreens/userMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  String loggedInUserType;
  String userId;
  String isFirstTime;
  String url;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Future.delayed(Duration(seconds: 1)).then(
      (val) async {
        FirebaseAuth _auth = FirebaseAuth.instance;

        var user = await _auth.currentUser();

        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get()
            .then((DocumentSnapshot ds) {
          setState(() {
            userId = user.uid;
            isFirstTime = ds.data['isFirstTime'];
            loggedInUserType = ds.data['userType'];
            url = ds.data['photoUrl'];
          });
          // use ds as a snapshot
          print("User type:- " + loggedInUserType);
        });

        if (user != null) {
          if (isFirstTime == 'yes' && loggedInUserType != "Admin") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetup(
                  userId: userId,
                  userType: loggedInUserType,
                ),
              ),
            );
          } else {
            if (loggedInUserType == "Farmer") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserMainScreen(),
                ),
              );
            } else if (loggedInUserType == "Expert") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpertMainScreen(
                    url: url,
                  ),
                ),
              );
            } else if (loggedInUserType == "Admin") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminMainScreen(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthMainScreen(),
                ),
              );
            }
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AuthMainScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffffC9D6FF), Color(0xffffE2E2E2)])),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: 200,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'lib/Assets/Images/icon.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Please Wait.. ",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: SpinKitWave(
                color: Colors.green,
                size: 50.0,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
