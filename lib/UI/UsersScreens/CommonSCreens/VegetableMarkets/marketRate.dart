import 'dart:async';

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

class MarketRate extends StatefulWidget {
  final String url;

  MarketRate({
    @required this.url,
  });
  @override
  _MarketRateState createState() => _MarketRateState();
}

class _MarketRateState extends State<MarketRate> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;

  final _history = [];

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.close();

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    // _onDestroy.cancel();

    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();

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
                child: WebviewScaffold(
                  url: widget.url,
                  javascriptChannels: jsChannels,
                  mediaPlaybackRequiresUserGesture: false,
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text("Latest Price List"),
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
                backgroundColor: Colors.white,
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
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SpinKitWave(
                              color: Colors.red,
                              type: SpinKitWaveType.start,
                              size: 50.0,
                            ),
                            Text(
                              "OOPS, Looks Like your Internet is not working!",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
      child: Container(),
    );
  }
}
