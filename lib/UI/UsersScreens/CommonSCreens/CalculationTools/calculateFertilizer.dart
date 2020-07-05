import 'dart:io';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/CalculationTools/calculationResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CalculateFertilizer extends StatefulWidget {
  @override
  _CalculateFertilizerState createState() => _CalculateFertilizerState();
}

class _CalculateFertilizerState extends State<CalculateFertilizer> {
  String categoryValue = 'None';
  Crop cropValue = Crop(name: "none", value: "none");
  bool isCalculating = false;
  List<Crop> optionArray = [Crop(name: "none", value: "none")];
  TextEditingController areaController = TextEditingController();
  Unit selectedCategory;
  int area = 0;
  List<Unit> units = <Unit>[
    const Unit(
      'hector',
    ),
    const Unit(
      'acre',
    ),
    const Unit(
      'ropani',
    ),
    const Unit(
      'kattha',
    ),
    const Unit(
      'bigha',
    ),
    const Unit(
      'squaremetre',
    ),
  ];
  _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/result.html');
    String test =
        text.substring(0, text.indexOf("<h3 class='ml-4 text-success'>"));
    await file.writeAsString(test);
  }

  void check() {
    if (areaController.text.isNotEmpty &&
        categoryValue != "None" &&
        cropValue != Crop(name: "none", value: "none") &&
        selectedCategory.name != "none") {
      getHttp();
    } else {
      print("Error");
      Fluttertoast.showToast(msg: "Please Fill All Fields");
    }
  }

  void getHttp() async {
    setState(() {
      isCalculating = true;
    });
    Map body = {
      "fertcat": categoryValue.toLowerCase(),
      "crops": cropValue.value,
      "num": areaController.text.trim(),
      "area": selectedCategory.name
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
        setState(() {
          isCalculating = false;
          // categoryValue = "None";
          // cropValue = Crop(name: "none", value: "none");
          // areaController.clear();
        });
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ViewResult(htmlToParse)));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calculate Fertilizer Required"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            }),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Choose Category",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<String>(
                              value: categoryValue,
                              elevation: 16,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  categoryValue = newValue;
                                });

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
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Choose Crops",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<Crop>(
                              // value: cropValue,
                              hint: Text(
                                cropValue.name,
                                style: TextStyle(color: Colors.black),
                              ),
                              elevation: 16,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (Crop newValue) {
                                setState(() {
                                  cropValue = Crop(
                                      name: newValue.name,
                                      value: newValue.value);
                                });
                                print(cropValue.name);
                              },
                              items: optionArray.map((Crop value) {
                                return new DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ));
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Choose Area unit",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<Unit>(
                              hint: Text(
                                "None",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              value: selectedCategory,
                              onChanged: (Unit value) {
                                setState(() {
                                  selectedCategory = value;
                                  print(value.name);
                                });
                              },
                              items: units.map((Unit user) {
                                return DropdownMenuItem<Unit>(
                                  value: user,
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Enter Area",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: areaController,
                                onSaved: (value) {
                                  setState(() {
                                    area = int.parse(value);
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Enter the land area"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        check();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Calculate",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            (isCalculating)
                ? Container(
                    color: Colors.black.withOpacity(.5),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitHourGlass(
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          "Calculating..",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void cropSector(String category) {
    if (category == "vegetable") {
      setState(() {
        optionArray = [
          Crop(name: "Tomato", value: "tomato"),
          Crop(name: "Brinjal", value: "brinjal"),
          Crop(name: "Chilly", value: "chilly"),
          Crop(name: "Cabbage", value: "cabbage"),
          Crop(name: "Capsicum", value: "capsicum"),
          Crop(name: "Potato", value: "potato"),
          Crop(name: "Cauliflower", value: "cauli"),
          Crop(name: "Broccoli", value: "broccoli"),
          Crop(name: "Kohlrabi", value: "kohlrabi"),
          Crop(name: "Brussel", value: "brussel"),
          Crop(name: "Radish", value: "radish"),
          Crop(name: "Carrot", value: "carrot"),
          Crop(name: "Turnip", value: "turnip"),
          Crop(name: "Beetroot", value: "beetroot"),
          Crop(name: "Onion", value: "onion"),
          Crop(name: "Garlic", value: "garlic"),
          Crop(name: "Pea", value: "pea_vg"),
          Crop(name: "Beans", value: "beans"),
          Crop(name: "Broad bean", value: "broadbean"),
          Crop(name: "Hyacinth", value: "hyacinth"),
          Crop(name: "Cowpea", value: "cowpea"),
          Crop(name: "Okra (Bhindi)", value: "orka"),
          Crop(name: "Cucumber", value: "cucumber"),
          Crop(name: "Ridge gourd", value: "ridgegourd"),
          Crop(name: "SpongeGourd", value: "spongegourd"),
          Crop(name: "BitterGourd", value: "bittergourd"),
          Crop(name: "SnakeGourd", value: "snakegourd"),
          Crop(name: "BottleGourd", value: "bottlegourd"),
          Crop(name: "AshGourd", value: "ashgourd"),
          Crop(name: "Squash", value: "squash"),
          Crop(name: "Pumpkin", value: "pumpkin"),
          Crop(name: "MuskMelon", value: "muskmelon"),
          Crop(name: "WaterMelon", value: "watermelon"),
          Crop(name: "LongMelon", value: "longmelon"),
          Crop(name: "Pointed gourd", value: "pointed"),
          Crop(name: "IvyGourd", value: "ivygourd"),
          Crop(name: "Broad", value: "broadleavedmustard"),
          Crop(name: "Cress", value: "cress"),
          Crop(name: "Spinach", value: "spinach"),
          Crop(name: "Swiss chard", value: "swisschard"),
          Crop(name: "Fenugreek", value: "fenugreek"),
          Crop(name: "Amaranthus", value: "amaranthus"),
          Crop(name: "Lettuce", value: "lettuce"),
          Crop(name: "Celery", value: "celery"),
          Crop(name: "Coriander", value: "coriander"),
          Crop(name: "Cumin", value: "cumin"),
          Crop(name: "Fennel", value: "fennel"),
          Crop(name: "Ginger", value: "ginger"),
          Crop(name: "Turmeric", value: "tumeric"),
          Crop(name: "Yam", value: "yam"),
          Crop(name: "Cassava", value: "cassava"),
          Crop(name: "Sweet", value: "sweetpotato"),
          Crop(name: "Colocasia", value: "colocasia"),
          Crop(name: "Elephant", value: "elephantfootyam"),
          Crop(name: "Asparagus", value: "aspargus"),
          Crop(name: "Drumstick", value: "drumstick"),
        ];
      });
    } else if (category == "fruits") {
      setState(() {
        optionArray = [
          Crop(name: "Mango", value: "mango"),
          Crop(name: "Mandarian", value: "mandarin"),
          Crop(name: "SweetOrange", value: "sweetorange"),
          Crop(name: "Lemon", value: "lemon"),
          Crop(name: "Lime", value: "lime"),
          Crop(name: "Banana", value: "banana"),
          Crop(name: "Papaya", value: "papaya"),
          Crop(name: "Pineapple", value: "pineapple"),
          Crop(name: "Jackfruit", value: "jackfruit"),
          Crop(name: "Guava", value: "gauva"),
          Crop(name: "Litchi", value: "litchi"),
          Crop(name: "Grapes", value: "grapes"),
          Crop(name: "Apple", value: "apple"),
          Crop(name: "Pear", value: "pear"),
          Crop(name: "Peach", value: "peach"),
          Crop(name: "Kiwi", value: "kiwi"),
          Crop(name: "Plum", value: "plum"),
          Crop(name: "Dragon fruit", value: "dragonfruit"),
          Crop(name: "Strawberry", value: "strawberry"),
          Crop(name: "Pomegranate", value: "pomegranate"),
        ];
      });
    } else if (category == "flower") {
      setState(() {
        optionArray = [
          Crop(name: "Gladiolus", value: "gladiolus"),
          Crop(name: "Rose", value: "rose"),
          Crop(name: "Orchid", value: "orchid"),
          Crop(name: "Tuberose", value: "tuberose"),
          Crop(name: "Chrysanthemum", value: "chrysanthemum"),
          Crop(name: "Anthurium", value: "anthurium"),
          Crop(name: "Gerbera", value: "gerbera"),
          Crop(name: "Carnation", value: "carnation"),
          Crop(name: "Marigold", value: "marigold"),
          Crop(name: "Bird of paradise", value: "birdofparadise"),
          Crop(name: "Dahlia", value: "dahlia"),
        ];
      });
    } else if (category == "cereal") {
      setState(() {
        optionArray = [
          Crop(name: "Hybrid Rice", value: "rice_hybrid"),
          Crop(name: "Local Rice", value: "rice_local"),
          Crop(name: "Hybrid Maize", value: "maize_hybrid"),
          Crop(name: "Local Maize", value: "maize_local"),
          Crop(name: "Irrigated Wheat", value: "wheat_irrigated"),
          Crop(name: "Rainfed Wheat", value: "wheat_rainfed"),
          Crop(name: "BuckWheat", value: "buckwheat"),
          Crop(name: "Irrigated Barley", value: "barley_irrigated"),
          Crop(name: "Rainfed Barley", value: "barley_rainfed"),
          Crop(name: "Millet", value: "millet"),
        ];
      });
    } else if (category == "legume") {
      setState(() {
        optionArray = [
          Crop(name: "Lentil", value: "lentil"),
          Crop(name: "ChickPea", value: "chickpea"),
          Crop(name: "PigeonPea", value: "pigeonpea"),
          Crop(name: "BlackGram", value: "blackgram"),
          Crop(name: "GreenGram", value: "greengram"),
          Crop(name: "SoyBean", value: "soybean"),
          Crop(name: "Pea", value: "pea_grain"),
          Crop(name: "CowPea", value: "cowpea"),
          Crop(name: "HorseGram", value: "horsegram"),
        ];
      });
    } else if (category == "oilseed") {
      setState(() {
        optionArray = [
          Crop(name: "Mustard", value: "mustard"),
          Crop(name: "Rapeseed", value: "rapeseed"),
          Crop(name: "Irrigated Sunflower", value: "sunflower_irrigated"),
          Crop(name: "Rainfed Sunflower", value: "sunflower_rainfed"),
          Crop(name: "Sesamum", value: "sesamum"),
          Crop(name: "Groundnut", value: "groundnut"),
          Crop(name: "Safflower", value: "safflower"),
          Crop(name: "Castor", value: "castor"),
          Crop(name: "Niger", value: "niger"),
        ];
      });
    } else if (category == "cashcrop") {
      setState(() {
        optionArray = [
          Crop(name: "Cotton", value: "cotton"),
          Crop(name: "Sugarcane", value: "sugarcane"),
          Crop(name: "Capsularis Jute", value: "jute_capsularis"),
          Crop(name: "Olitorius Jute", value: "jute_olitorius"),
          Crop(name: "Virginia Tobacco", value: "tobacco_virginia"),
          Crop(
              name: "Natu & Belachapi Tobacco",
              value: "tobacco_natu_belachapi"),
          Crop(name: "Tea", value: "tea"),
          Crop(name: "Coffee", value: "cofee"),
          Crop(name: "Cardamom", value: "cardamon"),
        ];
      });
    } else {
      setState(() {
        optionArray = [];
      });
    }
  }
}

class Crop {
  final String name;
  final String value;

  const Crop({this.name, this.value});
}

class Unit {
  const Unit(
    this.name,
  );
  final String name;
}
