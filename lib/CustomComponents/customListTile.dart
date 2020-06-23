import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  final String icon;
  final String title;
  ListWidget({this.icon, this.title});

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  Widget build(BuildContext context) {
    String ico = widget.icon;
    String titl = widget.title;
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(5),
        leading: Image.asset(
          'lib/Assets/Images/$ico.png',
          height: 40,
          width: 40,
        ),
        title: Text(
          titl,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
