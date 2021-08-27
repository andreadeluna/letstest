import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';
import 'risultato.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  String status;
  String dominio;
  String cronologia;

  WebViewContainer(this.url, this.status, this.dominio, this.cronologia);

  @override
  createState() =>
      _WebViewContainerState(this.url, status, dominio, cronologia);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();
  var _url;
  final _key = UniqueKey();
  int _currentIndex = 0;
  String status;
  String cronologia;
  String dominio;

  _WebViewContainerState(this._url, this.status, this.dominio, this.cronologia);

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Vuoi realmente uscire?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text('Si'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Risultato(status, cronologia)));
                    Wakelock.disable();
                  },
                )
              ],
            ));
  }

  @override
  String focusStat = '';
  int esci = 0;
  int focusAttuale;
  String sitoAttuale = '';

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        home: FocusDetector(
          key: _resumeDetectorKey,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            /*bottomNavigationBar: BottomNavigationBar(
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
                  if (index == 1) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Vuoi terminare la prova?'),
                              actions: [
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Si'),
                                  onPressed: () {
                                    esci = 1;
                                    lostFocus = DateTime.now();
                                    print(cronologia);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Risultato(
                                                status +
                                                    'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  TERMINE PROVA\n\n  ',
                                                cronologia)));
                                    Wakelock.disable();
                                  },
                                )
                              ],
                            ));
                  }
                },),*/
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.lightBlue[800],
                Colors.lightBlue[700],
                Colors.lightBlue[300],
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Portale",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: WebView(
                              key: _key,
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: _url,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controller.complete(webViewController);
                              },
                              navigationDelegate: (NavigationRequest request) {
                                if (!(request.url.contains(dominio))) {
                                  print('blocking navigation to $request}');
                                  sitoAttuale =
                                      'TENTATIVO DI ACCESSO A\n${request.url}\n\n  ';
                                  cronologia += sitoAttuale;
                                  Fluttertoast.showToast(
                                    msg: "Non è possibile uscire dal portale",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  return NavigationDecision.prevent;
                                }
                                print('allowing navigation to $request');
                                return NavigationDecision.navigate;
                              },
                              onPageStarted: (String url) {
                                print('Page started loading: $url');
                                //listUrl.add(url);
                                sitoAttuale = url + '\n\n  ';
                                cronologia += sitoAttuale;
                              },
                              onPageFinished: (String url) {
                                print('Page finished loading: $url');
                                //listUrl.add(url);
                                //print(listUrl);
                                //sitoAttuale = 'SITO ' + url + '\n\n  ';
                                //cronologia += sitoAttuale;
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red[900]),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_turned_in,
                              color: Colors.black,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "TERMINA IL TEST",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Vuoi terminare la prova?'),
                                actions: [
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Si'),
                                    onPressed: () {
                                      esci = 1;
                                      lostFocus = DateTime.now();
                                      print(cronologia);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Risultato(
                                                  status +
                                                      'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  TERMINE PROVA\n\n  ',
                                                  cronologia)));
                                      Wakelock.disable();
                                    },
                                  )
                                ],
                              ));
                    },
                  )
                ],
              ),
            ),
          ),
          onFocusGained: () {
            focusAttuale = 0;
            onFocus = DateTime.now();
            print('PORTALE:');
            print('Focus acquisito a $onFocus');
            focusStat = 'PORTALE:\nFocus acquisito a $onFocus\n\n  ';
            status += focusStat;
            Fluttertoast.showToast(
              msg: "Accesso al Portale",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          onFocusLost: () {
            focusAttuale += 1;
            lostFocus = DateTime.now();
            print('PORTALE:');
            print('Focus perso a $lostFocus');
            print('Tempo mantenimento focus:');
            print(lostFocus.difference(onFocus));
            if (focusAttuale == 1) {
              focusStat =
                  'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  ';
              status += focusStat +
                  ((esci == 0)
                      ? 'RILEVATA USCITA\n\n  '
                      : 'TERMINE PROVA\n\n  ');
              print(status);
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Risultato(status +
                          ((esci == 0)
                              ? 'PROBABILE USCITA ERRONEA\n\nTERMINE PROVA\n\n'
                              : 'TERMINE PROVA\n\n'))));*/
            }
          },
        ),
      ),
    );
  }
}
