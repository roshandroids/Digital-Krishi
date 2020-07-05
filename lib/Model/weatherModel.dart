// class WeatherModel {
//   double latitude;
//   double longitude;
//   String timezone;
//   Currently currently;
//   Minutely minutely;
//   Minutely hourly;
//   Minutely daily;
//   List<Alerts> alerts;
//   Flags flags;
//   int offset;

//   WeatherModel(
//       {this.latitude,
//       this.longitude,
//       this.timezone,
//       this.currently,
//       this.minutely,
//       this.hourly,
//       this.daily,
//       this.alerts,
//       this.flags,
//       this.offset});

//   WeatherModel.fromJson(Map<String, dynamic> json) {
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     timezone = json['timezone'];
//     currently = json['currently'] != null
//         ? new Currently.fromJson(json['currently'])
//         : null;
//     minutely = json['minutely'] != null
//         ? new Minutely.fromJson(json['minutely'])
//         : null;
//     hourly =
//         json['hourly'] != null ? new Minutely.fromJson(json['hourly']) : null;
//     daily = json['daily'] != null ? new Minutely.fromJson(json['daily']) : null;
//     if (json['alerts'] != null) {
//       alerts = new List<Alerts>();
//       json['alerts'].forEach((v) {
//         alerts.add(new Alerts.fromJson(v));
//       });
//     }
//     flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
//     offset = json['offset'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['timezone'] = this.timezone;
//     if (this.currently != null) {
//       data['currently'] = this.currently.toJson();
//     }
//     if (this.minutely != null) {
//       data['minutely'] = this.minutely.toJson();
//     }
//     if (this.hourly != null) {
//       data['hourly'] = this.hourly.toJson();
//     }
//     if (this.daily != null) {
//       data['daily'] = this.daily.toJson();
//     }
//     if (this.alerts != null) {
//       data['alerts'] = this.alerts.map((v) => v.toJson()).toList();
//     }
//     if (this.flags != null) {
//       data['flags'] = this.flags.toJson();
//     }
//     data['offset'] = this.offset;
//     return data;
//   }
// }

// class Currently {
//   int time;
//   String summary;
//   String icon;
//   int nearestStormDistance;
//   int nearestStormBearing;
//   int precipIntensity;
//   int precipProbability;
//   double temperature;
//   double apparentTemperature;
//   double dewPoint;
//   double humidity;
//   double pressure;
//   double windSpeed;
//   double windGust;
//   int windBearing;
//   double cloudCover;
//   int uvIndex;
//   int visibility;
//   double ozone;

//   Currently(
//       {this.time,
//       this.summary,
//       this.icon,
//       this.nearestStormDistance,
//       this.nearestStormBearing,
//       this.precipIntensity,
//       this.precipProbability,
//       this.temperature,
//       this.apparentTemperature,
//       this.dewPoint,
//       this.humidity,
//       this.pressure,
//       this.windSpeed,
//       this.windGust,
//       this.windBearing,
//       this.cloudCover,
//       this.uvIndex,
//       this.visibility,
//       this.ozone});

//   Currently.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     summary = json['summary'];
//     icon = json['icon'];
//     nearestStormDistance = json['nearestStormDistance'];
//     nearestStormBearing = json['nearestStormBearing'];
//     precipIntensity = json['precipIntensity'];
//     precipProbability = json['precipProbability'];
//     temperature = json['temperature'];
//     apparentTemperature = json['apparentTemperature'];
//     dewPoint = json['dewPoint'];
//     humidity = json['humidity'];
//     pressure = json['pressure'];
//     windSpeed = json['windSpeed'];
//     windGust = json['windGust'];
//     windBearing = json['windBearing'];
//     cloudCover = json['cloudCover'];
//     uvIndex = json['uvIndex'];
//     visibility = json['visibility'];
//     ozone = json['ozone'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['summary'] = this.summary;
//     data['icon'] = this.icon;
//     data['nearestStormDistance'] = this.nearestStormDistance;
//     data['nearestStormBearing'] = this.nearestStormBearing;
//     data['precipIntensity'] = this.precipIntensity;
//     data['precipProbability'] = this.precipProbability;
//     data['temperature'] = this.temperature;
//     data['apparentTemperature'] = this.apparentTemperature;
//     data['dewPoint'] = this.dewPoint;
//     data['humidity'] = this.humidity;
//     data['pressure'] = this.pressure;
//     data['windSpeed'] = this.windSpeed;
//     data['windGust'] = this.windGust;
//     data['windBearing'] = this.windBearing;
//     data['cloudCover'] = this.cloudCover;
//     data['uvIndex'] = this.uvIndex;
//     data['visibility'] = this.visibility;
//     data['ozone'] = this.ozone;
//     return data;
//   }
// }

