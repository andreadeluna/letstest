import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'webview_container.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  HomePage(this.status);

  String status;
  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();
  final _linktolc =
      'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/';
  final _linkinvalsi = 'https://invalsi-areaprove.cineca.it/';

  @override
  String focusStat = '';
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Center(
      child: FocusDetector(
        key: _resumeDetectorKey,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  //padding: EdgeInsets.all(20.0),
                  child: FlatButton(
                    //color: Colors.grey,
                    //padding:
                    //EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    onPressed: () {
                      _handleURLButtonPress(context, _linktolc);
                      Wakelock.enable();
                    },
                    child: Image.asset('images/tolc.png'),
                  ),
                ),
                Expanded(
                  //padding: EdgeInsets.all(20.0),
                  child: FlatButton(
                    //color: Colors.grey,
                    //padding:
                    //EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    onPressed: () {
                      _handleURLButtonPress(context, _linkinvalsi);
                      Wakelock.enable();
                    },
                    child: Image.asset('images/invalsi.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
        onFocusGained: () {
          onFocus = DateTime.now();
          print('HOMEPAGE:');
          print('Focus acquisito a $onFocus');
          focusStat = 'HOMEPAGE:\nFocus acquisito a $onFocus\n\n';
          status += focusStat;
          //print('Tempo perdita focus:');
          //print(onFocus.difference(lostFocus));
          Fluttertoast.showToast(
              msg: "Accesso alla Homepage",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0);
        },
        onFocusLost: () {
          lostFocus = DateTime.now();
          print('HOMEPAGE:');
          print('Focus perso a $lostFocus');
          print('Tempo mantenimento focus:');
          print(lostFocus.difference(onFocus));
          focusStat =
              'HOMEPAGE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n';
          status += focusStat;
        },
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    lostFocus = DateTime.now();
    focusStat =
        'HOMEPAGE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n'
        'ACCESSO AL PORTALE\n\n';
    status += focusStat;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, status)));
  }
}
