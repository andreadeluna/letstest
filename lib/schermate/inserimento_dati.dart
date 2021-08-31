import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'scelta_portale.dart';

// Schermata di inserimento dati
class InserimentoDati extends StatefulWidget {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  InserimentoDati(this.azioni, this.cronologia);

  // Definizione schermata di inserimento dati
  @override
  State<StatefulWidget> createState() {
    return InserimentoDatiState(azioni, cronologia);
  }
}

// Implementazione schermata di acquisizione dati
class InserimentoDatiState extends State<InserimentoDati> {
  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;
  String aggiornaAzioni = '';
  String nome;
  String email;
  String numeroTelefono;

  DateTime dataSvolgimento = new DateTime.now();

  String giorno;
  String mese;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  InserimentoDatiState(this.azioni, this.cronologia);

  // Widget di acquisizione del nome
  Widget _buildNome() {
    // Controllo su formato data
    (dataSvolgimento.month < 10)
        ? mese = '0' + '${dataSvolgimento.month}'
        : mese = '${dataSvolgimento.month}';

    (dataSvolgimento.day < 10)
        ? giorno = '0' + '${dataSvolgimento.day}'
        : giorno = '${dataSvolgimento.day}';

    return TextFormField(
      decoration: InputDecoration(labelText: 'Nome e cognome'),
      validator: (String valore) {
        if (valore.isEmpty) {
          return 'Il nome è richiesto';
        }

        return null;
      },
      onSaved: (String valore) {
        nome = valore;
      },
    );
  }

  // Widget di acquisizione dell'indirizzo e-mail
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'E-mail'),
      validator: (String valore) {
        if (valore.isEmpty) {
          return 'La mail è richiesta';
        }

        // Validazione indirizzo inserito
        if (!RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
            .hasMatch(valore)) {
          return 'Perfavore, inserire un indirizzo email valido';
        }

        return null;
      },
      onSaved: (String valore) {
        email = valore;
      },
    );
  }

  // Widget di acquisizione del numero di telefono
  Widget _buildNumeroTelefono() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Numero di telefono'),
      keyboardType: TextInputType.phone,
      validator: (String valore) {
        if (valore.isEmpty) {
          return 'Il numero di telefono è richiesto';
        }

        return null;
      },
      onSaved: (String valore) {
        numeroTelefono = valore;
      },
    );
  }

  // Widget di costruzione della schermata di acquisizione dati
  @override
  Widget build(BuildContext context) {
    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          // Impedisco all'app di ridimensionarsi
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 0),
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
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Inserimento dati",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 60),
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
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]),
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        // Acquisizione dei dati
                                        _buildNome(),
                                        _buildEmail(),
                                        _buildNumeroTelefono(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }

                              _formKey.currentState.save();

                              aggiornaAzioni =
                                  'DATA SVOLGIMENTO: ${giorno}/${mese}/${dataSvolgimento.year}\n\n  '
                                  'DATI:\n  Nome: $nome\nEmail: $email\nTelefono: $numeroTelefono\n\n  ';
                              azioni += aggiornaAzioni;

                              // Accesso alla schermata di scelta del portale ed invio dati
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      azioni + 'INVIO DATI\n\n  ', cronologia),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.lightBlue[900]),
                              child: Center(
                                child: Text(
                                  "Invia",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}