// class Minutely {
//   String summary;
//   String icon;
//   List<Data> data;

//   Minutely({this.summary, this.icon, this.data});

//   Minutely.fromJson(Map<String, dynamic> json) {
//     summary = json['summary'];
//     icon = json['icon'];
//     if (json['data'] != null) {
//       data = new List<Data>();
//       json['data'].forEach((v) {
//         data.add(new Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['summary'] = this.summary;
//     data['icon'] = this.icon;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   int time;
//   int precipIntensity;
//   int precipProbability;

//   Data({this.time, this.precipIntensity, this.precipProbability});

//   Data.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     precipIntensity = json['precipIntensity'];
//     precipProbability = json['precipProbability'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['precipIntensity'] = this.precipIntensity;
//     data['precipProbability'] = this.precipProbability;
//     return data;
//   }
// }

// class Data {
//   int time;
//   String summary;
//   String icon;
//   double precipIntensity;
//   double precipProbability;
//   double temperature;
//   double apparentTemperature;
//   double dewPoint;
//   double humidity;
//   double pressure;
//   double windSpeed;
//   double windGust;
//   int windBearing;
//   double cloudCover;
//   int uvIndex;
//   int visibility;
//   double ozone;
//   String precipType;

//   Data(
//       {this.time,
//       this.summary,
//       this.icon,
//       this.precipIntensity,
//       this.precipProbability,
//       this.temperature,
//       this.apparentTemperature,
//       this.dewPoint,
//       this.humidity,
//       this.pressure,
//       this.windSpeed,
//       this.windGust,
//       this.windBearing,
//       this.cloudCover,
//       this.uvIndex,
//       this.visibility,
//       this.ozone,
//       this.precipType});

//   Data.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     summary = json['summary'];
//     icon = json['icon'];
//     precipIntensity = json['precipIntensity'];
//     precipProbability = json['precipProbability'];
//     temperature = json['temperature'];
//     apparentTemperature = json['apparentTemperature'];
//     dewPoint = json['dewPoint'];
//     humidity = json['humidity'];
//     pressure = json['pressure'];
//     windSpeed = json['windSpeed'];
//     windGust = json['windGust'];
//     windBearing = json['windBearing'];
//     cloudCover = json['cloudCover'];
//     uvIndex = json['uvIndex'];
//     visibility = json['visibility'];
//     ozone = json['ozone'];
//     precipType = json['precipType'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['summary'] = this.summary;
//     data['icon'] = this.icon;
//     data['precipIntensity'] = this.precipIntensity;
//     data['precipProbability'] = this.precipProbability;
//     data['temperature'] = this.temperature;
//     data['apparentTemperature'] = this.apparentTemperature;
//     data['dewPoint'] = this.dewPoint;
//     data['humidity'] = this.humidity;
//     data['pressure'] = this.pressure;
//     data['windSpeed'] = this.windSpeed;
//     data['windGust'] = this.windGust;
//     data['windBearing'] = this.windBearing;
//     data['cloudCover'] = this.cloudCover;
//     data['uvIndex'] = this.uvIndex;
//     data['visibility'] = this.visibility;
//     data['ozone'] = this.ozone;
//     data['precipType'] = this.precipType;
//     return data;
//   }
// }

