import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewResult extends StatefulWidget {
  ViewResult(html);

  @override
  _ViewResultState createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
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
        appBar: AppBar(
          centerTitle: true,
          title: Text("Calculation Result"),
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
        body: SafeArea(
            child: FutureBuilder<String>(
          future: _read(), // async work
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  children: <Widget>[
                    SpinKitWave(
                      color: Colors.blue,
                      size: 40,
                    ),
                    Text(
                      'Fecthing Result..',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                );
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
        )));
  }
}
