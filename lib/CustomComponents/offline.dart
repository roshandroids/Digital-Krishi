import 'package:flutter/material.dart';

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2),
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            children: [
              Image.asset('lib/Assets/offline.gif'),
              Text(
                "OOPS, Looks Like your Internet is not working!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
