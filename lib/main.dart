import 'package:digitalKrishi/UI/AdminScreens/adminMainScreen.dart';
import 'package:digitalKrishi/UI/AuthScreens/authMainScreen.dart';
import 'package:digitalKrishi/UI/AuthScreens/splashScreen.dart';
import 'package:digitalKrishi/UI/ExpertScreens/expertMainScreen.dart';
import 'package:digitalKrishi/UI/UserScreens/userMainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/AuthMainScreen': (BuildContext context) => AuthMainScreen(),
        '/UserMainScreen': (BuildContext context) => UserMainScreen(),
        '/ExpertMainScreen': (BuildContext context) => ExpertMainScreen(),
        '/AdminMainScreen': (BuildContext context) => AdminMainScreen(),
      },
    );
  }
}
