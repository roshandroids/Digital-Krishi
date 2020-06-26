import 'dart:async';

import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class ReadNews extends StatefulWidget {
  final String url;

  ReadNews({
    @required this.url,
  });
  @override
  _ReadnewsState createState() => _ReadnewsState();
}

class _ReadnewsState extends State<ReadNews> {
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
            ? WebviewScaffold(
                url: widget.url,
                javascriptChannels: jsChannels,
                mediaPlaybackRequiresUserGesture: false,
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.chevron_left),
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
                    child: SpinKitWave(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          flutterWebViewPlugin.goBack();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          flutterWebViewPlugin.goForward();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.autorenew),
                        onPressed: () {
                          flutterWebViewPlugin.reload();
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                body: Offline(),
              );
      },
      child: Container(),
    );
  }
}
