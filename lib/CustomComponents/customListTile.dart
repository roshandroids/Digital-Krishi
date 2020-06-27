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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: <Widget>[
          ListTile(
            isThreeLine: false,
            contentPadding: EdgeInsets.all(5),
            leading: Image.asset(
              'lib/Assets/Images/$ico.png',
              height: 40,
              color: Colors.green,
              width: 40,
            ),
            title: Text(
              titl,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            thickness: 1.5,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
