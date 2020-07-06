import 'package:flutter/material.dart';

class WeatherDetails extends StatefulWidget {
  final int time;
  final String summary;
  final String icon;
  final double precipIntensity;
  final double precipProbability;
  final String precipType;
  final double temperature;

  final double dewPoint;
  final double humidity;
  final double pressure;
  final double windSpeed;

  final double windBearing;
  final double cloudCover;

  final double visibility;
  final double ozone;
  WeatherDetails({
    @required this.time,
    @required this.summary,
    @required this.icon,
    @required this.precipIntensity,
    @required this.precipProbability,
    @required this.precipType,
    @required this.temperature,
    @required this.dewPoint,
    @required this.humidity,
    @required this.pressure,
    @required this.windBearing,
    @required this.windSpeed,
    @required this.cloudCover,
    @required this.visibility,
    @required this.ozone,
  });

  @override
  _WeatherDetailsState createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  @override
  Widget build(BuildContext context) {
    var date = new DateTime.fromMillisecondsSinceEpoch(widget.time * 1000);
    var formatDate =
        "${date.year}-${date.month}-${date.day} , ${date.hour} : ${date.minute}";
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
        title: Text("Today's Weather Details"),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(10),
          child: Container(
            // padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), blurRadius: 1)
                ]),
            child: Table(
              children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date & Time",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Summary",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Forecast",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "PrecipIntensity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "PrecipProbability",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "PrecipType",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Temperature",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "DewPoint",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Humidity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Pressure",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "WindSpeed",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "WindBearing",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "CloudCover",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Visibility",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          "Ozone",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          formatDate,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.summary,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Image.asset(
                          "lib/Assets/Images/${widget.icon}.png",
                          height: 23,
                          width: 23,
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.precipIntensity.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.precipProbability.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.precipType,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.temperature.toString() + " °C",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.dewPoint.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.humidity.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.pressure.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.windSpeed.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.windBearing.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.cloudCover.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.visibility.toString() + " KM",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                        Text(
                          widget.ozone.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Divider(
                          thickness: .5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}