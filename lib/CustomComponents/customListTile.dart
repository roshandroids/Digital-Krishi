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
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: ListTile(
        isThreeLine: false,
        contentPadding: EdgeInsets.all(5),
        leading: Image.asset(
          'lib/Assets/Images/$ico.png',
          height: 40,
          color: Color.fromARGB(0xff, 4, 128, 37),
          width: 40,
        ),
        title: Text(
          titl,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
