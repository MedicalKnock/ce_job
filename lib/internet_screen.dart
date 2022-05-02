//internet_select.dart
import 'package:ce_job/internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InternetScreen extends StatelessWidget {
  InternetScreen(this.url);
  final String url;
  late WebViewController _webViewController;
  double _currentPositionX = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
          title: Text(''),
        ),
        body:Stack(
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) async {
                _webViewController = controller;
              },
            ),
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                _currentPositionX = details.primaryDelta!.toDouble();
              },
              onHorizontalDragEnd: (details) async {
                print(_currentPositionX);
                if (_currentPositionX > 0) {
                  if (await _webViewController.canGoBack()) {
                    await _webViewController.goBack();
                    print('もどる');
                  }
                }
              },
                 child: Container(width: 100,),
            ),
          ],
        ),
    );
  }
}