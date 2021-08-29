import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progettotirocinio/schermate/inserimento_dati.dart';

// Schermata iniziale: visualizzazione splash screen
class App extends StatelessWidget {

  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  App(this.azioni, this.cronologia);

  // Definizione schermata iniziale
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(azioni, cronologia),
    );
  }
}

// Implementazione splash screen
class SplashScreen extends StatefulWidget {

  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  SplashScreen(this.azioni, this.cronologia);

  // Definizione della splash screen
  @override
  _SplashScreenState createState() => _SplashScreenState(azioni, cronologia);
}

// Implementazione della splash screen
class _SplashScreenState extends State<SplashScreen> {

  // *** Dichiarazione variabili ***
  String azioni;
  String cronologia;

  _SplashScreenState(this.azioni, this.cronologia);

  // Visualizzazione della splash screen per 3 secondi
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        // Apertura schermata di inserimento dati
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FormScreen(azioni, cronologia)));
      },
    );
  }

  // Widget di costruzione della schermata di splash screen
  @override
  Widget build(BuildContext context) {
    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.lightBlue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/splash.png', height: 150),
                SizedBox(height: 40),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
