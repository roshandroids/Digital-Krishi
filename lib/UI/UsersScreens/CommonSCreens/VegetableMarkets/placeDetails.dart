import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shimmer/shimmer.dart';

class PlaceDetails extends StatefulWidget {
  final String shopName;
  final String description;
  final String thumbNail;
  final LatLng locationCoords;

  PlaceDetails(
      {@required this.shopName,
      @required this.description,
      @required this.thumbNail,
      @required this.locationCoords});
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  String country;
  String postalCode;
  String locality;
  @override
  void initState() {
    convert();
    super.initState();
  }

  void convert() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        widget.locationCoords.latitude, widget.locationCoords.longitude);
    if (mounted)
      setState(() {
        country = placemark[0].country;
        postalCode = placemark[0].postalCode;
        locality = placemark[0].locality;
      });
  }

  launchMap() async {
    MapsLauncher.launchCoordinates(
      widget.locationCoords.latitude,
      widget.locationCoords.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              leading: Container(),
              floating: true,
              pinned: false,
              stretch: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.thumbNail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SpinKitWave(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  )),
            ),
          ];
        },
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.shopName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  (country == null && locality == null && postalCode == null)
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.grey[100],
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            Text(
                              country + ", " + locality + "($postalCode)",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      widget.description,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () => launchMap(),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(width: .5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Image.asset(
                                    'lib/Assets/Images/navigation.png')),
                            Text(
                              "Get Direction",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 20,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
        ),
      ),
    );
  }
}
