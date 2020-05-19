import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  final _resumeDetectorKey = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Test Preliminari',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: FocusDetector(
          key: _resumeDetectorKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Test Preliminari'),
            ),
            body: WebView(
              initialUrl:
                  'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          ),
          onFocusGained: () {
            onFocus = DateTime.now();
            print('Tempo perdita focus:');
            print(onFocus.difference(lostFocus));
            print(
                'Focus acquisito a $onFocus, equivalente a onResume o viewDidAppear');
          },
          onFocusLost: () {
            lostFocus = DateTime.now();
            print(
                'Focus perso a $lostFocus, equivalente a onPause o viewDidDisappear');
            print('Tempo mantenimento focus:');
            print(lostFocus.difference(onFocus));
          },
        ),
      );
}