// class Data {
//   int time;
//   String summary;
//   String icon;
//   int sunriseTime;
//   int sunsetTime;
//   double moonPhase;
//   double precipIntensity;
//   double precipIntensityMax;
//   int precipIntensityMaxTime;
//   double precipProbability;
//   String precipType;
//   double temperatureHigh;
//   int temperatureHighTime;
//   double temperatureLow;
//   int temperatureLowTime;
//   double apparentTemperatureHigh;
//   int apparentTemperatureHighTime;
//   double apparentTemperatureLow;
//   int apparentTemperatureLowTime;
//   double dewPoint;
//   double humidity;
//   double pressure;
//   double windSpeed;
//   double windGust;
//   int windGustTime;
//   int windBearing;
//   double cloudCover;
//   int uvIndex;
//   int uvIndexTime;
//   int visibility;
//   double ozone;
//   double temperatureMin;
//   int temperatureMinTime;
//   double temperatureMax;
//   int temperatureMaxTime;
//   double apparentTemperatureMin;
//   int apparentTemperatureMinTime;
//   double apparentTemperatureMax;
//   int apparentTemperatureMaxTime;

//   Data(
//       {this.time,
//       this.summary,
//       this.icon,
//       this.sunriseTime,
//       this.sunsetTime,
//       this.moonPhase,
//       this.precipIntensity,
//       this.precipIntensityMax,
//       this.precipIntensityMaxTime,
//       this.precipProbability,
//       this.precipType,
//       this.temperatureHigh,
//       this.temperatureHighTime,
//       this.temperatureLow,
//       this.temperatureLowTime,
//       this.apparentTemperatureHigh,
//       this.apparentTemperatureHighTime,
//       this.apparentTemperatureLow,
//       this.apparentTemperatureLowTime,
//       this.dewPoint,
//       this.humidity,
//       this.pressure,
//       this.windSpeed,
//       this.windGust,
//       this.windGustTime,
//       this.windBearing,
//       this.cloudCover,
//       this.uvIndex,
//       this.uvIndexTime,
//       this.visibility,
//       this.ozone,
//       this.temperatureMin,
//       this.temperatureMinTime,
//       this.temperatureMax,
//       this.temperatureMaxTime,
//       this.apparentTemperatureMin,
//       this.apparentTemperatureMinTime,
//       this.apparentTemperatureMax,
//       this.apparentTemperatureMaxTime});

