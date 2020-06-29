import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/loadingIndicator.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:digitalKrishi/UI/AuthScreens/emailVerificationPending.dart';
import 'package:digitalKrishi/UI/AuthScreens/pendingVerification.dart';
import 'package:digitalKrishi/UI/AuthScreens/profileSetup.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/adminMainScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/FarmerScreens/farmerMainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  final PageController pageController;
  LoginScreen({@required this.pageController});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _formKeyReset = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String loggedInUserType;
  String isFirstTime;
  String isVerified;
  String email;
  String password;
  String emailReset;
  String _errorMessage;
  String imageUrl;
  bool _isLoading = false;
  void _toggleLogin() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Check if form is valid before perform login
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user.isEmailVerified) {
      return user.uid;
    } else {
      return null;
    }
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      String userId = "";

      try {
        userId = await signIn(email, password);
        if (userId != null) {
          await Firestore.instance
              .collection('users')
              .document(userId)
              .get()
              .then((DocumentSnapshot ds) {
            setState(() {
              loggedInUserType = ds.data['userType'];
              isFirstTime = ds.data['isFirstTime'];
              isVerified = ds.data['isVerified'];
              imageUrl = ds.data['photoUrl'];
            });
          });

          Fluttertoast.showToast(
              msg: "LoginSuccess",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white);
        } else {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              child: EmailVerificationPending(),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;

          _errorMessage = e.message;
          Fluttertoast.showToast(
              msg: _errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white);
        });
      }
      setState(() {
        _isLoading = false;
      });
      try {
        if (userId.length > 0 && userId != null) {
          if (loggedInUserType == "Admin") {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                child: AdminMainScreen(
                  userId: userId,
                  userType: loggedInUserType,
                ),
              ),
            );
          } else if (loggedInUserType == "Farmer") {
            if (isFirstTime == "yes") {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                  child: ProfileSetup(
                    imageUrl: imageUrl,
                    userId: userId,
                    userType: loggedInUserType,
                  ),
                ),
              );
            } else {
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
            }
          } else if (loggedInUserType == "Expert") {
            if (isFirstTime == "yes") {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                  child: ProfileSetup(
                    imageUrl: imageUrl,
                    userId: userId,
                    userType: loggedInUserType,
                  ),
                ),
              );
            } else {
              if (isVerified == "Not Verified") {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 300),
                    child: PendingVerification(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 300),
                    child: ExpertMainScreen(
                      url: imageUrl,
                      userType: loggedInUserType,
                      usrId: userId,
                    ),
                  ),
                );
              }
            }
          }
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
      } catch (e) {
        print(e);
      }
    }
  }

//for password reset
  bool _validateAndSaveReset() {
    final form = _formKeyReset.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmitReset() async {
    if (_validateAndSaveReset()) {
      setState(() {
        _errorMessage = "";
      });

      try {
        sendPasswordResetMail(emailReset);

        setState(
          () {
            Fluttertoast.showToast(
                msg:
                    "Email sent to,$emailReset follow the link to reset your password",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white);

            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
                child: AuthMainScreen(),
              ),
            );
          },
        );
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          Fluttertoast.showToast(
              msg: _errorMessage,
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white);
        });
      }
    }
  }

//send password reset mail
  Future<void> sendPasswordResetMail(String emailReset) async {
    await _firebaseAuth.sendPasswordResetEmail(email: emailReset);

    return null;
  }

//for password forget dialogue

  resetDialog() {
    return Alert(
      context: context,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: true,
        animationType: AnimationType.grow,
        animationDuration: Duration(milliseconds: 400),
        backgroundColor: Colors.white,
        descStyle: TextStyle(color: Colors.black, fontSize: 16),
        titleStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      type: AlertType.none,
      title: "Reset Password",
      desc: "We will send a link to reset your password",
      content: Form(
        key: _formKeyReset,
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12, width: 1),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Email',
              hintStyle: TextStyle(fontSize: 18, color: Colors.black)),
          validator: validateEmail,
          onSaved: (value) => emailReset = value.trim(),
        ),
      ),
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          width: 120,
        ),
        DialogButton(
          color: Colors.green,
          child: Text(
            "Send",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _validateAndSubmitReset();
          },
          width: 120,
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 23.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: .5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 300.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: TextFormField(
                                      focusNode: emailFocusNode,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.envelope,
                                          color: Colors.black,
                                          size: 22.0,
                                        ),
                                        hintText: "Email Address",
                                        hintStyle: TextStyle(fontSize: 17.0),
                                      ),
                                      validator: validateEmail,
                                      onSaved: (value) => email = value.trim(),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () {
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocusNode);
                                      },
                                    ),
                                  ),
                                  Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    color: Colors.grey[600],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: TextFormField(
                                      focusNode: passwordFocusNode,
                                      obscureText: _obscureText,
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        icon: Icon(
                                          FontAwesomeIcons.lock,
                                          size: 22.0,
                                          color: Colors.black,
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(fontSize: 17.0),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 15.0,
                                            color: Colors.black,
                                          ),
                                          onPressed: () => _toggleLogin(),
                                        ),
                                      ),
                                      validator: validatePassword,
                                      onSaved: (value) =>
                                          password = value.trim(),
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                  Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    thickness: 1,
                                    color: Colors.grey[600],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      _validateAndSubmit();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: .5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Color(0xFFf67B26F),
                                            offset: Offset(1.0, 6.0),
                                            blurRadius: 20.0,
                                          ),
                                          BoxShadow(
                                            color: Color(0xFFf4ca2cd),
                                            offset: Offset(1.0, 6.0),
                                            blurRadius: 20.0,
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFf4ca2cd),
                                              Color(0xFFf67B26F)
                                            ],
                                            begin: const FractionalOffset(
                                                0.2, 0.2),
                                            end: const FractionalOffset(
                                                1.0, 1.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                          onPressed: () {
                            resetDialog();
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _isLoading ? LoadingIndicator() : Container(),
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  //validator for password
  String validatePassword(String value) {
    if (value.length < 8)
      return 'Password must be 8 character long';
    else
      return null;
  }
}
