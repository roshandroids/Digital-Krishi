import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PendingVerification extends StatefulWidget {
  @override
  _PendingVerificationState createState() => _PendingVerificationState();
}

class _PendingVerificationState extends State<PendingVerification> {
  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
