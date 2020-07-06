import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digitalKrishi/CustomComponents/exitAppAlert.dart';
import 'package:digitalKrishi/UI/AuthScreens/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class EmailVerificationPending extends StatefulWidget {
  @override
  _EmailVerificationPendingState createState() =>
      _EmailVerificationPendingState();
}

class _EmailVerificationPendingState extends State<EmailVerificationPending> {
  String email;
  void sendVerificationEmail() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      email = user.email;
      user.sendEmailVerification();
    });
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 300),
          child: SplashScreen(),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void logoutAlert(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: FaIcon(FontAwesomeIcons.signOutAlt),
                    title: Text('Yes, log Out'),
                    onTap: () {
                      signOut();

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.ban),
                  title: Text('No, Stay logged In'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () => logoutAlert(context)),
          )
        ],
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () => ExitAppAlert().onBackPress(context: context),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sorry, to interrupt you !",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://media.giphy.com/media/xT3i1guCHAImD167yE/giphy.gif",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitWave(
                          color: Colors.blue,
                          size: 60.0,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  Text(
                    "Your email hasn't been verified yet ! 😣",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "We have sent a verification link to your inbox",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ArgonTimerButton(
                      height: 60,
                      width: MediaQuery.of(context).size.width / 2,
                      onTap: (startTimer, btnState) {
                        if (btnState == ButtonState.Idle) {
                          startTimer(5);
                          sendVerificationEmail();
                        }
                      },
                      child: Text(
                        "Resend Verification Email",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      loader: (timeLeft) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          child: Text(
                            "$timeLeft",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        );
                      },
                      borderRadius: 5.0,
                      color: Colors.blueGrey,
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
