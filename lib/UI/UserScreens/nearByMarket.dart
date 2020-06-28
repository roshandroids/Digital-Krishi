import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:digitalKrishi/Model/shop_model.dart';
import 'package:digitalKrishi/UI/OtherScreens/placeDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

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
  String thumbNail;
  String shopName;
  String description;

  LatLng location;
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
    await geolocator
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
        if (mounted)
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
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: PlaceDetails(
                            thumbNail: shop.data['thumbNail'],
                            shopName: shop.data['shopName'],
                            locationCoords: LatLng(
                                shop.data['locationCoords'].latitude,
                                shop.data['locationCoords'].longitude),
                            description: shop.data['description'],
                          ),
                        ));
                  },
                  title: shop.data["shopName"],
                ),
                position: LatLng(shop.data["locationCoords"].latitude,
                    shop.data["locationCoords"].longitude)));
            thumbNail = shop.data['thumbNail'];
            shopName = shop.data['shopName'];
            location = LatLng(shop.data['locationCoords'].latitude,
                shop.data['locationCoords'].longitude);
            description = shop.data['description'];
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
        onTap: () => shopOption(context),
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
                      child: CachedNetworkImage(
                        imageUrl: shops[index].thumbNail,
                        placeholder: (context, url) => SpinKitWave(
                          color: Colors.blue,
                          size: 60.0,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
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
    if (mounted)
      setState(() {
        _controller = controller;
      });
  }

  moveCamera() {
    if (shops.length == 0) {
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
      setState(() {
        thumbNail = shops[_pageController.page.toInt()].thumbNail;
        shopName = shops[_pageController.page.toInt()].shopName;
        description = shops[_pageController.page.toInt()].description;

        location = shops[_pageController.page.toInt()].locationCoords;
      });
    }
  }

  void shopOption(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.black.withOpacity(.1),
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.not_listed_location,
                      color: Colors.green,
                    ),
                    title: Text('About This Shop'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: PlaceDetails(
                              thumbNail: thumbNail,
                              shopName: shopName,
                              locationCoords: location,
                              description: description,
                            ),
                          ));
                    }),
                Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 10,
                ),
                ListTile(
                  leading: Icon(
                    Icons.navigation,
                    color: Colors.green,
                  ),
                  title: Text('Navigate'),
                  onTap: () {
                    Navigator.of(context).pop();
                    moveCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Vegetable Markets"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        leading: IconButton(
            icon: Icon(Icons.chevron_left, size: 30),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? (latitude != null && longitude != null)
                  ? Stack(
                      children: <Widget>[
                        (latitude == null && longitude == null)
                            ? Container()
                            : Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(latitude, longitude),
                                      zoom: 17.0),
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
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Searching Markets",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SpinKitDoubleBounce(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                        ],
                      ),
                    )
              : Offline();
        },
        child: Container(),
      ),
    );
  }
}
