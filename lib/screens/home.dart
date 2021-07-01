import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'webview_container.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  HomePage(this.status);

  String status;
  int focusFlag;
  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();
  final _linktolc =
      'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/';
  final _linkinvalsi = 'https://www.proveinvalsi.net/';
  final _linkblended = 'https://blended.uniurb.it/moodle/';
  final dominiotolc = 'cisiaonline';
  final dominioinvalsi = 'invalsi';
  final dominioblended = 'uniurb';

  @override
  String focusStat = '';
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      home: Center(
        child: FocusDetector(
          key: _resumeDetectorKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Progetto Tirocinio',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        _handleURLButtonPress(context, _linktolc, dominiotolc);
                        Wakelock.enable();
                      },
                      child: Image.asset('images/tolc.png'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        _handleURLButtonPress(
                            context, _linkinvalsi, dominioinvalsi);
                        Wakelock.enable();
                      },
                      child: Image.asset('images/invalsi.png'),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        _handleURLButtonPress(
                            context, _linkblended, dominioblended);
                        Wakelock.enable();
                      },
                      child: Image.asset('images/uniurb.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onFocusGained: () {
            focusFlag = 0;
            onFocus = DateTime.now();
            print('HOMEPAGE:');
            print('Focus acquisito a $onFocus');
            focusStat = 'HOMEPAGE:\nFocus acquisito a $onFocus\n\n  ';
            status += focusStat;
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
            focusFlag += 1;
            lostFocus = DateTime.now();
            print('HOMEPAGE:');
            print('Focus perso a $lostFocus');
            print('Tempo mantenimento focus:');
            print(lostFocus.difference(onFocus));
            if (focusFlag == 1) {
              focusStat =
                  'HOMEPAGE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  ';
              status += focusStat;
            }
          },
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String dominio) {
    lostFocus = DateTime.now();
    focusStat =
        'HOMEPAGE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  '
        'ACCESSO AL PORTALE\n\n  ';
    status += focusStat;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(url, status, dominio)));
  }
}
