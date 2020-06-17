import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/OtherScreens/placeDetails.dart';
import 'package:digitalKrishi/UI/OtherScreens/shop_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByMarket extends StatefulWidget {
  @override
  _NearByMarketState createState() => _NearByMarketState();
}

class _NearByMarketState extends State<NearByMarket> {
  GoogleMapController _controller;

  List<Marker> allMarkers = [];

  List<Shop> shops = [];

  PageController _pageController;
  double longitude;
  double latitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  int prevPage;
  @override
  void initState() {
    super.initState();
    getLocation();

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void getLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted)
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;
        });
    });
    getShops();
  }

  void getShops() async {
    await Firestore.instance.collection("shops").getDocuments().then((element) {
      element.documents.forEach((shop) {
        setState(() {
          shops.add(Shop.fromMap(shop.data));
          allMarkers.add(Marker(
              icon: BitmapDescriptor.defaultMarker,
              markerId: MarkerId(shop.data["markerId"]),
              draggable: true,
              infoWindow: InfoWindow(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetails(
                          thumbNail: shop.data['thumbNail'],
                          shopName: shop.data['shopName'],
                          locationCoords: LatLng(
                              shop.data['locationCoords'].latitude,
                              shop.data['locationCoords'].longitude),
                          description: shop.data['description'],
                          address: shop.data["address"],
                        ),
                      ),
                    );
                  },
                  title: shop.data["shopName"],
                  snippet: shop.data["address"]),
              position: LatLng(shop.data["locationCoords"].latitude,
                  shop.data["locationCoords"].longitude)));
        });
      });
    });
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _shopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 400.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          moveCamera();
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          // height: 200.0,
          // width: 350.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.0, 4.0),
                  blurRadius: 10.0,
                ),
              ]),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200]),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    // height: 100,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          topLeft: Radius.circular(10.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          CachedNetworkImage(imageUrl: shops[index].thumbNail),
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Flexible(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shops[index].shopName,
                          style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          shops[index].address,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Container(
                            width: 170.0,
                            child: Text(
                              shops[index].description,
                              style: TextStyle(
                                  fontSize: 11.0, fontWeight: FontWeight.w300),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  moveCamera() {
    if (shops.length == 0) {
      print("Is Null");
    } else {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: shops[_pageController.page.toInt()].locationCoords,
              zoom: 17.0,
              bearing: 45.0,
              tilt: 45.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          (latitude == null && longitude == null)
              ? Container()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude), zoom: 17.0),
                    markers: Set.from(allMarkers),
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: mapCreated,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    mapType: MapType.hybrid,
                  ),
                ),
          Positioned(
            top: 50,
            child: Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: shops.length,
                itemBuilder: (BuildContext context, int index) {
                  return _shopList(index);
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
