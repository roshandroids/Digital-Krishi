import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              children: [
                SpinKitWave(
                  color: Colors.red,
                  type: SpinKitWaveType.start,
                  size: 50.0,
                ),
                Text(
                  "OOPS, Looks Like your Internet is not working!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
