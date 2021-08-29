import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:wakelock/wakelock.dart';
import 'riepilogo.dart';

// Schermata contenente il portale selezionato
class WebViewContainer extends StatefulWidget {

  // *** Dichiarazione variabili ***
  final url;
  String status;
  String cronologia;
  String dominio;

  WebViewContainer(this.url, this.status, this.dominio, this.cronologia);

  // Definizione schermata portale
  @override
  createState() =>
      _WebViewContainerState(this.url, status, dominio, cronologia);
}


class _WebViewContainerState extends State<WebViewContainer> {

  // *** Dichiarazione variabili ***
  String status;
  String cronologia;
  String dominio;
  var _url;
  String focusStat = '';
  int esci = 0;
  int focusAttuale;
  String sitoAttuale = '';

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  final _resumeDetectorKey = UniqueKey();

  DateTime onFocus = new DateTime.now(), lostFocus = new DateTime.now();

  final _key = UniqueKey();

  _WebViewContainerState(this._url, this.status, this.dominio, this.cronologia);

  // Azione da compiere se l'utente indica di voler tornare alla schermata precedente
  Future<bool> _onBackPressed() {
    // Visualizzazione messaggio di alert
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 150,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    children: [
                      Text("Attenzione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                      SizedBox(height: 5),
                      Text("Vuoi realmente uscire?", style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 60,
                  child: Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              child: Text('No', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Si', style: TextStyle(fontSize: 20)),
              onPressed: () {

                esci = 1;
                lostFocus = DateTime.now();

                //Accesso alla schermata di riepilogo
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
        )
    );
  }


  // Widget di costruzione della schermata del portale
  @override
  Widget build(BuildContext context) {
    // Controllo se l'utente indica di volere tornare alla schermata precedente
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        // Controllo se l'utente esce dall'app
        home: FocusDetector(
          key: _resumeDetectorKey,
          child: Scaffold(
            // Impedisco all'app di ridimensionarsi
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Colors.lightBlue[800],
                Colors.lightBlue[700],
                Colors.lightBlue[300],
              ],
                  ),
              ),
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
                          // Visualizzo il portale
                          child: WebView(
                              key: _key,
                              javascriptMode: JavascriptMode.unrestricted,
                              initialUrl: _url,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                _controller.complete(webViewController);
                              },
                              navigationDelegate: (NavigationRequest request) {

                                // Controllo se l'utente naviga in pagine diverse da quelle del portale
                                if (!(request.url.contains(dominio))) {
                                  sitoAttuale =
                                      'TENTATIVO DI ACCESSO A\n${request.url}\n\n  ';
                                  cronologia += sitoAttuale;

                                  // Visualizzo un toast di errore
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
                                return NavigationDecision.navigate;
                              },

                            // Salvo la cronologia dei siti visitati
                              onPageStarted: (String url) {
                                sitoAttuale = url + '\n\n  ';
                                cronologia += sitoAttuale;
                              },
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  // Pulsante di termine prova
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
                    // Visualizzazione messaggio di alert
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              AlertDialog(
                                backgroundColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                content: Stack(
                                  overflow: Overflow.visible,
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      height: 150,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                                        child: Column(
                                          children: [
                                            Text("Attenzione", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),),
                                            SizedBox(height: 5),
                                            Text("Vuoi terminare la prova?", style: TextStyle(fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -60,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 60,
                                        child: Icon(Icons.assignment_turned_in, color: Colors.white, size: 50,),
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('No', style: TextStyle(fontSize: 20)),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Si', style: TextStyle(fontSize: 20)),
                                    onPressed: () {
                                      esci = 1;
                                      lostFocus = DateTime.now();
                                      print(cronologia);

                                      //Accesso alla schermata di riepilogo
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
                              )
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          // Se rilevo che l'utente è entrato nell'app
          onFocusGained: () {
            focusAttuale = 0;
            onFocus = DateTime.now();
            focusStat = 'PORTALE:\nFocus acquisito a $onFocus\n\n  ';
            status += focusStat;

            // Visualizzo un toast di accesso al portale
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

          // Se rilevo che l'utente è uscito dall'app
          onFocusLost: () {
            focusAttuale += 1;
            lostFocus = DateTime.now();
            if (focusAttuale == 1) {
              focusStat =
                  'PORTALE:\nFocus perso a $lostFocus\nTempo mantenimento focus: ${lostFocus.difference(onFocus)}\n\n  ';
              status += focusStat +
                  ((esci == 0)
                      ? 'RILEVATA USCITA\n\n  '
                      : 'TERMINE PROVA\n\n  ');
            }
          },
        ),
      ),
    );
  }
}
