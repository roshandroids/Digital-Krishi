import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:darksky_weather/darksky_weather_io.dart';

class WeatherUpdate extends StatefulWidget {
  @override
  _WeatherUpdateState createState() => _WeatherUpdateState();
}

class _WeatherUpdateState extends State<WeatherUpdate> {
  String summary;
  String currentSummary;
  String icon;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

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
      var forecast =
          await darksky.getForecast(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          summary = forecast.daily.summary;
          currentSummary = forecast.currently.time.toString();

          icon = forecast.daily.icon;
        });
      }

      print(position.longitude);
      print(position.latitude);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0xff, 32, 168, 74),
        centerTitle: true,
        title: Text("Today's Weather Update"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: (summary != null && currentSummary != null)
            ? Container(
                child: Column(
                  children: <Widget>[
                    (Text(
                      summary,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(0xff, 32, 168, 74),
                      ),
                    )),
                    Container(
                      child: Text(currentSummary),
                    )
                  ],
                ),
              )
            : Container(
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 6,
                  ),
                ),
              ),
      ),
    );
  }
}
