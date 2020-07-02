import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewHtml extends StatefulWidget {
  ViewHtml(html);

  @override
  _ViewHtmlState createState() => _ViewHtmlState();
}

class _ViewHtmlState extends State<ViewHtml> {
  File file;
  Directory directory;
  String text;

  @override
  void initState() {
    super.initState();
    _read();
  }

  Future<String> _read() async {
    try {
      directory = await getApplicationDocumentsDirectory();
      file = File('${directory.path}/result.html');
      text = await file.readAsString();
      print("URRRRRLLLL:" + directory.path);
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  Future<String> loadLocal() async {
    return await rootBundle.loadString('assets/yourFile.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FutureBuilder<String>(
        future: _read(), // async work
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading....');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return WebView(
                  initialUrl: new Uri.dataFromString(snapshot.data,
                          mimeType: 'text/html')
                      .toString(),
                  javascriptMode: JavascriptMode.unrestricted,
                );
          }
        },
      ),
    ));
  }
}

class TestCalculate extends StatefulWidget {
  @override
  _TestCalculateState createState() => _TestCalculateState();
}

class _TestCalculateState extends State<TestCalculate> {
  String categoryValue = 'None';
  String cropValue = "";
  List<Map> optionArray = [];
  List<crop> testCrop = [crop(name: "none", value: "none")];

  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/result.html');
    String test =
        text.substring(0, text.indexOf("<h3 class='ml-4 text-success'>"));
    await file.writeAsString(test);
  }

  void getHttp() async {
    Map body = {
      "fertcat": categoryValue,
      "crops": cropValue,
      "num": "100",
      "area": "hector"
    };
    try {
      var res = await http.post(
          "https://agritechnepal.com/calc/fertilizer/post.php",
          body: body,
          headers: {
            'Connection': 'keep-alive',
            'Cache-Control': 'max-age=0',
            'Origin': 'https://agritechnepal.com',
            'Upgrade-Insecure-Requests': '1',
            'DNT': '1',
            'Content-Type': 'application/x-www-form-urlencoded',
            'User-Agent': 'okhttp',
            'Accept-Encoding': 'gzip',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'Sec-Fetch-Site': 'same-origin',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-User': '?1',
            'Sec-Fetch-Dest': 'document',
            'Referer': 'https://agritechnepal.com/calc/fertilizer/',
            'Accept-Language': 'en-US,en;q=0.9',
            'Cookie':
                '_ga=GA1.2.71954696.1592902859; __atssc=google%3B2; __atuvc=16%7C26'
          });
      if (res.statusCode == 200) {
        String htmlToParse = res.body;
        _write(htmlToParse);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ViewHtml(htmlToParse)));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: categoryValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  categoryValue = newValue;
                });
                print(newValue.toLowerCase());
                cropSector(newValue.toLowerCase());
              },
              items: <String>[
                'None',
                'Vegetable',
                'Fruits',
                'Flower',
                'Cereal',
                'Legume',
                'Oilseed',
                'Cash'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton(
              value: testCrop[0],
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (crop newValue) {
                setState(() {
                  cropValue = newValue.value;
                });
              },
              items: testCrop.map((crop value) {
                return new DropdownMenuItem(
                    value: value, child: Text(value.name));
              }).toList(),
            ),
            RaisedButton(
              onPressed: () {
                getHttp();
              },
              child: Text("Test"),
            ),
          ],
        ),
      ),
    );
  }

  void cropSector(String category) {
    if (category == "vegetable") {
      setState(() {
        optionArray = [
          {"name": "Tomato", "value": "tomato"},
          {"name": "Brinjal", "value": "brinjal"},
          {"name": "Chilly", "value": "chilly"},
          {"name": "Cabbage", "value": "cabbage"},
          {"name": "Capsicum", "value": "capsicum"},
          {"name": "Potato", "value": "potato"},
          {"name": "Cauliflower", "value": "cauli"},
          {"name": "Broccoli", "value": "broccoli"},
          {"name": "Kohlrabi", "value": "kohlrabi"},
          {"name": "Brussel sprouts", "value": "brussel"},
          {"name": "Radish", "value": "radish"},
          {"name": "Carrot", "value": "carrot"},
          {"name": "Turnip", "value": "turnip"},
          {"name": "Beetroot", "value": "beetroot"},
          {"name": "Onion", "value": "onion"},
          {"name": "Garlic", "value": "garlic"},
          {"name": "Pea", "value": "pea_vg"},
          {"name": "Beans", "value": "beans"},
          {"name": "Broad bean", "value": "broadbean"},
          {"name": "Hyacinth/dolichus bean", "value": "hyacinth"},
          {"name": "Cowpea", "value": "cowpea"},
          {"name": "Okra (Bhindi)", "value": "orka"},
          {"name": "Cucumber", "value": "cucumber"},
          {"name": "Ridge gourd", "value": "ridgegourd"},
          {"name": "SpongeGourd", "value": "spongegourd"},
          {"name": "BitterGourd", "value": "bittergourd"},
          {"name": "SnakeGourd", "value": "snakegourd"},
          {"name": "BottleGourd", "value": "bottlegourd"},
          {"name": "AshGourd", "value": "ashgourd"},
          {"name": "Squash", "value": "squash"},
          {"name": "Pumpkin", "value": "pumpkin"},
          {"name": "MuskMelon", "value": "muskmelon"},
          {"name": "WaterMelon", "value": "watermelon"},
          {"name": "LongMelon", "value": "longmelon"},
          {"name": "Pointed gourd", "value": "pointed"},
          {"name": "IvyGourd", "value": "ivygourd"},
          {"name": "Broad leaved mustard", "value": "broadleavedmustard"},
          {"name": "Cress", "value": "cress"},
          {"name": "Spinach", "value": "spinach"},
          {"name": "Swiss chard", "value": "swisschard"},
          {"name": "Fenugreek", "value": "fenugreek"},
          {"name": "Amaranthus", "value": "amaranthus"},
          {"name": "Lettuce", "value": "lettuce"},
          {"name": "Celery", "value": "celery"},
          {"name": "Coriander", "value": "coriander"},
          {"name": "Cumin", "value": "cumin"},
          {"name": "Fennel", "value": "fennel"},
          {"name": "Ginger", "value": "ginger"},
          {"name": "Turmeric", "value": "tumeric"},
          {"name": "Yam", "value": "yam"},
          {"name": "Cassava (Tapioca)", "value": "cassava"},
          {"name": "Sweet potato", "value": "sweetpotato"},
          {"name": "Colocasia/taro", "value": "colocasia"},
          {"name": "Elephant foot yam", "value": "elephantfootyam"},
          {"name": "Asparagus (kurilo)", "value": "aspargus"},
          {"name": "Drumstick", "value": "drumstick"},
        ];
      });
    } else if (category == "fruits") {
      setState(() {
        optionArray = [
          {"name": "Mango", "value": "mango"},
          {"name": "Mandarian", "value": "mandarin"},
          {"name": "SweetOrange", "value": "sweetorange"},
          {"name": "Lemon", "value": "lemon"},
          {"name": "Lime", "value": "lime"},
          {"name": "Banana", "value": "banana"},
          {"name": "Papaya", "value": "papaya"},
          {"name": "Pineapple", "value": "pineapple"},
          {"name": "Jackfruit", "value": "jackfruit"},
          {"name": "Guava", "value": "gauva"},
          {"name": "Litchi", "value": "litchi"},
          {"name": "Grapes", "value": "grapes"},
          {"name": "Apple", "value": "apple"},
          {"name": "Pear", "value": "pear"},
          {"name": "Peach", "value": "peach"},
          {"name": "Kiwi", "value": "kiwi"},
          {"name": "Plum", "value": "plum"},
          {"name": "Dragon fruit", "value": "dragonfruit"},
          {"name": "Strawberry", "value": "strawberry"},
          {"name": "Pomegranate", "value": "pomegranate"},
        ];
      });
    } else if (category == "flower") {
      setState(() {
        testCrop = [
          crop(name: "Gladiolus", value: "gladiolus"),
          crop(name: "Rose", value: "rose"),
          crop(name: "Orchid", value: "orchid"),
          crop(name: "Tuberose", value: "tuberose"),
          crop(name: "Chrysanthemum", value: "chrysanthemum"),
          crop(name: "Anthurium", value: "anthurium"),
          crop(name: "Gerbera", value: "gerbera"),
          crop(name: "Carnation", value: "carnation"),
          crop(name: "Marigold", value: "marigold"),
          crop(name: "Bird of paradise", value: "birdofparadise"),
          crop(name: "Dahlia", value: "dahlia"),
        ];
      });
    } else if (category == "cereal") {
      setState(() {
        testCrop = [
          crop(name: "Hybrid Rice", value: "rice_hybrid"),
          crop(name: "Local Rice", value: "rice_local"),
          crop(name: "Hybrid Maize", value: "maize_hybrid"),
          crop(name: "Local Maize", value: "maize_local"),
          crop(name: "Irrigated Wheat", value: "wheat_irrigated"),
          crop(name: "Rainfed Wheat", value: "wheat_rainfed"),
          crop(name: "BuckWheat", value: "buckwheat"),
          crop(name: "Irrigated Barley", value: "barley_irrigated"),
          crop(name: "Rainfed Barley", value: "barley_rainfed"),
          crop(name: "Millet", value: "millet"),
        ];
      });
    } else if (category == "legume") {
      setState(() {
        testCrop = [
          crop(name: "Lentil", value: "lentil"),
          crop(name: "ChickPea", value: "chickpea"),
          crop(name: "PigeonPea", value: "pigeonpea"),
          crop(name: "BlackGram", value: "blackgram"),
          crop(name: "GreenGram", value: "greengram"),
          crop(name: "SoyBean", value: "soybean"),
          crop(name: "Pea", value: "pea_grain"),
          crop(name: "CowPea", value: "cowpea"),
          crop(name: "HorseGram", value: "horsegram"),
        ];
      });
    } else if (category == "oilseed") {
      setState(() {
        testCrop = [
          crop(name: "Mustard", value: "horsegram"),
          crop(name: "Rapeseed", value: "horsegram"),
          crop(name: "Irrigated Sunflower", value: "horsegram"),
          crop(name: "Rainfed Sunflower", value: "horsegram"),
          crop(name: "Sesamum", value: "horsegram"),
          crop(name: "Groundnut", value: "horsegram"),
          crop(name: "Safflower", value: "horsegram"),
          crop(name: "Castor", value: "horsegram"),
          crop(name: "Niger", value: "horsegram"),
        ];
      });
    } else if (category == "cashcrop") {
      setState(() {
        optionArray = [
          {"name": "Cotton", "value": "cotton"},
          {"name": "Sugarcane", "value": "sugarcane"},
          {"name": "Capsularis Jute", "value": "jute_capsularis"},
          {"name": "Olitorius Jute", "value": "jute_olitorius"},
          {"name": "Virginia Tobacco", "value": "tobacco_virginia"},
          {
            "name": "Natu & Belachapi Tobacco",
            "value": "tobacco_natu_belachapi"
          },
          {"name": "Tea", "value": "tea"},
          {"name": "Coffee", "value": "cofee"},
          {"name": "Cardamom", "value": "cardamon"},
        ];
      });
    } else {
      setState(() {
        optionArray = [];
      });
    }
  }
}

class crop {
  final String name;
  final String value;

  const crop({this.name, this.value});
}
