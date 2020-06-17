import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarketRate extends StatefulWidget {
  @override
  _MarketRateState createState() => _MarketRateState();
}

class _MarketRateState extends State<MarketRate> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
                initialUrl:
                    'https://nepalicalendar.rat32.com/vegetable/embed.php',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (String finished) {
                  setState(() {
                    isLoading = false;
                  });
                }),
            isLoading
                ? Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Fetching Data...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