//   Data.fromJson(Map<String, dynamic> json) {
//     time = json['time'];
//     summary = json['summary'];
//     icon = json['icon'];
//     sunriseTime = json['sunriseTime'];
//     sunsetTime = json['sunsetTime'];
//     moonPhase = json['moonPhase'];
//     precipIntensity = json['precipIntensity'];
//     precipIntensityMax = json['precipIntensityMax'];
//     precipIntensityMaxTime = json['precipIntensityMaxTime'];
//     precipProbability = json['precipProbability'];
//     precipType = json['precipType'];
//     temperatureHigh = json['temperatureHigh'];
//     temperatureHighTime = json['temperatureHighTime'];
//     temperatureLow = json['temperatureLow'];
//     temperatureLowTime = json['temperatureLowTime'];
//     apparentTemperatureHigh = json['apparentTemperatureHigh'];
//     apparentTemperatureHighTime = json['apparentTemperatureHighTime'];
//     apparentTemperatureLow = json['apparentTemperatureLow'];
//     apparentTemperatureLowTime = json['apparentTemperatureLowTime'];
//     dewPoint = json['dewPoint'];
//     humidity = json['humidity'];
//     pressure = json['pressure'];
//     windSpeed = json['windSpeed'];
//     windGust = json['windGust'];
//     windGustTime = json['windGustTime'];
//     windBearing = json['windBearing'];
//     cloudCover = json['cloudCover'];
//     uvIndex = json['uvIndex'];
//     uvIndexTime = json['uvIndexTime'];
//     visibility = json['visibility'];
//     ozone = json['ozone'];
//     temperatureMin = json['temperatureMin'];
//     temperatureMinTime = json['temperatureMinTime'];
//     temperatureMax = json['temperatureMax'];
//     temperatureMaxTime = json['temperatureMaxTime'];
//     apparentTemperatureMin = json['apparentTemperatureMin'];
//     apparentTemperatureMinTime = json['apparentTemperatureMinTime'];
//     apparentTemperatureMax = json['apparentTemperatureMax'];
//     apparentTemperatureMaxTime = json['apparentTemperatureMaxTime'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['time'] = this.time;
//     data['summary'] = this.summary;
//     data['icon'] = this.icon;
//     data['sunriseTime'] = this.sunriseTime;
//     data['sunsetTime'] = this.sunsetTime;
//     data['moonPhase'] = this.moonPhase;
//     data['precipIntensity'] = this.precipIntensity;
//     data['precipIntensityMax'] = this.precipIntensityMax;
//     data['precipIntensityMaxTime'] = this.precipIntensityMaxTime;
//     data['precipProbability'] = this.precipProbability;
//     data['precipType'] = this.precipType;
//     data['temperatureHigh'] = this.temperatureHigh;
//     data['temperatureHighTime'] = this.temperatureHighTime;
//     data['temperatureLow'] = this.temperatureLow;
//     data['temperatureLowTime'] = this.temperatureLowTime;
//     data['apparentTemperatureHigh'] = this.apparentTemperatureHigh;
//     data['apparentTemperatureHighTime'] = this.apparentTemperatureHighTime;
//     data['apparentTemperatureLow'] = this.apparentTemperatureLow;
//     data['apparentTemperatureLowTime'] = this.apparentTemperatureLowTime;
//     data['dewPoint'] = this.dewPoint;
//     data['humidity'] = this.humidity;
//     data['pressure'] = this.pressure;
//     data['windSpeed'] = this.windSpeed;
//     data['windGust'] = this.windGust;
//     data['windGustTime'] = this.windGustTime;
//     data['windBearing'] = this.windBearing;
//     data['cloudCover'] = this.cloudCover;
//     data['uvIndex'] = this.uvIndex;
//     data['uvIndexTime'] = this.uvIndexTime;
//     data['visibility'] = this.visibility;
//     data['ozone'] = this.ozone;
//     data['temperatureMin'] = this.temperatureMin;
//     data['temperatureMinTime'] = this.temperatureMinTime;
//     data['temperatureMax'] = this.temperatureMax;
//     data['temperatureMaxTime'] = this.temperatureMaxTime;
//     data['apparentTemperatureMin'] = this.apparentTemperatureMin;
//     data['apparentTemperatureMinTime'] = this.apparentTemperatureMinTime;
//     data['apparentTemperatureMax'] = this.apparentTemperatureMax;
//     data['apparentTemperatureMaxTime'] = this.apparentTemperatureMaxTime;
//     return data;
//   }
// }

// class Alerts {
//   String title;
//   List<String> regions;
//   String severity;
//   int time;
//   int expires;
//   String description;
//   String uri;

//   Alerts(
//       {this.title,
//       this.regions,
//       this.severity,
//       this.time,
//       this.expires,
//       this.description,
//       this.uri});

//   Alerts.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     regions = json['regions'].cast<String>();
//     severity = json['severity'];
//     time = json['time'];
//     expires = json['expires'];
//     description = json['description'];
//     uri = json['uri'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['regions'] = this.regions;
//     data['severity'] = this.severity;
//     data['time'] = this.time;
//     data['expires'] = this.expires;
//     data['description'] = this.description;
//     data['uri'] = this.uri;
//     return data;
//   }
// }

// class Flags {
//   List<String> sources;
//   double nearestStation;
//   String units;

//   Flags({this.sources, this.nearestStation, this.units});

//   Flags.fromJson(Map<String, dynamic> json) {
//     sources = json['sources'].cast<String>();
//     nearestStation = json['nearest-station'];
//     units = json['units'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sources'] = this.sources;
//     data['nearest-station'] = this.nearestStation;
//     data['units'] = this.units;
//     return data;
//   }
// }
