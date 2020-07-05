import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:url_launcher/url_launcher.dart';

class WeatherUpdate extends StatefulWidget {
  @override
  _WeatherUpdateState createState() => _WeatherUpdateState();
}

class _WeatherUpdateState extends State<WeatherUpdate> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Forecast forecast = Forecast();
  List<Placemark> placemark = [];
  double latitude;
  double longitude;
  @override
  void initState() {
    super.initState();
    getUpdate();
  }

  Future<Null> getUpdate() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      var darksky = new DarkSkyWeather("8eb70902f8f40ca4f75ee81a195db877",
          language: Language.English, units: Units.SI);
      forecast =
          await darksky.getForecast(position.latitude, position.longitude);
      placemark = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      // if (mounted) {
      //   setState(() {
      //     longitude = position.longitude;
      //     latitude = position.latitude;
      //     summary = forecast.currently.summary;
      //     precipIntensity = forecast.currently.precipIntensity;
      //     precipProbability = forecast.currently.precipProbability;
      //     precipType = forecast.currently.precipType;
      //     temperature = forecast.currently.temperature;
      //     country = placemark[0].country;
      //     postalCode = placemark[0].postalCode;
      //     locality = placemark[0].locality;
      //     dailyWeather = forecast.daily;
      //   });
      // }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        centerTitle: true,
        title: Text("Today's Weather Update"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          bool connected = connectivity != ConnectivityResult.none;
          return connected
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: (forecast.currently != null)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          blurRadius: 1)
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Text("You are Currently at " +
                                        placemark[0].locality),
                                    Text(placemark[0].country +
                                        " " +
                                        placemark[0].postalCode),
                                    IconButton(
                                        icon: Icon(
                                          Icons.navigation,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          launchMap(latitude, longitude);
                                        })
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        "Current Temperature : ${forecast.currently.temperature} degree celcius"),
                                    Text(
                                        "Precipitation Intensity ${forecast.currently.precipIntensity}"),
                                    // Text(
                                    //     "Precipitation Probalility $precipProbability"),
                                    // Text("Precipitation Type $precipType"),
                                    // Text("Daily " + dailyWeather.summary)

                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: forecast.daily.data.length,
                                        itemBuilder: (c, i) {
                                          DailyDataPoint daily =
                                              forecast.daily.data[i];
                                          return ListTile(
                                            title: Text(daily.summary),
                                          );
                                        })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Fetching WeatherData !"),
                            SpinKitWave(
                              color: Colors.blue,
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

  void launchMap(double latitude, double longitude) async {
    var mapSchema = 'geo:$latitude,$longitude';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }
}
