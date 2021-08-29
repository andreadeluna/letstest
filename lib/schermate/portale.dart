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
  String azioni;
  String cronologia;
  String dominio;
  final url;

  WebViewContainer(this.url, this.azioni, this.dominio, this.cronologia);

  // Definizione schermata portale
  @override
  createState() =>
      _WebViewContainerState(this.url, azioni, dominio, cronologia);
}

class _WebViewContainerState extends State<WebViewContainer> {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;
  String dominio;
  var url;
  String aggiornaAzioni = '';
  String aggiornaCronologia = '';
  int esci = 0;
  int controlloFocus;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _resumeDetectorKey = UniqueKey();

  DateTime focusAcquisito = new DateTime.now(), focusPerso = new DateTime.now();

  String ore;
  String minuti;
  String secondi;

  final _key = UniqueKey();

  _WebViewContainerState(this.url, this.azioni, this.dominio, this.cronologia);

  // Azione da compiere se l'utente indica di voler tornare alla schermata precedente
  Future<bool> _gestisciBack() {
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
                          Text(
                            "Attenzione",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 23),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Vuoi realmente uscire?",
                            style: TextStyle(fontSize: 18),
                          ),
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
                    focusPerso = DateTime.now();

                    //Accesso alla schermata di riepilogo
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Risultato(
                                azioni +
                                    'PORTALE:\nFocus perso a $focusPerso\nTempo mantenimento focus: ${focusPerso.difference(focusAcquisito)}\n\n  TERMINE PROVA\n\n  ',
                                cronologia)));
                    Wakelock.disable();
                  },
                ),
              ],
            ));
  }

  // Widget di costruzione della schermata del portale
  @override
  Widget build(BuildContext context) {
    // Controllo se l'utente indica di volere tornare alla schermata precedente
    return WillPopScope(
      onWillPop: _gestisciBack,
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
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
                            initialUrl: url,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controller.complete(webViewController);
                            },
                            navigationDelegate: (NavigationRequest request) {
                              // Controllo se l'utente naviga in pagine diverse da quelle del portale
                              if (!(request.url.contains(dominio))) {
                                aggiornaCronologia =
                                    'TENTATIVO DI ACCESSO A\n${request.url}\n\n  ';
                                cronologia += aggiornaCronologia;

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
                              aggiornaCronologia = url + '\n\n  ';
                              cronologia += aggiornaCronologia;
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
                        color: Colors.red[900],
                      ),
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
                                        padding:
                                            EdgeInsets.fromLTRB(10, 70, 10, 10),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Attenzione",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "Vuoi terminare la prova?",
                                              style: TextStyle(fontSize: 18),
                                            ),
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
                                          Icons.assignment_turned_in,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('No',
                                        style: TextStyle(fontSize: 20)),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Si',
                                        style: TextStyle(fontSize: 20)),
                                    onPressed: () {
                                      esci = 1;
                                      focusPerso = DateTime.now();

                                      // // Controllo su formato ora
                                      (focusPerso.hour < 10)
                                          ? ore = '0' + '${focusPerso.hour}'
                                          : ore = '${focusPerso.hour}';

                                      (focusPerso.minute < 10)
                                          ? minuti = '0' + '${focusPerso.minute}'
                                          : minuti = '${focusPerso.minute}';

                                      (focusPerso.second < 10)
                                          ? secondi = '0' + '${focusPerso.second}'
                                          : secondi = '${focusPerso.second}';

                                      //Accesso alla schermata di riepilogo
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Risultato(
                                                  azioni +
                                                      'PORTALE:\nFocus perso alle ore ${ore}:${minuti}:${secondi}\nTempo mantenimento focus: ${focusPerso.difference(focusAcquisito)}\n\n  TERMINE PROVA\n\n  ',
                                                  cronologia)));
                                      Wakelock.disable();
                                    },
                                  ),
                                ],
                              ));
                    },
                  )
                ],
              ),
            ),
          ),
          // Se rilevo che l'utente è entrato nell'app
          onFocusGained: () {
            controlloFocus = 0;
            focusAcquisito = DateTime.now();

            // Controllo su formato data
            (focusAcquisito.hour < 10)
                ? ore = '0' + '${focusAcquisito.hour}'
                : ore = '${focusAcquisito.hour}';

            (focusAcquisito.minute < 10)
                ? minuti = '0' + '${focusAcquisito.minute}'
                : minuti = '${focusAcquisito.minute}';

            (focusAcquisito.second < 10)
                ? secondi = '0' + '${focusAcquisito.second}'
                : secondi = '${focusAcquisito.second}';

            aggiornaAzioni =
                'PORTALE:\nFocus acquisito alle ore ${ore}:${minuti}:${secondi}\n\n  ';
            azioni += aggiornaAzioni;

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
            controlloFocus += 1;
            focusPerso = DateTime.now();

            // Controllo su formato data
            (focusPerso.hour < 10)
                ? ore = '0' + '${focusPerso.hour}'
                : ore = '${focusPerso.hour}';

            (focusPerso.minute < 10)
                ? minuti = '0' + '${focusPerso.minute}'
                : minuti = '${focusPerso.minute}';

            (focusPerso.second < 10)
                ? secondi = '0' + '${focusPerso.second}'
                : secondi = '${focusPerso.second}';

            if (controlloFocus == 1) {
              aggiornaAzioni =
                  'PORTALE:\nFocus perso alle ore ${ore}:${minuti}:${secondi}\nTempo mantenimento focus: ${focusPerso.difference(focusAcquisito)}\n\n  ';
              azioni += aggiornaAzioni +
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
