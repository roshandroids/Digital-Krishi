import 'package:digitalKrishi/UI/UserScreens/userMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2)).then(
      (val) async {
        FirebaseAuth _auth = FirebaseAuth.instance;

        var user = await _auth.currentUser();

        if (user != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => UserMainScreen()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AuthMainScreen()));
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
          child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
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
                            "कृपया पर्खिनुहोस ",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
