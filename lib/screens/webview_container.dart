import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';

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
  int _currentIndex = 0;

  _WebViewContainerState(this._url);

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Vuoi realmente uscire?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('Si'),
                  onPressed: () {
                    Navigator.pop(context, true);
                    Wakelock.disable();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        home: FocusDetector(
          key: _resumeDetectorKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Bozza Progetto'),
              backgroundColor: Colors.lightBlue,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  title: Text('Test'),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_turned_in),
                  title: Text('Fine'),
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            body: Column(
              children: [
                Expanded(
                  child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url,
                  ),
                ),
                /*Expanded(
                  child: Form(
                    onWillPop: _onBackPressed,
                  ),
                )*/
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
      ),
    );
  }
}
