import 'dart:async';
import 'package:flutter/material.dart';
import 'package:progettotirocinio/screens/form_screen.dart';

// Schermata iniziale: visualizzazione splash screen
class App extends StatelessWidget {

  // *** Dichiarazione variabili ***
  String status;
  String cronologia;

  App(this.status, this.cronologia);

  // Definizione schermata iniziale
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(status, cronologia),
    );
  }
}

// Implementazione splash screen
class SplashScreen extends StatefulWidget {

  // *** Dichiarazione variabili ***
  String status;
  String cronologia;

  SplashScreen(this.status, this.cronologia);

  // Chiamata al costruttore del widget
  @override
  _SplashScreenState createState() => _SplashScreenState(status, cronologia);
}

// Implementazione del costruttore del widget
class _SplashScreenState extends State<SplashScreen> {

  // *** Dichiarazione variabili ***
  String status;
  String cronologia;

  _SplashScreenState(this.status, this.cronologia);

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
                builder: (context) => FormScreen(status, cronologia)));
      },
    );
  }

  // Widget di costruzione della schermata splash screen
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
