import 'package:digitalKrishi/CustomComponents/customListTile.dart';
import 'package:digitalKrishi/UI/OtherScreens/calculate.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FertilizerCalculate extends StatefulWidget {
  @override
  _FertilizerCalculateState createState() => _FertilizerCalculateState();
}

class _FertilizerCalculateState extends State<FertilizerCalculate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        alignment: Alignment.bottomLeft,
                        duration: Duration(milliseconds: 100),
                        child: Calculate(
                          url: "https://agritechnepal.com/calc/fertilizer/",
                        )));
              },
              child: ListWidget(
                icon: "pesticide",
                title: "Fertilizer Calculator",
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        alignment: Alignment.bottomLeft,
                        duration: Duration(milliseconds: 100),
                        child: Calculate(
                          url: "https://agritechnepal.com/calc/seed/",
                        )));
              },
              child: ListWidget(
                icon: "seeds",
                title: "Seed Calculator",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
