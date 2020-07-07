import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/WeatherScreens/weatherDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:darksky_weather/darksky_weather_io.dart';
import 'package:page_transition/page_transition.dart';
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
  var formattedDate;

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
      var date = new DateTime.fromMillisecondsSinceEpoch(
          forecast.currently.time * 1000);
      formattedDate = "${date.year}-${date.month}-${date.day}";

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        print(latitude);
        print(longitude);
      });
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
                                margin: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Text(
                                  "Current Weather Data At Your Location",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                              Text(
                                                placemark[0].locality +
                                                    ", " +
                                                    placemark[0].country,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      "lib/Assets/Images/${forecast.currently.icon}.png",
                                      height: 60,
                                      width: 60,
                                    ),
                                    Text(forecast.currently.icon),
                                    Row(
                                      children: <Widget>[
                                        Text("Summary : "),
                                        Text(
                                          forecast.currently.summary,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.temperatureHigh,
                                              size: 20,
                                              color: Colors.redAccent,
                                            ),
                                            Text(
                                              forecast.currently.temperature
                                                      .toString() +
                                                  " °C",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  child: WeatherDetails(
                                                    precipIntensity: forecast
                                                        .currently
                                                        .precipIntensity,
                                                    ozone: forecast
                                                        .currently.ozone,
                                                    icon:
                                                        forecast.currently.icon,
                                                    humidity: forecast
                                                        .currently.humidity,
                                                    dewPoint: forecast
                                                        .currently.dewPoint,
                                                    summary: forecast
                                                        .currently.summary,
                                                    pressure: forecast
                                                        .currently.pressure,
                                                    precipType: forecast
                                                        .currently.precipType,
                                                    precipProbability: forecast
                                                        .currently
                                                        .precipProbability,
                                                    cloudCover: forecast
                                                        .currently.cloudCover,
                                                    windSpeed: forecast
                                                        .currently.windSpeed,
                                                    windBearing: forecast
                                                        .currently.windBearing,
                                                    visibility: forecast
                                                        .currently.visibility,
                                                    time:
                                                        forecast.currently.time,
                                                    temperature: forecast
                                                        .currently.temperature,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "View Details..",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.center,
                                child: Text(
                                  "Weather Forest For Next 8 Days At Your location",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: forecast.daily.data.length,
                                    itemBuilder: (c, i) {
                                      DailyDataPoint daily =
                                          forecast.daily.data[i];
                                      var date = new DateTime
                                              .fromMillisecondsSinceEpoch(
                                          daily.time * 1000);
                                      var formatDate =
                                          "${date.year}-${date.month}-${date.day}";

                                      return Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.5),
                                                  blurRadius: 1)
                                            ]),
                                        child: ListTile(
                                          leading: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: Image.asset(
                                                  "lib/Assets/Images/${forecast.daily.icon}.png",
                                                  height: 60,
                                                  width: 60,
                                                ),
                                              ),
                                              Text(forecast.daily.icon)
                                            ],
                                          ),
                                          title: Text(
                                            forecast.daily.summary,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  placemark[0].locality +
                                                      ", " +
                                                      placemark[0].country,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Text(
                                            formatDate,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    }),
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
