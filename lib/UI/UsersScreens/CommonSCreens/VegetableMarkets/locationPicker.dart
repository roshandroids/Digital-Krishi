import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VegetableMarkets/addMarket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController mapController;

  String searchAddr;
  Set<Marker> markers;
  double longitude;
  double latitude;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  int prevPage;
  @override
  void initState() {
    super.initState();
    getLocation();
    markers = Set.from([]);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (latitude == null && longitude == null)
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitHourGlass(
                        color: Colors.green,
                        size: 50,
                      ),
                      Text(
                        "Locating You..",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude), zoom: 17.0),
                    markers: Set.from(markers),
                    myLocationButtonEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: onMapCreated,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    mapType: MapType.hybrid,
                    onTap: (position) {
                      Marker mk1 =
                          Marker(markerId: MarkerId('1'), position: position);
                      setState(() {
                        markers.add(mk1);
                      });
                    },
                  ),
                  Positioned(
                    top: 55.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              blurRadius: 1.0,
                            ),
                          ],
                          color: Colors.white),
                      child: TextFormField(
                        textInputAction: TextInputAction.search,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          searchandNavigate();
                        },
                        decoration: InputDecoration(
                            hintText: 'Search Places',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 15.0),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: searchandNavigate,
                                iconSize: 30.0)),
                        onChanged: (val) {
                          setState(() {
                            searchAddr = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(child: Icon(Icons.satellite))
                ],
              ),
      ),
      floatingActionButton: (latitude != null && longitude != null)
          ? Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.location_on),
                  label: Text("Set Location"),
                  onPressed: () {
                    if (markers.length < 1) {
                      print("No markers added");
                    } else {
                      print(markers.first.position);
                      Alert(
                        context: context,
                        style: AlertStyle(
                          isCloseButton: false,
                          isOverlayTapDismiss: true,
                          animationType: AnimationType.fromRight,
                          backgroundColor: Colors.white,
                          descStyle: TextStyle(
                            color: Colors.black,
                          ),
                          titleStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        type: AlertType.none,
                        title: "Pick This Location",
                        desc: "Confirm to pick this location",
                        buttons: [
                          DialogButton(
                            color: Colors.black12,
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            width: 120,
                          ),
                          DialogButton(
                            color: Colors.black26,
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: AddMarketDetails(
                                        locationCoords: LatLng(
                                            markers.first.position.latitude,
                                            markers.first.position.longitude),
                                      )));
                            },
                            width: 120,
                          ),
                        ],
                      ).show();
                    }
                  },
                ),
              ),
            )
          : Container(),
    );
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      try {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    result[0].position.latitude, result[0].position.longitude),
                zoom: 15.0)));
      } catch (e) {
        print(e.message);
        Fluttertoast.showToast(msg: "Couldn't Find the address");
      }
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
