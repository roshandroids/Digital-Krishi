import 'package:google_maps_flutter/google_maps_flutter.dart';

class Shop {
  String shopName;
  String address;
  String description;
  String thumbNail;
  LatLng locationCoords;

  Shop(
      {this.shopName,
      this.address,
      this.description,
      this.thumbNail,
      this.locationCoords});

  Shop.fromMap(Map snapshot)
      : shopName = snapshot["shopName"],
        address = snapshot["address"],
        description = snapshot["description"],
        thumbNail = snapshot["thumbNail"],
        locationCoords = LatLng(snapshot["locationCoords"].latitude,
            snapshot["locationCoords"].longitude);
}
