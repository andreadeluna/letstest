import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'webview_container.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  HomePage(this.status, this.cronologia);

  String status;
  String cronologia;
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
            backgroundColor: Colors.lightBlue,
            /*appBar: AppBar(
              title: Text(
                'Progetto Tirocinio',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
              backgroundColor: Colors.lightBlue,
            ),*/
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.topCenter, colors: [
                  Colors.lightBlue[800],
                  Colors.lightBlue[700],
                  Colors.lightBlue[300],
                ])),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Scelta portale",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.blue[900],
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _handleURLButtonPress(
                                    context, _linktolc, dominiotolc);
                                Wakelock.enable();
                              },
                              child: Image.asset('images/tolc.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.blue[900],
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _handleURLButtonPress(
                                    context, _linkinvalsi, dominioinvalsi);
                                Wakelock.enable();
                              },
                              child: Image.asset('images/invalsi.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.blue[900],
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _handleURLButtonPress(
                                    context, _linkblended, dominioblended);
                                Wakelock.enable();
                              },
                              child: Image.asset('images/uniurb.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            builder: (context) =>
                WebViewContainer(url, status, dominio, cronologia)));
  }
}
