import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  final PageController pageController;
  SignUpScreen({@required this.pageController});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  String userType = "Farmer";
  String email;
  String password;
  String fullName;
  bool _isLoading = false;
  String _errorMessage;
  String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void _toggleSignup() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void changeTab() {
    widget.pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
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

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    userId = user.uid;
    return user.uid;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });

      try {
        await signUp(email, password);
        FirebaseUser user = await _firebaseAuth.currentUser();
        await user.sendEmailVerification();
        await Firestore.instance.collection('users').document(userId).setData({
          'fullName': fullName,
          'email': email,
          'photoUrl':
              'https://blog.cpanel.com/wp-content/uploads/2019/08/user-01.png',
          'userType': userType,
          'id': userId,
          'isVerified': 'Not Verified',
          'isFirstTime': 'yes',
          'chattingWith': 'none',
          'pushToken': '',
          'verificationDocument': 'null'
        });
        await FirebaseAuth.instance.signOut();
        setState(() {
          _isLoading = false;
        });
        await Fluttertoast.showToast(
            msg:
                "Sign Up Success\n Please verify ypur email before logging in\nCheck inbox",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);
        changeTab();
      } catch (e) {
        setState(() {
          _isLoading = false;

          _errorMessage = e.message;
          Fluttertoast.showToast(
              msg: _errorMessage,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red,
              textColor: Colors.white);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(top: 23.0, bottom: 30),
                child: Stack(
                  alignment: Alignment.topCenter,
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
                        // height: 420.00,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextFormField(
                                focusNode: nameFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(emailFocusNode);
                                },
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.user,
                                    color: Colors.black,
                                  ),
                                  hintText: "Full Name",
                                  hintStyle: TextStyle(fontSize: 16.0),
                                ),
                                validator: validateName,
                                onSaved: (value) => fullName = value.trim(),
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
                                  horizontal: 20, vertical: 5),
                              child: TextFormField(
                                focusNode: emailFocusNode,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(passwordFocusNode);
                                },
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(fontSize: 16.0),
                                ),
                                validator: validateEmail,
                                onSaved: (value) => email = value.trim(),
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
                                  horizontal: 20, vertical: 5),
                              child: TextFormField(
                                focusNode: passwordFocusNode,
                                obscureText: _obscureText,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    FontAwesomeIcons.lock,
                                    color: Colors.black,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(fontSize: 16.0),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: Colors.black,
                                    ),
                                    onPressed: () => _toggleSignup(),
                                  ),
                                ),
                                validator: validatePassword,
                                onSaved: (value) => password = value.trim(),
                              ),
                            ),
                            Divider(
                              indent: 20,
                              endIndent: 20,
                              thickness: 1,
                              color: Colors.grey[600],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Choose Your Account Type"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 5.0, right: 40.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          userType = "Farmer";
                                        });
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            shape: BoxShape.circle,
                                            color: (userType == "Farmer")
                                                ? Colors.greenAccent
                                                : Colors.white,
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Image.asset(
                                                'lib/Assets/Images/farmer.png',
                                                height: 25,
                                                width: 25,
                                                color: (userType == "Farmer")
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                              Text(
                                                "Farmer",
                                                style: TextStyle(
                                                  color: (userType == "Farmer")
                                                      ? Colors.red
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          userType = "Expert";
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          shape: BoxShape.circle,
                                          color: (userType == "Expert")
                                              ? Colors.greenAccent
                                              : Colors.white,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Image.asset(
                                              'lib/Assets/Images/expert.png',
                                              height: 25,
                                              width: 25,
                                              color: (userType == "Expert")
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                            Text(
                                              "Expert",
                                              style: TextStyle(
                                                color: (userType == "Expert")
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(width: .5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
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
                                    begin: const FractionalOffset(0.2, 0.2),
                                    end: const FractionalOffset(1.0, 1.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _validateAndSubmit();
                                },
                                highlightColor: Colors.transparent,
                                splashColor: Color(0xFFf4ca2cd),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 42.0),
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
  //validator for email

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

  //validator for name
  String validateName(String value) {
    if (value.length < 6)
      return 'Name too short';
    else
      return null;
  }
}
