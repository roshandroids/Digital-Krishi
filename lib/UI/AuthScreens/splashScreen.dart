import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/AuthScreens/pendingVerification.dart';
import 'package:digitalKrishi/UI/AuthScreens/profileSetup.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/adminMainScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/FarmerScreens/farmerMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loggedInUserType;
  String userId;
  String isFirstTime;
  String url;
  bool emailVerified = false;
  String isVerified;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Future.delayed(Duration(milliseconds: 3000)).then(
      (val) async {
        FirebaseAuth _auth = FirebaseAuth.instance;

        var user = await _auth.currentUser();

        if (user != null) {
          if (user.isEmailVerified) {
            setState(() {
              emailVerified = true;
              userId = user.uid;
            });
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
                isVerified = ds.data['isVerified'];
              });
            });
          } else {
            setState(() {
              emailVerified = false;
              userId = user.uid;
            });
          }
        }

        if (userId == null) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              child: AuthMainScreen(),
            ),
          );
        } else {
          if (isFirstTime == 'yes' && loggedInUserType != "Admin") {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                child: ProfileSetup(
                  imageUrl: url,
                  userId: userId,
                  userType: loggedInUserType,
                ),
              ),
            );
          } else {
            if (loggedInUserType == "Farmer") {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                  child: FarmerMainScreen(
                    userType: loggedInUserType,
                  ),
                ),
              );
            } else if (loggedInUserType == "Expert") {
              if (isFirstTime == "yes") {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 300),
                    child: ProfileSetup(
                      userType: loggedInUserType,
                      imageUrl: url,
                      userId: userId,
                    ),
                  ),
                );
              } else {
                if (isVerified == "Verified") {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 300),
                      child: ExpertMainScreen(
                        userType: loggedInUserType,
                        url: url,
                        usrId: userId,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 300),
                      child: PendingVerification(),
                    ),
                  );
                }
              }
            } else if (loggedInUserType == "Admin") {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                  child: AdminMainScreen(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                  child: AuthMainScreen(),
                ),
              );
            }
          }
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
