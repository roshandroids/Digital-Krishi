import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/AdminScreens/adminMainScreen.dart';
import 'package:digitalKrishi/UI/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/OtherScreens/profileSetup.dart';
import 'package:digitalKrishi/UI/UserScreens/userMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';

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
    Future.delayed(Duration(milliseconds: 3000)).then(
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
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 2.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: FlareActor(
                      "lib/Assets/Images/splash_screen.flr",
                      fit: BoxFit.cover,
                      color: Colors.green,
                      animation: "Untitled",
                    ),
                  ),
                  Container(
                    child: Shimmer.fromColors(
                      baseColor: Colors.green,
                      highlightColor: Colors.greenAccent,
                      child: RichText(
                        text: TextSpan(
                            text: 'Welcome To,',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' Digital Krishi'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ]),
                      ),
                    ),
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
