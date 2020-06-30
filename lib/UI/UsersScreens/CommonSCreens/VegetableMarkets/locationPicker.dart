import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  PickResult selectedPlace;
  LatLng location;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      if (mounted)
        setState(() {
          location = LatLng(position.latitude, position.longitude);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: "AIzaSyAhAi_61SfvrPJVMN-3W9snEHqzmDO-PSw",
                          initialPosition: location,
                          useCurrentLocation: true,
                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          forceSearchOnZoomChanged: true,
                          automaticallyImplyAppBarLeading: false,
                          autocompleteLanguage: "ko",
                          region: 'au',
                          selectInitialPosition: true,
                          selectedPlaceWidgetBuilder:
                              (_, selectedPlace, state, isSearchBarFocused) {
                            print(
                                "state: $state, isSearchBarFocused: $isSearchBarFocused");
                            return isSearchBarFocused
                                ? Container()
                                : FloatingCard(
                                    bottomPosition:
                                        0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                    leftPosition: 0.0,
                                    rightPosition: 0.0,
                                    width: 500,
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: state == SearchingState.Searching
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : RaisedButton(
                                            child: Text("Pick Here"),
                                            onPressed: () {
                                              // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                              //            this will override default 'Select here' Button.
                                              print(
                                                  "do something with [selectedPlace] data");
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                  );
                          },
                          pinBuilder: (context, state) {
                            if (state == PinState.Idle) {
                              return Icon(Icons.favorite_border);
                            } else {
                              return Icon(Icons.favorite);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}
