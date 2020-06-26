import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();
  var _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FocusDetector(
        key: _resumeDetectorKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Bozza Progetto'),
            backgroundColor: Colors.teal,
          ),
          body: Column(
            children: [
              Expanded(
                child: WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: _url,
                ),
              )
            ],
          ),
        ),
        onFocusGained: () {
          onFocus = DateTime.now();
          print('PORTALE:');
          print(
              'Focus acquisito a $onFocus, equivalente a onResume o viewDidAppear');
          print('Tempo perdita focus:');
          print(onFocus.difference(lostFocus));
          Fluttertoast.showToast(
              msg: "Accesso al Portale",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        onFocusLost: () {
          lostFocus = DateTime.now();
          print('PORTALE:');
          print(
              'Focus perso a $lostFocus, equivalente a onPause o viewDidDisappear');
          print('Tempo mantenimento focus:');
          print(lostFocus.difference(onFocus));
        },
      ),
    );
  }
}
