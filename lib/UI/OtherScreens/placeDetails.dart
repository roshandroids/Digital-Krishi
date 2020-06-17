import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails extends StatefulWidget {
  final String shopName;
  final String address;
  final String description;
  final String thumbNail;
  final LatLng locationCoords;

  PlaceDetails(
      {@required this.shopName,
      @required this.address,
      @required this.description,
      @required this.thumbNail,
      @required this.locationCoords});

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(widget.shopName),
              Text(widget.address),
              Text(widget.description),
              Text(widget.thumbNail),
              Text(widget.shopName),
              Text(widget.locationCoords.toString())
            ],
          ),
        ),
      ),
    );
  }
}
