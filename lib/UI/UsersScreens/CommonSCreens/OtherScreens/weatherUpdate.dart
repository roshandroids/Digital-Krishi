import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:darksky_weather/darksky_weather_io.dart';

class WeatherUpdate extends StatefulWidget {
  @override
  _WeatherUpdateState createState() => _WeatherUpdateState();
}

class _WeatherUpdateState extends State<WeatherUpdate> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  double latitude;
  double longitude;
  String summary;
  double precipIntensity;
  double precipProbability;
  String precipType;
  double temperature;

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
      var forecast =
          await darksky.getForecast(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          summary = forecast.currently.summary;
          precipIntensity = forecast.currently.precipIntensity;
          precipProbability = forecast.currently.precipProbability;
          precipType = forecast.currently.precipType;
          temperature = forecast.currently.temperature;
        });
      }
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
                  child: (summary != null)
                      ? Column(
                          children: <Widget>[
                            (Text(
                              summary,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Color.fromARGB(0xff, 32, 168, 74),
                              ),
                            )),
                            Text(precipType),
                            Text(precipIntensity.toString()),
                            Text(precipProbability.toString()),
                            Text(temperature.toString()),
                          ],
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
}
