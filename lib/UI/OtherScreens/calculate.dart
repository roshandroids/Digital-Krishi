import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class Calculate extends StatefulWidget {
  final String url;
  final String title;

  Calculate({@required this.url, @required this.title});
  @override
  _CalculateState createState() => _CalculateState();
}

class _CalculateState extends State<Calculate> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        bool connected = connectivity != ConnectivityResult.none;
        return connected
            ? Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: WebviewScaffold(
                  url: widget.url,
                  javascriptChannels: jsChannels,
                  mediaPlaybackRequiresUserGesture: false,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(widget.title),
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
                          flutterWebViewPlugin.close();
                          Navigator.of(context).pop();
                        }),
                  ),
                  withZoom: true,
                  withLocalStorage: true,
                  hidden: true,
                  initialChild: Container(
                    color: Colors.white30,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SpinKitWave(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                          Text(
                            "Fetching Data..",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                      Color(0xff1D976C),
                      Color(0xff11998e),
                      Color(0xff1D976C),
                    ])),
                  ),
                  title: Text("Latest Price List"),
                  leading: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                      onPressed: () async {
                        flutterWebViewPlugin.close();
                        Navigator.of(context).pop();
                      }),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Offline(),
                    ],
                  ),
                ),
              );
      },
      child: Container(),
    );
  }
}
