import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'portale.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';

// Schermata di homepage (scelta del portale)
class HomePage extends StatelessWidget {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;
  String aggiornaAzioni = '';

  // Link relativi ai portali disponibili
  final linkTolc =
      'https://www.cisiaonline.it/area-tematica-tolc-cisia/home-tolc-generale/';
  final linkInvalsi = 'https://www.proveinvalsi.net/';
  final linkBlended = 'https://blended.uniurb.it/moodle/';

  // Parole che devono essere contenute all'interno dei link pena impossibilità di navigazione
  final dominioTolc = '.cisiaonline';
  final dominioInvalsi = 'invalsi';
  final dominioBlended = '.uniurb';

  HomePage(this.azioni, this.cronologia);

  // Widget di costruzione della schermata di homepage (scelta del portale)
  @override
  Widget build(BuildContext context) {
    // Visualizzazione toast di accesso alla homepage
    Fluttertoast.showToast(
        msg: "Accesso alla Homepage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);

    aggiornaAzioni = 'ACCESSO ALLA HOMEPAGE\n\n  ';
    azioni += aggiornaAzioni;

    // Nascondo la barra di stato del dispositivo e i tasti a sfioramento
    SystemChrome.setEnabledSystemUIOverlays([]);

    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Center(
          child: Scaffold(
            // Pulsante per aprire la bottom sheet relativa al Form Google
            floatingActionButton: FloatingButton(azioni, cronologia),
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30),
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
                              width: 2,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                aggiornaAzioni =
                                    'SELEZIONATO PORTALE TOLC\n\n  ';
                                azioni += aggiornaAzioni;

                                // Impedisco la sospensione dello schermo
                                Wakelock.enable();
                                _accediAlPortale(
                                    context, linkTolc, dominioTolc);
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
                              width: 2,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                aggiornaAzioni =
                                    'SELEZIONATO PORTALE INVALSI\n\n  ';
                                azioni += aggiornaAzioni;

                                // Impedisco la sospensione dello schermo
                                Wakelock.enable();
                                _accediAlPortale(
                                    context, linkInvalsi, dominioInvalsi);
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
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                aggiornaAzioni =
                                    'SELEZIONATO PORTALE BLENDED\n\n  ';
                                azioni += aggiornaAzioni;

                                // Impedisco la sospensione dello schermo
                                Wakelock.enable();
                                _accediAlPortale(
                                    context, linkBlended, dominioBlended);
                              },
                              child: Image.asset('images/uniurb.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Gestione tap sul pulsante relativo al portale scelto
  void _accediAlPortale(BuildContext context, String url, String dominio) {
    aggiornaAzioni = 'ACCESSO AL PORTALE\n\n  ';
    azioni += aggiornaAzioni;

    // Accesso alla pagina del portale
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Portale(url, azioni, dominio, cronologia)));
  }
}

// Pulsante per inserimento link a Google Form e bottom sheet
class FloatingButton extends StatefulWidget {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  FloatingButton(this.azioni, this.cronologia);

  // Definizione del pulsante
  @override
  _FloatingButtonState createState() =>
      _FloatingButtonState(azioni, cronologia);
}

// Implementazione del pulsante e della bottom sheet
class _FloatingButtonState extends State<FloatingButton> {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;
  String aggiornaAzioni = '';

  // Variabile per visualizzare o nascondere il pulsante
  bool mostraPulsante = true;

  // Link relativo al Form Google
  String linkForm;

  // Parola che deve essere contenuta all'interno dei link pena impossibilità di navigazione
  String dominioForm = "docs.google.com/forms";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _FloatingButtonState(this.azioni, this.cronologia);

  // Widget di acquisizione del link al Form Google
  Widget _buildLink() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Link Form'),
      validator: (String valore) {
        if (valore.isEmpty) {
          return 'Il link è richiesto';
        }

        return null;
      },
      onSaved: (String valore) {
        linkForm = valore;
      },
    );
  }

  // Widget di costruzione del pulsante e della bottom sheet
  @override
  Widget build(BuildContext context) {
    // Visualizzazione pulsante
    return mostraPulsante
        ? FloatingActionButton.extended(
            label: Text(
              "Google Form",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.assignment, color: Colors.black),
            backgroundColor: Colors.grey,
            onPressed: () {
              // Visualizzazione bottom sheet
              var sheetController = showBottomSheet(
                context: context,
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                builder: (context) => Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  height: 360,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[900],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "Accesso a Google Form",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 31,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Inserisci il link del Form Google",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.lightBlue[100],
                                          blurRadius: 20,
                                          offset: Offset(0, 10),
                                        )
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: <Widget>[
                                              // Acquisizione del link
                                              _buildLink(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }

                                    _formKey.currentState.save();

                                    print('LINK FORM: ' + linkForm);

                                    if ((linkForm.contains(dominioForm))) {
                                      aggiornaAzioni =
                                          'SELEZIONATO GOOGLE FORM\n\n  ';
                                      azioni += aggiornaAzioni;

                                      // Impedisco la sospensione dello schermo
                                      Wakelock.enable();

                                      // Accedo alla schermata del portale
                                      HomePage(azioni, cronologia)
                                          ._accediAlPortale(
                                              context, linkForm, dominioForm);
                                    } else {
                                      // Se il link non riguarda un Form Google segnalo l'errore
                                      Fluttertoast.showToast(
                                          msg:
                                              "Link errato: Inserire Form Google",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.blueGrey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                      left: 50,
                                      right: 50,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.lightBlue[900],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Invia",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              _mostraPulsante(false);
              sheetController.closed.then((value) {
                _mostraPulsante(true);
              });
            },
          )
        : Container();
  }

  // Gestione visualizzazione pulsante
  void _mostraPulsante(bool valore) {
    setState(() {
      mostraPulsante = valore;
    });
  }
}
