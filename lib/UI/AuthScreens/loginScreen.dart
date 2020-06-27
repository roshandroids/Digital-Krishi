import 'package:digitalKrishi/CustomComponents/loadingIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String email;
  String password;
  String emailReset;
  String _errorMessage;

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

    return user.uid;
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
        print(userId);
        Fluttertoast.showToast(
            msg: "LoginSuccess",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.blue,
            textColor: Colors.white);
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
      setState(() {
        _isLoading = false;
      });

      if (userId.length > 0 && userId != null) {
        Navigator.of(context).pushReplacementNamed('/UserMainScreen');
      } else {
        Navigator.of(context).pushReplacementNamed('/AuthMainScreen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
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
                      height: 250.0,
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
                                onSaved: (value) => password = value.trim(),
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            Divider(
                              indent: 20,
                              endIndent: 20,
                              thickness: 1,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _isLoading
                      ? LoadingIndicator()
                      : Positioned(
                          bottom: -15,
                          child: Container(
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
                                  "LOGIN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                  ),
                                ),
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
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
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
