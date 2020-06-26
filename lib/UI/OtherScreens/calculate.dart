import 'package:flutter/material.dart';
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

  Calculate({
    @required this.url,
  });
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
    return WebviewScaffold(
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
      withZoom: false,
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
        elevation: 10,
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
          ],
        ),
      ),
    );
  }
}
