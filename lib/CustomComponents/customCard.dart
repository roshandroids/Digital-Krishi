import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String subTitle;
  final String icon;
  CustomCard(
      {@required this.icon, @required this.subTitle, @required this.title});
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title,
                style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(widget.subTitle),
            leading: Image.asset(
              'lib/Assets/Images/${widget.icon}.png',
              height: 40,
              width: 40,
              color: Colors.blueGrey,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.green[500],
            ),
          ),
        ],
      ),
    );
  }
}
