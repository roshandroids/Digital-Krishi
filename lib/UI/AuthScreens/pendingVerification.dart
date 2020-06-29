import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PendingVerification extends StatefulWidget {
  @override
  _PendingVerificationState createState() => _PendingVerificationState();
}

class _PendingVerificationState extends State<PendingVerification> {
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 300),
          child: AuthMainScreen(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

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
        title: Text("Verification Status"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                "Your account has not been verified yet!\n            Please contact the admin! ",
              ),
            ),
            RaisedButton(
              onPressed: signOut,
              elevation: 20,
              child: Text("Log Out".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
