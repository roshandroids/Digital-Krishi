import 'package:digitalKrishi/CustomComponents/exitAppAlert.dart';
import 'package:digitalKrishi/UI/AuthScreens/splashScreen.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/adminHome.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/usersList.dart';
import 'package:digitalKrishi/UI/UsersScreens/AdminScreens/verificationRequest.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/OtherScreens/feeds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class AdminMainScreen extends StatefulWidget {
  final String userType;
  final String userId;
  AdminMainScreen({@required this.userId, @required this.userType});
  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return WillPopScope(
      onWillPop: () => ExitAppAlert().onBackPress(context: context),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: Scaffold(
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                AdminHome(
                  uId: widget.userId,
                ),
                Feeds(),
                VerificationRequest(
                  userType: widget.userType,
                ),
                UsersList(
                  userType: widget.userType,
                )
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                dragStartBehavior: DragStartBehavior.down,
                labelColor: Color.fromARGB(0xff, 25, 125, 35),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                indicatorPadding: EdgeInsets.only(bottom: 5),
                indicatorColor: Color.fromARGB(0xff, 25, 125, 35),
                unselectedLabelColor: Colors.blueGrey,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                unselectedLabelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                tabs: <Widget>[
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.home),
                    text: "Home",
                  ),
                  Tab(
                    icon: Icon(Icons.forum),
                    text: "Forum",
                  ),
                  Tab(
                    icon: Icon(Icons.person_add),
                    text: "Request",
                  ),
                  Tab(
                    icon: Icon(Icons.supervised_user_circle),
                    text: "Users",
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
