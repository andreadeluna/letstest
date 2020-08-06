import 'package:flutter/material.dart';
import 'package:focusdetector/screens/risultato.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  String status;

  WebViewContainer(this.url, this.status);

  @override
  createState() => _WebViewContainerState(this.url, status);
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _resumeDetectorKey = UniqueKey();
  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();
  var _url;
  final _key = UniqueKey();
  int _currentIndex = 0;
  String status;

  _WebViewContainerState(this._url, this.status);

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
                            builder: (context) => Risultato(status)));
                    Wakelock.disable();
                  },
                )
              ],
            ));
  }

  @override
  String focusStat = '';

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
                  if (index == 1) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Vuoi terminare la prova?'),
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
//                    lostFocus = DateTime.now();
//                    focusStat =
//                        'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\nPREMUTO PULSANTE BACK\n\n';
//                    status += focusStat;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Risultato(status)));
                                    Wakelock.disable();
                                  },
                                )
                              ],
                            ));
                  }

                  /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Risultato(status)));*/
                }
                /*setState(() {
                  _currentIndex = index;
                });*/

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
            print('Focus acquisito a $onFocus');
            focusStat = 'PORTALE:\nFocus acquisito a $onFocus\n\n';
            status += focusStat;
            //print('Tempo perdita focus:');
            //print(onFocus.difference(lostFocus));
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
            lostFocus = DateTime.now();
            print('PORTALE:');
            print('Focus perso a $lostFocus');
            print('Tempo mantenimento focus:');
            print(lostFocus.difference(onFocus));
            focusStat =
                'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n';
            status += focusStat;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Risultato(status + 'TERMINE PROVA\n\n')));
          },
        ),
      ),
    );
  }
}
